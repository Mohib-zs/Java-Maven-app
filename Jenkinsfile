def gv

pipeline {
    agent any
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
                    //gv.buildJar()
                }
            }
        }
        stage("build image") {
            steps {
                script {
                    echo "building image"
                    //gv.buildImage()
                }
            }
        }
        stage("deploy") {
            steps {
                script {
                    env.ENV = input message: "Select enviroment to deploy to", ok: "Done", parameters: [choice(name: "ONE", choices: ['dev', 'staging', 'prod'], description: '')]
                    echo "deploying to ${ENV}"
                    //gv.deployApp()
                }
            }
        }
    }   
}
