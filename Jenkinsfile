#!usr/bin/env groovy

@Library('jenkins-shared-library')
def gv

pipeline {
    agent any
    tools {
        maven 'maven 3.9.6'
    }
    stages {
        stage("buildVersion") {
            steps {
                script {
                    echo 'Incrementing app version..'
                    gv.buildVersion()
                }
            }
        }
        stage("build jar") {
            steps {
                script {
                    echo "building jar"
                    gv.buildJar()
                }
            }
        }
        stage("build and push image") {
            steps {
                script {
                    echo "building image"
                    gv.buildImage()
                }
            }
        }
        stage("provision server") {
            environment {
                TF_VAR_env_prefix = 'test'
            }
            steps {
                script {
                    dir('terraform') {
                        sh "terraform init"
                        sh "terraform apply --auto-approve"
                        PUBLIC_IP = sh(
                            script: "terraform ouput public_ip_address",
                            returnStdout: true
                        ).trim()
                    }
                }
            }
        }
        stage("deploy") {
            steps {
                script {
                    echo "Waiting for vm to start"
                    sleep(time: 90, unit: "SECONDS")
                    echo 'deploying image to server'
                    def shellCmd = "bash ./serverCmds.sh mohibshaikh/mohib-repo:${IMAGE_NAME}"
                    def azureVm = 'azureuser@${PUBLIC_IP}'
                    sshagent(['server-ssh-key']){
                            sh "scp -o StrictHostKeyChecking=no serverCmds.sh ${azureVm}:/home/azureuser"
                            sh "scp -o StrictHostKeyChecking=no docker-compose.yaml ${azureVm}:/home/azureuser"
                            sh "ssh -o StrictHostKeyChecking=no ${azureVm} ${shellCmd}"
                    }
                }
            }
        }
    }
}
