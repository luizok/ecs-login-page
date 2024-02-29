app_path = app/
infra_path = infra/
tf_cmd = dotenv run terraform -chdir=$(infra_path)

# terraform related
init:
	$(tf_cmd) init -backend-config config.aws.tfbackend

reinit:
	$(tf_cmd) init -reconfigure -backend-config config.aws.tfbackend

validate:
	$(tf_cmd) fmt
	$(tf_cmd) validate

run:
	cd $(app_path) && dotenv -f ../.env run npm run monitor

plan:
	$(tf_cmd) plan -var-file values.tfvars

deploy:
	$(tf_cmd) apply -var-file values.tfvars

show:
	$(tf_cmd) show

destroy:
	$(tf_cmd) destroy -var-file values.tfvars


# docker related
build:
	docker build -t ecs_alb_login_server app/

push:
	aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/m6h0f1x7
	docker tag ecs_alb_login_server public.ecr.aws/m6h0f1x7/ecs_alb_login_server:latest
	docker push public.ecr.aws/m6h0f1x7/ecs_alb_login_server:latest
