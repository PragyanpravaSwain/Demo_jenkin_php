pipeline {
    agent any
    environment{
        staging_server="35.156.141.158"
    }

    stages{
        stage('Deploy To Remote'){
            steps {
                bat 'scp -r ${WORKSPACE}/* root@${staging_server}:/home/ps.igone.in/'
            }
        }
    }
}