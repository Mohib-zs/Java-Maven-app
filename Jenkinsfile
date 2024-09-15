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
                    echo "Provisioning Server"
                    gv.provisionServer()
                }
            }
        }
        stage("deploy") {
            environment {
                DOCKER_CRED = credentials('docker-credentials')
            }
            steps {
                script {
                    gv.deployApp()
                }
            }
        }
    }
}
