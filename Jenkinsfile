pipeline {
    agent any
    enviroment{
        staging_server="35.156.141.158"
    }

    satges{
        stage('Deploy To Remote'){
            steps {
                sh 'scp ${WORKSPACE}/* root@${staging_server}:/home/ps.igone.in/'
            }
        }
    }
}