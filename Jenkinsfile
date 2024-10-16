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
                            sh "ssh azureuser@docker-vm.eastus.cloudapp.azure.com 'rm -f ~/.ssh/my-app-key-pair.pem'"
                            sh 'scp $keyfile azureuser@docker-vm.eastus.cloudapp.azure.com:~/.ssh/my-app-key-pair.pem'
                        }
                    }
                }
            }
        }
        stage("execute the playbook"){
            steps {
                script {
                    echo "Executing the ansible playbook"
                    def remote = [:]
                    remote.name = "ansible-server"
                    remote.host = "docker-vm.eastus.cloudapp.azure.com"
                    remote.allowAnyHosts = true
                    withCredentials([sshUserPrivateKey(credentialsId: 'docker-ansible-ssh-key', keyFileVariable: 'keyfile', usernameVariable: 'user')]) {
                        remote.user = user
                        remote.identityFile = keyfile
                        sshCommand remote: remote, command: "source ~/venv/bin/activate"
                        sshCommand remote: remote, command: "ansible-playbook ~/ansible/my-playbook.yaml"
                    }
                }
            }
        }
    }
}
