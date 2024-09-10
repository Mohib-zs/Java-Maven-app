#!usr/bin/env groovy

@Library('jenkins-shared-library')
def gv

pipeline {
    agent any
    tools {
        maven 'maven 3.9.6'
    }
    stages {
        stage("init") {
            steps {
                script {
                    gv = load "script.groovy"
                }
            }
        }
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
                MY_CRED = credentials('azure-sp-id')
                TF_VAR_env_prefix = 'test'
                TF_VAR_subscription_id = "${MY_CRED_SUBSCRIPTION_ID}"
            }
            steps {
                script {
                    dir('terraform') {
                        sh "az login --service-principal -u $MY_CRED_CLIENT_ID -p $MY_CRED_CLIENT_SECRET -t $MY_CRED_TENANT_ID"
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
                    sleep(time: 30, unit: "SECONDS")
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
