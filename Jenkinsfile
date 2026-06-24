@Library('jenkins-shared-lib') _

pipeline {
    agent any
    environment {
        SRC_REGISTER = 'docker.io'
        DEST_REGISTER = 'docker.io'
        DEST_REPO = "$DEST_REGISTER/senolerd"
        MAVEN_IMG = "$SRC_REGISTER/maven:3-eclipse-temurin-17"
        BUILD_IMG = "$SRC_REGISTER/eclipse-temurin:17-jre-jammy"
        DOCKER_CREDENTIAL_ID = 'senolerd_docker'
        //APP_VER = "" // will be assigned dynamic in __init__()

        // It is gping to be used for the application related AWS resource naming and tagging as prefix
        AWS_REGION="us-east-1"
        AWS_APP_PREFIX = 'MavenApp-Dev-'
    }

    stages {
        stage('__init__') {
            steps {
                echo 'Initialing...'
                __init__()
            }
        }

        // stage('Maven Compile') {
        //     steps {
        //         echo 'Compiling...'
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
        stage('AWS deployment populate') {
            steps {


                withCredentials([usernamePassword(credentialsId: 'aws_devops-user-1_access_k_id_and_key', passwordVariable: 'AWS_KEY', usernameVariable: 'AWS_KID')]) {

                    sh '''
                        alias aws='podman run -i --rm  -e AWS_ACCESS_KEY_ID=$AWS_KID \
                        -e AWS_SECRET_ACCESS_KEY=$AWS_KEY \
                        -e AWS_DEFAULT_REGION='us-east-1' \
                        docker.io/amazon/aws-cli'

                        aws s3 ls


                    '''
                }

            }
        }
    }
}
