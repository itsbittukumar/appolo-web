pipeline {
agent any

environment {
AWS_REGION = "ap-south-1"
ACCOUNT_ID = "659420055085"
IMAGE_NAME = "appolo-image"
IMAGE_TAG = "${BUILD_NUMBER}"
ECR = "${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
}

stages {

stage('Checkout') {
  steps {
    git branch: 'main',
        url: 'https://github.com/bk-thakur/ihms-frontend.git'
  }
}

  stage('Docker Build') {
  steps {
    sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
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
      docker tag ${IMAGE_NAME}:${IMAGE_TAG} \
      ${ECR}/${IMAGE_NAME}:${IMAGE_TAG}

      docker push ${ECR}/${IMAGE_NAME}:${IMAGE_TAG}
    """
  }
}


// stage('Deploy to EKS') {
//   steps {
//     sh """
//       aws eks update-kubeconfig \
//       --region ${AWS_REGION} \
//       --name ihms-cluster

//       kubectl set image deployment/ihms-frontend \
//       ihms=${ECR}/${IMAGE_NAME}:${IMAGE_TAG} \
//       -n ihms

//       kubectl rollout status deployment/ihms-frontend -n ihms
//     """
//   }
// }

}

post {
success {
echo "Pipeline completed successfully"
}

failure {
  echo "Pipeline failed due to quality or security issue"
}

}
}
