build:
	eval "$$(docker-machine env -u)" && \
	docker-compose --file docker-compose.build.yml up appbuilder && \
	docker build -t nicgirault/cinelocal .

push:
	docker push nicgirault/cinelocal
