1. terraform apply
2. Run: aws configure
3. setup jenkins : build image and push image to ECR
> COMMIT_HASH=$(echo ${GIT_COMMIT} | cut -c 1-7)
> IMAGE_TAG=${COMMIT_HASH:=latest}
> REPOSITORY_URI="240993297305.dkr.ecr.ap-southeast-1.amazonaws.com/express-ecr"
> docker build -t $REPOSITORY_URI:latest code
> docker tag $REPOSITORY_URI:latest $REPOSITORY_URI:$IMAGE_TAG
> aws ecr get-login-password --region ap-southeast-1 | docker login --username AWS --password-stdin 240993297305.dkr.ecr.ap-southeast-1.amazonaws.com
> docker push $REPOSITORY_URI:latest
> docker push $REPOSITORY_URI:$IMAGE_TAG
> params: COMMIT_ID=${GIT_COMMIT}

4. setting profile: su -u jenkins and setting duongdinhxuan_duong-admin
5. jenkins install Plugin: Parameterized Trigger
6. setup jenkins : jenkins will run: terraform and provision ECS services
> cd dev
> echo $COMMIT_ID
> COMMIT_HASH=$(echo ${COMMIT_ID} | cut -c 1-7)
> IMAGE_TAG=${COMMIT_HASH:=latest}
> terraform init
> terraform apply -auto-approve -var express-service-count=1 -var commit-id=${IMAGE_TAG}