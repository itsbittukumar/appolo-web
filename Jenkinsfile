pipeline {
    agent any

    environment {
        AWS_REGION = "ap-south-1"
        ACCOUNT_ID = "659420055085"
        IMAGE_NAME = "appolo-image"
        IMAGE_TAG = "${BUILD_NUMBER}"
        ECR = "${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
        CLUSTER_NAME = "appolo-cluster"
        NAMESPACE = "appolo"
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
                echo "🔹 Update kubeconfig"
                aws eks update-kubeconfig \
                --region ${AWS_REGION} \
                --name ${CLUSTER_NAME}

                echo "🔹 Create namespace if not exists"
                kubectl create namespace ${NAMESPACE} --dry-run=client -o yaml | kubectl apply -f -

                echo "🔹 Replace image in deployment.yaml"
                sed -i "s|IMAGE_PLACEHOLDER|${ECR}/${IMAGE_NAME}:${IMAGE_TAG}|g" k8s/deployment.yaml

                echo "🔹 Apply Kubernetes manifests"
                kubectl apply -f k8s/

                echo "🔹 Check rollout status"
                kubectl rollout status deployment/appolo-deployment -n ${NAMESPACE}

                echo "🔹 Get service details"
                kubectl get svc -n ${NAMESPACE}
                """
            }
        }
    }

    post {
        success {
            echo "✅ Pipeline completed successfully 🚀"
        }
        failure {
            echo "❌ Pipeline failed"
        }
    }
}
