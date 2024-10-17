pipeline {
    agent any
    environment{
        ANSIBLE_SERVER = "docker-vm.eastus.cloudapp.azure.com"
    }
    stages {
        stage("init") {
            steps {
                script {
                    echo "copying all neccessary file to ansible control node"
                    sshagent(['docker-ansible-ssh-key']) {
                        sh "scp -o StrictHostKeyChecking=no ansible/* azureuser@${ANSIBLE_SERVER}:~/ansible"
                        sh "scp -o StrictHostKeyChecking=no prepare-ansible-server.sh azureuser@${ANSIBLE_SERVER}:~/prepare-ansible-server.sh"


                        withCredentials([sshUserPrivateKey(credentialsId: 'server-ssh-key', keyFileVariable: 'keyfile', usernameVariable: 'user')]){
                            sh "ssh azureuser@docker-vm.eastus.cloudapp.azure.com 'rm -f ~/.ssh/my-app-key-pair.pem'"
                            sh 'scp $keyfile azureuser@$ANSIBLE_SERVER:~/.ssh/my-app-key-pair.pem'
                        }
                    }
                }
            }
        }
        stage("execute the playbook"){
            environment {
                MY_CRED = credentials('azure-sp-id')
            }
            steps {
                script {
                    echo "Executing the ansible playbook"
                    def remote = [:]
                    remote.name = "ansible-server"
                    remote.host = ANSIBLE_SERVER
                    remote.allowAnyHosts = true
                    withCredentials([sshUserPrivateKey(credentialsId: 'docker-ansible-ssh-key', keyFileVariable: 'keyfile', usernameVariable: 'user')]) {
                        remote.user = user
                        remote.identityFile = keyfile
                        sshScript remote: remote, script: "prepare-ansible-server.sh"
                        sshCommand remote: remote, command: 'source venv/bin/activate && az login --service-principal -u $MY_CRED_CLIENT_ID -p $MY_CRED_CLIENT_SECRET -t $MY_CRED_TENANT_ID'
                        sshCommand remote: remote, command: "source venv/bin/activate && cd ansible && ansible-playbook my-playbook.yaml"
                    }
                }
            }
        }
    }
}
