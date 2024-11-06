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
    
}

def deployApp() {
    echo 'deploying the application...'
    def dockerCmd = 'docker run -d -p 3080:3080 mohibshaikh/mohib-repo:react-1.0'
    sshagent(['docker-vm-credentials']){
        sh "ssh -o StrictHostKeyChecking=no azureuser@docker-vm.eastus.cloudapp.azure.com ${dockerCmd}"
    }
}

def commitVersion() {
    echo 'commiting version bump...'
    withCredentials([usernamePassword(credentialsId: 'gitlab-credentials', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
        sh "git remote set-url origin https://${USER}:${PASS}@gitlab.com/Mohib-zs/Java-Maven-app.git"
        sh 'git add .'
        sh 'git commit -m "ci: version bump"'
        sh 'git push origin HEAD:jenkins-job'
    }

} 

return this
