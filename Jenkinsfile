pipeline {
    agent any
    
    environment {
        // We use 'nexus' because Jenkins is in the same Docker Network
        NEXUS_URL = 'localhost:5000' 
        
        // Name of your app image
        IMAGE_NAME = 'my-fintech-app'
        
        // Uses the Jenkins Build Number (1, 2, 3...) as the version tag
        TAG = "${env.BUILD_NUMBER}"
    }

    stages {
        stage('Build JAR') {
            steps {
                script {
                    echo '--- Building JAR File ---'
                    // We skip tests for now to speed up the lab
                    // On Windows, we use 'mvnw.cmd', on Linux/Mac './mvnw'
                    if (isUnix()) {
                        sh 'chmod +x mvnw'
                        sh './mvnw clean package -DskipTests'
                    } else {
                        bat 'mvnw.cmd clean package -DskipTests'
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo '--- Building Docker Image ---'
                    // This command runs on YOUR HOST because of the socket mapping
                    sh "docker build -t ${NEXUS_URL}/${IMAGE_NAME}:${TAG} ."
                }
            }
        }

        stage('Push to Nexus') {
            steps {
                script {
                    echo '--- Pushing to Nexus ---'
                    // 'nexus-login' matches the ID you created in Jenkins Credentials
                    withCredentials([usernamePassword(credentialsId: 'nexus-login', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                        // Login to the registry
                        sh "docker login -u $USER -p $PASS ${NEXUS_URL}"
                    }
                    // Push the image
                    sh "docker push ${NEXUS_URL}/${IMAGE_NAME}:${TAG}"
                }
            }
        }

        stage('Deploy to Production') {
            steps {
                script {
                    echo '--- Deploying to Localhost:8090 ---'
                    
                    // 1. Remove old container if it exists (ignore errors with || true)
                    sh "docker rm -f prod-app || true"
                    
                    // 2. Run the new container
                    // We map port 8090 on your laptop to 8080 inside the container
                    sh """
                        docker run -d \
                        --name prod-app \
                        --network devops-project_devops-net \
                        -p 8090:8080 \
                        -e SPRING_DATASOURCE_URL=jdbc:postgresql://postgres-db:5432/mydb \
                        -e SPRING_DATASOURCE_USERNAME=myuser \
                        -e SPRING_DATASOURCE_PASSWORD=mypassword \
                        ${NEXUS_URL}/${IMAGE_NAME}:${TAG}
                    """
                }
            }
        }
    }
}