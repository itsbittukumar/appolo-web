pipeline {
    agent any

    environment {
        AWS_REGION   = "ap-south-1"
        ACCOUNT_ID   = "659420055085"
        IMAGE_NAME   = "appolo-image"
        IMAGE_TAG    = "${BUILD_NUMBER}"
        ECR          = "${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
        CLUSTER_NAME = "appolo-cluster"
        NAMESPACE    = "appolo"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/itsbittukumar/appolo-web.git'
            }
        }

        stage('Docker Build') {
            steps {
                sh """
                docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                """
            }
        }

        stage('Login to ECR') {
            steps {
                sh """
                aws ecr get-login-password --region ${AWS_REGION} \
                | docker login --username AWS --password-stdin ${ECR}
                """
            }
        }

        stage('Tag & Push to ECR') {
            steps {
                sh """
                docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${ECR}/${IMAGE_NAME}:${IMAGE_TAG}
                docker push ${ECR}/${IMAGE_NAME}:${IMAGE_TAG}
                """
            }
        }

        stage('Deploy to EKS') {
            steps {
                sh """
                echo "🔹 Configure kubeconfig"
                aws eks update-kubeconfig \
                --region ${AWS_REGION} \
                --name ${CLUSTER_NAME}

                echo "🔹 Ensure namespace exists"
                kubectl create namespace ${NAMESPACE} --dry-run=client -o yaml | kubectl apply -f -

                echo "🔹 First-time deployment (if not exists)"
                kubectl apply -f k8s/deployment.yaml || true
                kubectl apply -f k8s/service.yaml || true

                echo "🔹 Update image in deployment"
                kubectl set image deployment/appolo-deployment \
                appolo=${ECR}/${IMAGE_NAME}:${IMAGE_TAG} \
                -n ${NAMESPACE}

                echo "🔹 Force rollout restart"
                kubectl rollout restart deployment/appolo-deployment -n ${NAMESPACE}

                echo "🔹 Wait for rollout to complete"
                kubectl rollout status deployment/appolo-deployment -n ${NAMESPACE}

                echo "🔹 Get service URL"
                kubectl get svc -n ${NAMESPACE}
                """
            }
        }
    }

    post {
        success {
            echo "✅ Deployment Successful 🚀"
        }
        failure {
            echo "❌ Pipeline Failed"
        }
    }
}
