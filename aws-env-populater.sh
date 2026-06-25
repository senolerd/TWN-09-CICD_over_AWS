# aws ecr describe-repositories --repository-name testa > /dev/null 2>&1
echo "Outer script started"
aws ecr describe-repositories --repository-name test
echo "Outer script finished"