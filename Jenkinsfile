def gv

pipeline {
    agent any
    tools {
        maven 'maven 3.9.9'
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
        stage("test") {
            steps {
                script {
                    gv.test()
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
        stage("provision server") {
            steps {
                script {
                    echo "provisioning server"
                    gv.provisionServer
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
