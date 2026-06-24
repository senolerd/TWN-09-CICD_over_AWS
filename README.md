### Demo Project: CICD workflow with Jenkins and AWS services for a sample Java Application

#### Used Technologies :
EC2, Amazon ECR, Jenkins, Groovy, root-less Podman, Git, Java, Maven.
ToDo: Think about deploying container over ECS on Fargate

#### Objectives
Using Jenkin's 
- Jenkins Shared Library usage written in Groovy for clear pipeline
- Version updating after a success testing
- OCI container creation and uploading to ECR private repository
- Deploying application over EC2 server as container via Podman runtime. 

#### Planned Workflow Steps:
- Jenkins checkouts repo
- Packing Maven application (Every commit is being checked. Send a mail if packing has a problem)
- [*] If the code is a SNAPSHOT (version in the pom.xml file with -SNAPSHOT suffix) later steps will be skipped. 
- Checks ECR repo existence, if doesn't exist, creates a repo via aws-cli
- Creates a OCI image with ECR private repository tag
- Creates a Podman Pod yaml and transfer it to application server
- Applying (it created if it is first deployment) new version of application Pod. Sends a mail about updating.
- Code version is bump up to next minor version with -SNAPSHOT suffix and pom file commit to remote

#### Requirements on Jenkins:
- A DevOps-user-1 kind of user should to be created with cli access and at least EC2/ECR adminstrative policies applied at IAM. (Access key id, and access key)




Jenkins will run as a container on Podman runtime over Rocky 10. 

*** This projects java source code is taken from https://gitlab.com/twn-devops-bootcamp/latest/08-jenkins/java-maven-app ***
*** This projects also Continous Delivery expansion for TWN-08-jenkins-ci-java-maven  ***





---------------------------------
Quick note for Podman-in-Podman for Jenkins can use Host's root-less Podman runtime to build or run tool containers (like; maven, aws-cli)

podman run -d --name jenkins-test \
-v jenkins_home:/var/jenkins_home \
-v /run/user/1000/podman/podman.sock:/run/podman/podman.sock:z \
-e "CONTAINER_HOST=unix:///run/podman/podman.sock" \
--userns=keep-id \
--restart=always \
-p 8080:8080 \
docker.io/jenkins/jenkins:2.555.2-lts

- install podman runtime in Jenkins container
