#!usr/bin/env groovy

@Library('jenkins-shared-library')
def gv

pipeline {
    agent any
    tools {
        maven 'maven 3.9.6'
    }
    enviroment{
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
        stage("build version") {
            steps {
                script {
//                     gv.buildVersion()
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
                    def dockerCmd = "docker run -d -p 8080:8080 ${IMAGE_NAME}"
                    sshagent(['docker-vm-credentials']){
                        sh "ssh -o StrictHostKeyChecking=no azureuser@172.174.84.123 ${dockerCmd}"
                }
            }
        }
        stage("commit version") {
            steps {
                script {
//                     gv.commitVersion()
                }
            }
        }
    }   
  }
}
