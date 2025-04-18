pipeline {
    agent any

    environment {
        ftp_user = "admin_admin_ps"
        ftp_pass = "igps"
        ftp_host = "35.156.141.158"
        ftp_dir  = "/home/ps.igone.in"
    }

    stages {
        stage('Upload via FTP') {
            steps {
                sh '''
                    echo "Current WORKSPACE: $WORKSPACE"
                    echo "Uploading index.php via FTP..."
                    curl -T index.php ftp://$ftp_host$ftp_dir/ --user $ftp_user:$ftp_pass --ftp-create-dirs
                '''
            }
        }
    }
}
