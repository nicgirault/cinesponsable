whoami := $(shell whoami)

build-web:
	eval "$$(docker-machine env -u)" && \
	docker-compose --file docker-compose.build.yml up appbuilder && \
	sudo chown -R ${whoami}:${whoami} www && \
	docker build -t nicgirault/cinelocal .

push-web:
	docker push nicgirault/cinelocal

build-android:
	npm run build-mobile && \
	./node_modules/.bin/phonegap build android --release -- --keystore=phonegap.keystore --storePassword=indecine --alias=phonegap --password=indecine

deploy-android:
	fastlane android deploy
