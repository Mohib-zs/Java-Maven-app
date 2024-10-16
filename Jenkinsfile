pipeline {
    agent any
    stages {
        stage("init") {
            steps {
                script {
                    echo "copying all neccessary file to ansible control node"
                    sshagent(['docker-ansible-ssh-key']) {
                        sh "scp -o StrictHostKeyChecking=no ansible/* azureuser@docker-vm.eastus.cloudapp.azure.com:~/ansible"
                        sh "ssh -o StrictHostKeyChecking=no azuresuser@docker-vm.eastus.cloudapp.azure.com source ~/venv/bin/activate"

                        withCredentials([sshUserPrivateKey(credentialsId: 'ssh-server-key', keyFileVariable: 'keyfile', usernameVariable: 'user')])
                    }
                }
            }
        }
    }
}
