1. terraform apply
2. setup jenkins : build image and push image to ECR
> docker build -t ECR_URL:latest code
> docker tag ECR_URL:latest ECR_URL:${GIT_COMMIT}
> docker push ECR_URL:latest
> docker push ECR_URL:${GIT_COMMIT}
> 
3. setup jenkins : jenkins will run: terraform and provision ECS services
> cd terraform-ecs/dev
> terraform init
> terraform apply -var express-service-count=1
> 