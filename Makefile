ENVIRONMENTS=~/.environments/marketplace.env
include ${ENVIRONMENTS}

# MESSAGE={"userId" => "123e4567-e89b-12d3-a456-426614174000","current_user" => "550e8400-e29b-41d4-a716-446655440000", "body": "Hola mundo!"}
msgCreateUser={"to": "arodnazs@gmail.com","subject": "test","body": "Hola mundo!"}

export TOTAL_POSTS=5
CDC_PASSWORD=${POSTGRES_CDC_PASSWORD}


.PHONY: sendmsg queue up kill down watch build exec migra scrap delay clean recomender ps buildAll

watch:
	@watch docker ps -a

up:
	@docker compose --env-file ${ENVIRONMENTS} up -d $(filter-out $@,$(MAKECMDGOALS))

ps:
	@watch docker compose --env-file ${ENVIRONMENTS} ps -a

down:
	@docker compose --env-file ${ENVIRONMENTS} down

migra:
	@docker compose --env-file ${ENVIRONMENTS} run --rm flyway \
	  -url=jdbc:postgresql://${POSTGRES_HOST}:5432/${POSTGRES_DB} \
	  -user=${POSTGRES_USER} \
	  -password=${POSTGRES_PASSWORD} \
	  -schemas=marketplace,scrap,hydra \
	  -cleanDisabled=false \
	  -locations=filesystem:/flyway/sql \
	  -placeholders.CDC_PASSWORD=${CDC_PASSWORD} \
	  migrate

brokerMigra:
	@docker compose --env-file ${ENVIRONMENTS} run --rm broker-job

kill:
	@docker rm -f $(filter-out $@,$(MAKECMDGOALS))

exec:
	@docker exec -it $(filter-out $@,$(MAKECMDGOALS)) /bin/bash

queue:
	@docker exec broker-job rabbitmqadmin declare queue name=$(QUEUE_NAME) durable=true

psql:
	@psql -h localhost -U ${POSTGRES_USER} -d ${POSTGRES_DB} -p 5432

redis:
	@docker compose --env-file ${ENVIRONMENTS} exec -it cache redis-cli

delay:
	@docker compose --env-file ${ENVIRONMENTS} exec scrap-worker python -c "from main import run_modelo_spider; run_modelo_spider.delay()"

scrap:
	@docker compose --env-file ${ENVIRONMENTS} run --rm scrap-worker scrapy crawl modelo

recomender:
	@docker compose --env-file ${ENVIRONMENTS} exec recomender python -c "from main import calculate_recommendations_task; calculate_recommendations_task.delay()"

clean:
	@docker exec -it db psql marketplace tcero -c "delete from scrap.explore; delete from scrap.modelos; delete from scrap.posts;"

sendmsg:
	@docker exec broker rabbitmqadmin publish \
  		exchange=$(RABBITMQ_USER_DB_UPDATER_EXCHANGE) \
		routing_key=$(RABBITMQ_USER_DB_UPDATER_QUEUE) \
		payload='$(msgCreateUser)'

build:
	@docker compose --env-file ${ENVIRONMENTS} build $(filter-out $@,$(MAKECMDGOALS)) --no-cache

buildAll:
	@docker compose --env-file ${ENVIRONMENTS} build --no-cache