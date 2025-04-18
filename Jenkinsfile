pipeline {
    agent any

    environment {
        ftp_user = "admin_admin_ps"
        ftp_pass = "igps"
        ftp_host = "35.156.141.158"
        ftp_dir  = "/public_html"
        docker_image = "jenkins-php-app"
        container_name = "php-ftp-uploader"
    }

    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t $docker_image .'
                }
            }
        }

        stage('Run Docker Container and Upload via FTP') {
            steps {
                script {
                    sh """
                        docker run --rm --name $container_name $docker_image \
                        sh -c "curl -T index.php ftp://$ftp_host$ftp_dir/ --user $ftp_user:$ftp_pass --ftp-create-dirs"
                    """
                }
            }
        }
    }
}
