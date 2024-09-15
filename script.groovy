def buildVersion() {
    echo 'Incrementing app version..'
    sh 'mvn build-helper:parse-version versions:set \
        -DnewVersion=\\\${parsedVersion.majorVersion}.\\\${parsedVersion.minorVersion}.\\\${parsedVersion.nextIncrementalVersion} \
        versions:commit'
    def matcher = readFile('pom.xml') =~ '<version>(.+)</version>'
    def version = matcher[0][1]
    env.IMAGE_NAME = "$version-$BUILD_NUMBER"

}

def buildJar() {
    echo "building the application..."
    sh 'mvn clean package'
} 

def buildImage() {
    echo "building the docker image...."
    withCredentials([usernamePassword(credentialsId: 'docker-credentials', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
        sh "docker build -t mohibshaikh/mohib-repo:${IMAGE_NAME} ."
        sh "echo $PASS | docker login -u $USER --password-stdin"
        sh "docker push mohibshaikh/mohib-repo:${IMAGE_NAME}"
    }
} 

def provisionServer() {
    dir('terraform') {
    sh 'az login --service-principal -u $MY_CRED_CLIENT_ID -p $MY_CRED_CLIENT_SECRET -t $MY_CRED_TENANT_ID'
    sh "terraform init"
    sh "terraform apply --auto-approve"
    PUBLIC_IP = sh(
        script: "terraform output public_ip_address",
        returnStdout: true
    ).trim()
    }
}

def deployApp() {
    sleep(time: 30, unit: "SECONDS")
    echo 'deploying image to server'
    echo "${PUBLIC_IP}"
    def shellCmd = "bash ./serverCmds.sh mohibshaikh/mohib-repo:${IMAGE_NAME} ${DOCKER_CRED_USR} ${DOCKER_CRED_PSW}"
    def azureVm = "azureuser@${PUBLIC_IP}"
    sshagent(['server-ssh-key']){
            sh "scp -o StrictHostKeyChecking=no serverCmds.sh ${azureVm}:/home/azureuser"
            sh "scp -o StrictHostKeyChecking=no docker-compose.yaml ${azureVm}:/home/azureuser"
            sh "ssh -o StrictHostKeyChecking=no ${azureVm} ${shellCmd}"
    }
}

def commitVersion() {
    echo 'commiting version bump...'
    withCredentials([usernamePassword(credentialsId: 'gitlab-credentials', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
        sh "git remote set-url origin https://${USER}:${PASS}@gitlab.com/Mohib-zs/Java-Maven-app.git"
        sh 'git add .'
        sh 'git commit -m "ci: version bump"'
        sh 'git push origin HEAD:jenkins/payment'
    }

} 

return this
