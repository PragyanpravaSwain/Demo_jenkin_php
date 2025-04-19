pipeline {
    agent any

    environment {
        ftp_user = "admin_admin_ps"
        ftp_pass = "igps"
        ftp_host = "35.156.141.158"
        ftp_dir  = "/public_html"
        docker_image = "php-test-app"
        container_port = "8080" // Change as needed
    }

    stages {
        stage('Build Docker Image') {
            steps {
                sh '''
                echo "Creating Dockerfile..."
                echo "FROM php:8.1-apache" > Dockerfile
                echo "COPY . /var/www/html/" >> Dockerfile

                echo "Building Docker image..."
                docker build -t ${docker_image} .
                '''
            }
        }

        stage('Run Docker Container') {
            steps {
                sh '''
                echo "Running Docker container for testing..."
                docker run -d -p ${container_port}:80 --name ${docker_image}_test ${docker_image}
                echo "Test URL: http://localhost:${container_port}"
                '''
            }
        }

        stage('Manual Approval for Production Deploy') {
            when {
                branch 'main'
            }
            steps {
                input message: 'Approve deployment to production?'
            }
        }

        stage('Deploy to CyberPanel via FTP') {
            when {
                branch 'main'
            }
            steps {
                sh '''
                echo "Deploying to CyberPanel..."
                curl -T index.php ftp://${ftp_host}${ftp_dir}/ --user ${ftp_user}:${ftp_pass} --ftp-create-dirs
                '''
            }
        }
    }

    post {
        always {
            echo 'Cleaning up Docker container...'
            sh '''
            docker stop ${docker_image}_test || true
            docker rm ${docker_image}_test || true
            '''
        }
    }
}
