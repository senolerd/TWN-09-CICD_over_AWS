@Library('jenkins-shared-lib') _

pipeline {
    agent any
    environment {
        SRC_REGISTER = 'docker.io'
        MAVEN_IMG = "$SRC_REGISTER/maven:3-eclipse-temurin-17"
        BUILD_IMG = "$SRC_REGISTER/eclipse-temurin:17-jre-jammy"
        DOCKER_CREDENTIAL_ID = 'senolerd_docker'
        //APP_VER = "" // will be assigned dynamic in __init__()

        AWS_REGION="us-east-1"
        AWS_PROJECT_NAME = 'mavenJavaApp'
        // ECR_REPO = // will be created in pipeline
    }

    stages {
        stage('__init__') {
            steps {
                __init__()
            }
        }

        stage('AWS resource check') {
            steps {
                echo "AWS ECR repo check for ${AWS_PROJECT_NAME.toLowerCase()}"
                awsEcrRepoCheck(AWS_PROJECT_NAME.toLowerCase())
                echo "IS ECR_REPO SET?: ${ECR_REPO}"
                // echo "AWS VPC check for ${AWS_PROJECT_NAME}"
                // awsVpcCheck(AWS_PROJECT_NAME)

                // script{
                //     withCredentials([usernamePassword(credentialsId: 'aws_devops-user-1_access_k_id_and_key', passwordVariable: 'AWS_KEY', usernameVariable: 'AWS_KID')]) {
                //         sh '''
                //             chmod +x aws-env-populater.sh
                //             ./aws-env-populater.sh $AWS_KID $AWS_KEY $AWS_REGION
                //         '''
                //     }
                // }
            }
        }

        // stage('Maven Packing') {
        //     steps {
        //         mavenCleanPackage()
        //     }

        //     post { failure { emailext(
        //                 subject: "⚠️ FAILED: Job '${env.JOB_NAME}' [Build #${env.BUILD_NUMBER}]",
        //                 body: """Stage 'Maven Compile' failed.
        //                         Check the logs here: ${env.BUILD_URL}console""",
        //                 to: 'devops-team@company.com, dev-team@company.com')}
        //     }
        // }

        // stage('OCI Image Build') {
        //     // If code is SNAPSHOT, don't build image
        //     when { expression { !APP_VER.endsWith('-SNAPSHOT') } }

        //     steps {
        //         echo 'Building...'
        //         imageBuild()
        //     }
        // }

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
