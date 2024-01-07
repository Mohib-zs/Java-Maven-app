#!usr/bin/env groovy

@Library('jenkins-shared-library')
def gv

pipeline {
    agent any
    tools {
        maven 'maven 3.9.6'
    }
    environment {
        IMAGE_NAME = 'mohibshaikh/mohib-repo:jma-3.0'
    }
    stages {
        stage("init") {
            steps {
                script {
                    gv = load "script.groovy"
                }
            }
        }
        stage("build jar") {
            steps {
                script {
                    echo "building jar"
                    buildJar()
                }
            }
        }
        stage("build and push image") {
            steps {
                script {
                    echo "building image"
                    buildImage(env.IMAGE_NAME)
                    dockerLogin()
                    dockerPush(env.IMAGE_NAME)
                }
            }
        }
        stage("deploy") {
            steps {
                script {
                    echo 'deploying image to server'
                    def shellCmd = "bash /home/azureuser/server-cdms.sh ${IMAGE_NAME}"
                    def dosunix = 'dos2unix server-cdms.sh'
                    sshagent(['docker-vm-credentials']){ 
                        sh "scp -v -o StrictHostKeyChecking=no server-cmds.sh azureuser@docker-vm.eastus.cloudapp.azure.com:/home/azureuser"
                        sh "scp -v -o StrictHostKeyChecking=no docker-compose.yaml azureuser@docker-vm.eastus.cloudapp.azure.com:/home/azureuser"
                        sh "ssh -o StrictHostKeyChecking=no azureuser@docker-vm.eastus.cloudapp.azure.com ${dosunix} ${shellCmd}"
                    }
                }
            }
        }
    }
}
