pipeline {
    agent any

    environment {
        ftp_user = "admin_admin_ps"
        ftp_pass = "igps"
        ftp_host = "35.156.141.158"
        ftp_dir  = "/public_html"
    }

    stages {
        stage('Build PHP App') {
            steps {
                echo "Build your PHP app here (e.g., Composer install, zip, etc.)"
                // Example if you're zipping it:
                sh 'zip -r build.zip .'
            }
        }

        stage('Upload to CyberPanel via Docker') {
            agent {
                docker {
                    image 'ubuntu:latest'
                    args '-u root'
                }
            }

            steps {
                sh '''
                    apt-get update && apt-get install -y lftp unzip

                    echo "Unzipping build if needed..."
                    unzip -o build.zip -d ./build_dir

                    echo "Uploading files via FTP to CyberPanel..."
                    lftp -u $ftp_user,$ftp_pass $ftp_host <<EOF
                    mirror -R ./build_dir $ftp_dir
                    bye
EOF
                '''
            }
        }
    }
}
