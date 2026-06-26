@Library('jenkins-shared-lib') _

pipeline {
    agent any
    environment {
        SRC_CONTAINER_REGISTRY = 'docker.io'
        // DEST_CONTAINER_REGISTRY = 'docker.io'
        // DEST_CONTAINER_REPO = "$DEST_CONTAINER_REGISTRY/senolerd"
        MAVEN_IMG = "$SRC_CONTAINER_REGISTRY/maven:3-eclipse-temurin-17"
        BUILD_IMG = "$SRC_CONTAINER_REGISTRY/eclipse-temurin:17-jre-jammy"
        // DOCKER_CREDENTIAL_ID = 'senolerd_docker'
        //APP_VER = "" // will be assigned dynamic in __init__()

        AWS_REGION="us-east-1"
        AWS_PROJECT_NAME = 'mavenJava'
        // ECR registry and repo will be set to REMOTE_REGISTRY/REMOTE_REPO in JSL 
    }

    stages {
        stage('__init__') {
            steps {
                __init__()
            }
        }

        stage('AWS ECR repo check') {
            steps {
                // Checking ECR repo, if there isn't for the project it will be created.
                // The ECR repo address will be accessable via emv.ECR_REPO at further stage and steps.
                echo "AWS ECR repo check for ${AWS_PROJECT_NAME.toLowerCase()}"
                awsEcrRepoCheck(AWS_PROJECT_NAME.toLowerCase())
            }
        }

        stage('Maven Packing') {
            steps {
                mavenCleanPackage()
            }

            post { failure { emailext(
                        subject: "⚠️ FAILED: Job '${env.JOB_NAME}' [Build #${env.BUILD_NUMBER}]",
                        body: """Stage 'Maven Compile' failed.
                                Check the logs here: ${env.BUILD_URL}console""",
                        to: 'devops-team@company.com, dev-team@company.com')}
            }
        }

        stage('OCI Image Build') {
            // If code is SNAPSHOT, don't build image
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
        //         imagePush()
        //     }
        // }


    }
}
