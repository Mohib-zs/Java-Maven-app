pipeline {
    agent any
    stages {
        stage("init") {
            steps {
                script {
                    echo "copying all neccessary file to ansible control node"
                    sshagent(['docker-ansible-ssh-key']) {
                        sh "scp -o StrictHostKeyChecking=no ansible/* azureuser@docker-vm.eastus.cloudapp.azure.com:~/ansible"

                        withCredentials([sshUserPrivateKey(credentialsId: 'server-ssh-key', keyFileVariable: 'keyfile', usernameVariable: 'user')]){
                            sh "scp ${keyfile} azuresuser@docker-vm.eastus.cloudapp.azure.com:~/.ssh/my-app-key-pair.pem"
                        }
                    }
                }
            }
        }
    }
}
