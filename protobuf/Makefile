.phony: execEx, buildEx, buildGo, execGo, buildTs, execTs

buildEx:
	@docker build -f elixir/Dockerfile -t tcero76/ex-proto .

buildGo:
	@docker build -f go/Dockerfile -t tcero76/go-protoc .

buildTs:
	@docker build -f ts/Dockerfile -t tcero76/ts-protoc . --no-cache

execEx:
	@docker run --rm -v ${PWD}:/workspace -w /workspace tcero76/ex-proto --proto_path=model/ --elixir_out=elixir/ transfer.proto

execGo:
	@docker run -it --rm -v ${PWD}:/workspace -w /workspace tcero76/go-protoc --proto_path=./model/ --go_out=go transfer.proto

execTs:
	@docker run -it --rm \
	-v ${PWD}:/protoc-gen-ts \
	-w /protoc-gen-ts \
	tcero76/ts-protoc \
	--plugin=/usr/local/bin/protoc-gen-ts \
	--ts_out=ts \
	--proto_path=model/ \
	transfer.proto
