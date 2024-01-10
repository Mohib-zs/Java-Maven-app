#!usr/bin/env groovy

@Library('jenkins-shared-library')

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
                        sh 'mvn build-helper:parse-version versions:set \
                            -DnewVersion=\\\${parsedVersion.majorVersion}.\\\${parsedVersion.minorVersion}.\\\${parsedVersion.nextIncrementalVersion} \
                            versions:commit'
                        def matcher = readFile('pom.xml') =~ '<version>(.+)</version>'
                        def version = matcher[0][1]
                        env.IMAGE_NAME = "$version-$BUILD_NUMBER"
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
        stage("commit version") {
            steps {
                script {
                  echo 'commiting version bump...'
                     withCredentials([usernamePassword(credentialsId: 'gitlab-credentials', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                         sh "git remote set-url origin https://${USER}:${PASS}@gitlab.com/Mohib-zs/Java-Maven-app.git"
                         sh 'git add .'
                         sh 'git commit -m "ci: version bump"'
                         sh 'git push origin HEAD:jenkins/payment'
                     }
                }
            }
        }
    }
}
