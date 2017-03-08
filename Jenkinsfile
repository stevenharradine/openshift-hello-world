 node {
  try {
    stage('Checkout') {
      sh 'oc project ${PROJECT_NAME}'
      checkout scm
    }

    stage('Apply Templates') {
      sh 'oc apply -f openshift-template.yml'
    }

    stage('Build Container') {
      openshiftBuild buildConfig: 'hello-world', showBuildLogs: 'true', waitTime: '1800000'
      openshiftTag sourceStream: 'hello-world', sourceTag: 'latest', destinationStream: 'hello-world', destinationTag: '${BUILD_NUMBER}', namespace: '${PROJECT_NAME}'
    }

    stage('Deploy') {
      sh 'oc new-app \
          --template="hello-world" \
          -p VERSION=${BUILD_NUMBER} \
          -p DEPLOYMENT_NAME="dev" \
          --docker-image="172.30.82.193:5000/${PROJECT_NAME}/hello-world:${BUILD_NUMBER}" \
          --dry-run -o yaml | oc apply -f -'
      openshiftVerifyDeployment deploymentConfig: 'dev', waitTime: '600000'
    }
  }
  catch (err) {
    currentBuild.result = 'FAILURE'
    throw err
  }
} 