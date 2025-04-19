pipeline {
    agent any
    environment {
        ftp_user = "admin_admin_ps"
        ftp_pass = "igps"
        ftp_host = "35.156.141.158"
        ftp_dir  = "/public_html"

        DOCKER_IMAGE = "php:8.1-apache"
        CONTAINER_NAME = "php-test-container"
        TEST_PORT = "8090"
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build Docker Test Environment') {
            steps {
                sh '''
                # Create a Dockerfile for testing
                cat > Dockerfile.test << EOF
FROM ${DOCKER_IMAGE}
COPY . /var/www/html/
EXPOSE 80
EOF
                
                # Build the test image
                docker build -t php-test-app -f Dockerfile.test .
                
                # Run the container
                docker run -d -p ${TEST_PORT}:80 --name ${CONTAINER_NAME} php-test-app
                
                # Wait for container to be ready
                sleep 5
                '''
            }
        }
        
        stage('Run Tests') {
            steps {
                sh '''
                # Basic test to verify the application is running
                TEST_RESPONSE=$(curl -s http://localhost:${TEST_PORT}/)
                echo "Test response: $TEST_RESPONSE"
                
                if [[ $TEST_RESPONSE != *"Hello from Jenkins + Docker + CyberPanel"* ]]; then
                  echo "Test failed! Application is not responding correctly."
                  exit 1
                fi
                
                echo "Tests passed successfully!"
                '''
            }
        }
        
        stage('Deploy to CyberPanel') {
            when {
                branch 'main'  // Only deploy when code is merged to main branch
            }
            steps {
                script {
                    // Using LFTP for more robust FTP transfer (install if needed)
                    sh '''
                    if ! command -v lftp &> /dev/null; then
                        echo "Installing lftp..."
                        apt-get update && apt-get install -y lftp || \
                        yum install -y lftp || \
                        apk add --no-cache lftp
                    fi
                    
                    echo "Deploying to production server via FTP..."
                    lftp -c "set ftp:ssl-allow no; \
                          open -u ${FTP_USER},${FTP_PASS} ${FTP_HOST}; \
                          mirror -R ./ ${FTP_DIR} --exclude .git/ --exclude Dockerfile.test"
                    
                    echo "Deployment completed successfully!"
                    '''
                }
            }
        }
    }
    
    post {
        always {
            sh '''
            # Clean up Docker container
            docker stop ${CONTAINER_NAME} || true
            docker rm ${CONTAINER_NAME} || true
            '''
        }
        success {
            echo "Pipeline completed successfully!"
        }
        failure {
            echo "Pipeline failed! Check the logs for details."
        }
    }
}
