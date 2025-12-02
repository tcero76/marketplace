ENVIRONMENTS=~/.environments/marketplace.env
include ${ENVIRONMENTS}

# MESSAGE={"userId" => "123e4567-e89b-12d3-a456-426614174000","current_user" => "550e8400-e29b-41d4-a716-446655440000", "body": "Hola mundo!"}
msgCreateUser={"to": "arodnazs@gmail.com","subject": "test","body": "Hola mundo!"}

export TOTAL_POSTS=5
URL_EXTERNAL=http://${HOST_EXTERNAL}:${PORT_EXTERNAL}

.PHONY: sendmsg queue up kill down build exec migra scrap delay clean recomender ps buildAll tfapply tfdestroy tfssh redis deployFront dump

up:
	@docker compose --env-file ${ENVIRONMENTS} --project-directory ${PWD} \
		--project-name marketplace up -d $(filter-out $@,$(MAKECMDGOALS))

ps:
	@watch docker compose --env-file ${ENVIRONMENTS} \
		--project-directory ${PWD} \
		--project-name marketplace ps -a

down:
	@docker compose --env-file ${ENVIRONMENTS} --project-directory ${PWD} \
		--project-name marketplace down

kill:
	@docker rm -f $(filter-out $@,$(MAKECMDGOALS))

exec:
	@docker exec -it $(filter-out $@,$(MAKECMDGOALS)) /bin/bash

queue:
	@docker exec broker-job rabbitmqadmin declare queue name=$(QUEUE_NAME) durable=true

delay:
	@docker compose --env-file ${ENVIRONMENTS} exec scrap-worker python -c "from main import run_modelo_spider; run_modelo_spider.delay()"

recomender:
	@docker compose --env-file ${ENVIRONMENTS} exec recomender python -c "from main import calculate_recommendations_task; calculate_recommendations_task.delay()"

clean:
	@docker exec -it db psql marketplace tcero -c "delete from scrap.explore; delete from scrap.modelos; delete from scrap.posts;"

sendmsg:
	@docker exec broker rabbitmqadmin publish \
  		exchange=$(EVT_USER_REGISTERED_EXCHANGE) \
		routing_key=$(EVT_USER_REGISTERED_EMAIL_QUEUE) \
		payload='$(msgCreateUser)'

tfapply:
	terraform -chdir=./terraform/ apply -auto-approve

tfdestroy:
	terraform -chdir=./terraform/ destroy -auto-approve

tfssh:
	ssh root@$(terraform -chdir=./terraform/ output -raw manager_public_ip)

redis:
	@docker compose --env-file ${ENVIRONMENTS} exec -it cache redis-cli

sshManager:
	@ssh root@$(shell terraform -chdir=./terraform/ output -raw manager_public_ip)

sshWorker:
	@ssh root@$(shell terraform -chdir=./terraform/ output -raw worker_public_ip)

deployFront:
	@docker build -t tcero76/front:v0.0.0 -f front/prod/Dockerfile.prod --no-cache \
	--build-arg VITE_HOST=${HOST_URL} \
	--build-arg VITE_WS=${HOST_WS} \
	--build-arg VITE_CLIENT_ID=${CLIENT_ID} \
	--build-arg VITE_PROFILE=${PROFILE} .

deployBeat:
	@docker build -t tcero76/beat-service:v0.0.0 -f beat-service/prod/Dockerfile.prod . --no-cache

deployScrap:
	@docker build -t tcero76/scrap-service:v0.0.0 -f scrap-service/prod/Dockerfile.prod . --no-cache

deployBFF:
	@docker build -t tcero76/bff-service:v0.0.0 -f bff-service/prod/Dockerfile.prod . --no-cache

deployHydra:
	@docker build \
		--build-arg HYDRA_VERSION=${HYDRA_VERSION} \
		-t tcero76/hydra:v0.0.0 \
		-f hydra/Dockerfile \
		. --no-cache

buildAll:
	@docker compose --env-file ${ENVIRONMENTS} build --no-cache

build:
	@docker compose --env-file ${ENVIRONMENTS} \
		--project-directory ${PWD} \
		--project-name marketplace \
		build $(filter-out $@,$(MAKECMDGOALS)) --no-cache --p

migra:
	@docker run --env-file ${ENVIRONMENTS} --network ${NETWORK_APPLICATION} --rm -v ./postgres/migrations/sql:/flyway/sql flyway/flyway:latest-alpine \
	  -url=jdbc:postgresql://${POSTGRES_HOST}:${POSTGRES_PORT}/${POSTGRES_DB} \
	  -user=${POSTGRES_USER} \
	  -password=${POSTGRES_PASSWORD} \
	  -schemas=marketplace,scrap,hydra \
	  -cleanDisabled=false \
	  -locations=filesystem:/flyway/sql/migration,filesystem:/flyway/sql/seed \
	  -placeholders.URL_EXTERNAL=${URL_EXTERNAL} \
	  migrate

brokerMigra:
	@docker --env-file ${ENVIRONMENTS} \
		--network ${NETWORK_APPLICATION} \
		--project-directory ${PWD} \
		-v rabbitmq/scripts/init_rabbitmq.sh:/init_rabbitmq.sh
		--entrypoint /init_rabbitmq.sh
		--rm \
		run rabbitmqadmin:${RABBITMQ_VERSION}

scrap:
	@docker exec -it \
		beat-service celery -A main call main.run_modelo_spider

dump:
	@pg_dump \
		--data-only \
		--table=$(SCHEMA).$(TABLE) \
		--column-inserts \
		--disable-triggers \
		-h localhost \
		-p 5432 \
		-U ${POSTGRES_USER} \
		${POSTGRES_DB} > postgres/migrations/sql/seed/R__insert_$(SCHEMA)_$(TABLE).up.sql

psql:
	@psql -h localhost -U ${POSTGRES_USER} -d ${POSTGRES_DB} -p 5432
