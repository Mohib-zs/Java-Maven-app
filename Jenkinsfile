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
                    def shellCmd = "bash ./serverCmds.sh ${IMAGE_NAME}"
                    def azureVm = 'azureuser@docker-vm.eastus.cloudapp.azure.com'
                    sshagent(['docker-vm-credentials']){ 
                        sh "scp serverCmds.sh ${azureVm}:/home/azureuser"
                        sh "scp docker-compose.yaml ${azureVm}:/home/azureuser"
                        sh "ssh -o StrictHostKeyChecking=no ${azureVm} ${shellCmd}"
                    }
                }
            }
        }
    }
}
