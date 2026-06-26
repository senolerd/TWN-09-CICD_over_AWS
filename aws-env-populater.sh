# aws ecr describe-repositories --repository-name testa > /dev/null 2>&1
echo "Outer script started"
AWS_KID=$1
AWS_KEY=$2
AWS_REGION=$3

alias aws="podman run --rm -e AWS_ACCESS_KEY_ID=$AWS_KID \
-e AWS_SECRET_ACCESS_KEY=$AWS_KEY +AWS_DEFAULT_REGION=$AWS_REGION \
docker.io/amazon/aws-cli" 

aws ecr describe-repositories --repository-name test

echo "Outer script finished"