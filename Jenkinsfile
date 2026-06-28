@Library('jenkins-shared-lib') _

// aws_devops-user-1_access_k_id_and_key


pipeline {
    agent any
    environment {
        APP_NAME = 'mavenJava'
        // APP_VER = "" // will be assigned dynamic in __init__() based on pom file.
        //// If destionation REGISTRY and REPO is ECR, variables will be 
        //// set in Shared Library (awsEcrRepoCheck). For Docker hub, 
        //// follow up three variables should be set manual
        // DEST_CONTAINER_REGISTRY = 'docker.io'
        // DEST_CONTAINER_REPO = "$DEST_CONTAINER_REGISTRY/$APP_NAME"
        // DOCKER_CREDENTIAL_ID =
        SRC_CONTAINER_REGISTRY = 'docker.io'
        MAVEN_IMG = "$SRC_CONTAINER_REGISTRY/maven:3-eclipse-temurin-17"
        BUILD_IMG = "$SRC_CONTAINER_REGISTRY/eclipse-temurin:17-jre-jammy"
        AWS_REGION="us-east-1"
        AWS_CLI_CRED_ID = "aws_devops-user-1_access_k_id_and_key"
    }

    stages {
        stage('__init__') {
            steps {
                echo "init started"
                __init__()

            }
        }

        stage('AWS ECR repo check') {
            steps {
                echo "AWS ECR repo check for ${APP_NAME.toLowerCase()}"
                awsEcrRepoCheck(APP_NAME.toLowerCase()) // Only for ECR
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
                imageBuild()
            }
        }

        // stage('Image Push') {
        //     // If code is SNAPSHOT, don't try to push any image
        //     when { expression { !APP_VER.endsWith('-SNAPSHOT') } }

        //     steps {
        //         echo 'Pushing image...'
        //         awsImagePush()
        //     }
        // }
    }
}
