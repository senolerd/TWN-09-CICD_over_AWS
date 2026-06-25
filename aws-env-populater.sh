# aws ecr describe-repositories --repository-name testa > /dev/null 2>&1
echo "Outer script started"
#aws ecr describe-repositories --repository-name test

echo $1
echo $2
echo $3

# podman run --rm \
# -e AWS_ACCESS_KEY_ID=$AWS_KID \
# -e AWS_SECRET_ACCESS_KEY=$AWS_KEY \
# -e AWS_DEFAULT_REGION=$AWS_REGION \
# docker.io/amazon/aws-cli $CMD




echo "Outer script finished"