@Library('jenkins-shared-lib') _

// aws_devops-user-1_access_k_id_and_key


pipeline {
    agent any
    environment {
        APP_NAME = 'mavenJava-Dev'
        MAVEN_IMG = "docker.io/maven:3-eclipse-temurin-17"
        BUILD_IMG = "cgr.dev/chainguard/jre:latest" // Chainguard' hardened JRE image.
        // BUILD_IMG = "$SRC_CONTAINER_REGISTRY/eclipse-temurin:17-jre-jammy"
        GITHUB_CRED_ID = "github_PAT" // String type of credential. Will be used for git push after version increment.

        // An AWS user with ECR permissons of "getting auth token" and "pushing images" to ECR. Also ec2:DescribeInstances 
        // to get EC2 instance Public IP address by its Name tag. This user should not have any other permissions.
        // To make this pipeline works, this AWS users API key ID and secret key should be added to Jenkins credentials
        // as "Username/Password" type of credential. awsImagePush() will use AWS STS to get Account ID, then create ECR 
        // registry URL, then push the image to ECR. Account ID is not hardcoded in this pipeline, so it can be used for any AWS account.
        // Don't forget to update this Jenkins credential's ID at AWS_CLI_CRED_ID env variable.
        AWS_CLI_CRED_ID = "aws_devops-user-1_access_k_id_and_key" // Username/Password type of aws credentials
        AWS_REGION = "us-east-1"
        AWS_EC2_TAG = "PODMAN_SERVER" // Name tag of podman application server should have.
        EC2_SSH_CRED_ID = "ec2_ssh_key" // SSH key credential for Jenkins to connect to EC2 instance where podman is running
    }

    stages {
        stage('__init__') {
            steps {
                script{
                    env.APP_VER = mavenGetAppVersion()
                }


            }
        }

        stage('Maven Packing') {
            // We want to check packing for every commit whether SNAPSHOT or not
            // to be sure codebase ready to be containerized. 
            steps {
                mavenCleanPackage()
            }

            post { failure { emailext(
                        subject: "⚠️ FAILED: Job '${env.JOB_NAME}' [Build #${env.BUILD_NUMBER}]",
                        body: """Stage 'Maven Compile' failed.
                                Check the logs here: ${env.BUILD_URL}console""",
                        to: 'senolerd@gmail.com')} // someone who maintains this repo
            }
        }

        stage('OCI Image Build') {
            // If code is SNAPSHOT, don't build container image.
            when { expression { !APP_VER.endsWith('-SNAPSHOT') } }

            steps {
                echo 'Building...'
                mavenImageBuild()
            }
        }

        stage('Image CVE Check') {
            // If code is SNAPSHOT, don't build container image.
            when { expression { !APP_VER.endsWith('-SNAPSHOT') } }

            steps {
                echo 'ToDo: Add CVE check for new image'
            }
        }

        stage('Image Push') {
            // If code is SNAPSHOT, don't try to push any image
            when { expression { !APP_VER.endsWith('-SNAPSHOT') } }

            steps {
                echo 'Pushing image...'
                awsImagePush()
                mavenIncrementVersion()
                gitPushVersionUpdate()
            }
        }

        stage('Deploy to Podman Server') {
            // If code is SNAPSHOT, don't try to push any image
            when { expression { !APP_VER.endsWith('-SNAPSHOT') } }

            steps {
                echo 'Deploying image to podman server...'
                withCredentials([usernamePassword(credentialsId: env.AWS_CLI_CRED_ID, passwordVariable: 'AWS_KEY', usernameVariable: 'AWS_KID')]) {

                    script{
                        env.EC2_SERVER_IP = sh(script: '''
                            podman run --rm -e AWS_ACCESS_KEY_ID=$AWS_KID -e AWS_SECRET_ACCESS_KEY=$AWS_KEY \
                            -e AWS_DEFAULT_REGION=$AWS_REGION docker.io/amazon/aws-cli c2 describe-instances \
                            --query "Reservations[].Instances[?Tags[?Key=='Name' && Value=='${PODMAN_SERVER}']].PublicIpAddress" --output text
                            ''', returnStdout: true).trim()
                    }
                }

                sshagent(['ec2_ssh_key']) {
                    withCredentials([usernamePassword(credentialsId: env.EC2_SSH_CRED_ID, passwordVariable: 'EC2_SSH_KEY', usernameVariable: 'EC2_SSH_USER')]) {
                        script{
                            sh 'ssh -o StrictHostKeyChecking=no ${EC2_SSH_USER}@${env.EC2_SERVER_IP} whoami'
                        }
                    }
                }
            }
        }
    }
}
