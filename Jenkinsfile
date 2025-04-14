pipeline {
    agent any 
        statges {
            stage ('build'){
                steps {
                   sh "building"
                }
            }
            stage('Test') {
            steps {
                echo 'Testing..'
                  }
            }
              stage('Deploy') {
            steps {
                echo 'Deploying...'
                  }
            }

        }
}
    
