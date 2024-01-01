#!usr/bin/env groovy

library identifier: 'jenkins-shared-library@main', retriever: modernSCM(
        [$class: 'GitSCMSource',
        remote: 'git@github.com:Mohib-zs/jenkins-shared-library.git',
        credentialsID: 'Mohib'
        ]
)
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
                    buildImage 'mohibshaikh/mohib-repo:jma-3.0'
                    dockerLogin()
                    dockerPush 'mohibshaikh/mohib-repo:jma-3.0'
                }
            }
        }
        stage("deploy") {
            steps {
                script {
                    gv.deployApp()
                }
            }
        }
    }   
}
