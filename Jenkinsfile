pipeline {
    agent any

    environment {
        ftp_user = "admin_admin_ps"
        ftp_pass = "igps"
        ftp_host = "35.156.141.158"
        ftp_dir  = "/public_html"
    }

    stages {
        stage('Run in Docker') {
            agent {
                docker {
                    image 'ubuntu:latest'
                    args '-u root'
                }
            }
            stages {
                stage('Install Tools') {
                    steps {
                        sh 'apt-get update && apt-get install -y zip unzip lftp'
                    }
                }

                stage('Build PHP App') {
                    steps {
                        echo "Zipping the PHP app"
                        sh 'zip -r build.zip .'
                    }
                }

                stage('Upload to CyberPanel via FTP') {
                    steps {
                        sh '''
                            unzip -o build.zip -d ./build_dir
                            lftp -u $ftp_user,$ftp_pass $ftp_host <<EOF
                            mirror -R ./build_dir $ftp_dir
                            bye
EOF
                        '''
                    }
                }
            }
        }
    }
}
