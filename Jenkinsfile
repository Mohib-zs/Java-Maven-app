def gv

pipeline {
    agent any
    tools {
        maven 'maven 3.9.6'
    }

    environment {
        registryName = "AzrRepo"
        registryCredential = 'ACR'
        registryUrl = 'azrrepo.azurecr.io'
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
        stage("build image") {
            steps {
                script {
                    echo "building image"
                    gv.buildImage()
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
        stage("commit version") {
            steps {
                script {
                    gv.commitVersion()
                }
            }
        }
    }   
}
