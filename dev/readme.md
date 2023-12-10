1. terraform apply
2. Run: aws configure
3. setup jenkins : build image and push image to ECR
> COMMIT_HASH=$(echo ${GIT_COMMIT} | cut -c 1-7)
> IMAGE_TAG=${COMMIT_HASH:=latest}
> REPOSITORY_URI="240993297305.dkr.ecr.ap-southeast-1.amazonaws.com/express-ecr"

> echo "######################################################"
> docker build -t $REPOSITORY_URI:latest code
> docker tag $REPOSITORY_URI:latest $REPOSITORY_URI:$IMAGE_TAG
> echo "build doneeee"

> echo "######################################################"
> aws ecr get-login-password --region ap-southeast-1 | docker login --username AWS --password-stdin 240993297305.dkr.ecr.ap-southeast-1.amazonaws.com
> echo "login doneeee"

> echo "######################################################"
> docker push $REPOSITORY_URI:latest
> docker push $REPOSITORY_URI:$IMAGE_TAG
> echo "push doneeee"

4. setting profile: duongdinhxuan_duong-admin
5. setup jenkins : jenkins will run: terraform and provision ECS services
> cd dev
> terraform init
> terraform apply -auto-approve -var express-service-count=1
> 