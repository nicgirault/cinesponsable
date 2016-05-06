build-production:
	 . ./prod.env && ./node_modules/.bin/gulp build && docker build -t nicgirault/cinelocal .
push: build-production
	docker push nicgirault/cinelocal
deploy: push
	ansible-playbook -i devops/hosts/production devops/deploy.yml
