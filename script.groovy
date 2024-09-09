def buildJar() {
    echo "building the application..."
    sh 'mvn package'
} 

def buildImage() {
    echo "building the docker image..."
    withCredentials([usernamePassword(credentialsId: 'docker-credentials', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
        sh 'docker build -t mohibshaikh/mohib-repo:jma-2.0 .'
        sh "echo $PASS | docker login -u $USER --password-stdin"
        sh 'docker push mohibshaikh/mohib-repo:jma-2.0'
    }
} 

def deployApp() {
    echo 'deploying the application...'
    def dockerCmd = 'docker run -d -p 3080:3080 mohibshaikh/mohib-repo:react-1.0'
    sshagent(['docker-vm-credentials']){
        sh "ssh -o StrictHostKeyChecking=no azureuser@mohibzahid.eastus.cloudapp.azure.com ${dockerCmd}"
    }
} 

return this
