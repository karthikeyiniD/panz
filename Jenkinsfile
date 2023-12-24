pipeline {
  agent any
  // triggers {
  //   pollSCM '* * * * *'
  // }
  environment {
    BRANCH_NAME = "master"
    REPO_NAME = "panz"
    SONAR_PROJECT_KEY = "demo"
    IMAGE_TAG = "demo-project-${BUILD_NUMBER}"
    DOCKER_REPO_URL = "771070158678.dkr.ecr.us-east-2.amazonaws.com"
    DOCKER_REPO_NAME = "demo"
  }
  stages {
    stage('Git checkout') {
      steps {
      checkout([
            $class: 'GitSCM',
            branches: [[name: "*/${BRANCH_NAME}"]],
            userRemoteConfigs: [[credentialsId: 'git-creds', url: "https://github.com/karthikeyiniD/${REPO_NAME}"]]
        ])       
     }   
   }
 //   stage('sonar scanner') {
 //      steps {
 //        sh '''
 //        export PATH="$PATH:/var/lib/jenkins/.dotnet/tools"
 //      	dotnet sonarscanner begin /k:"$SONAR_PROJECT_KEY" /d:sonar.host.url="http://3.19.227.181:9000"  /d:sonar.login="$SONAR_TOKEN"
 //        dotnet build
 //        dotnet sonarscanner end /d:sonar.login="$SONAR_TOKEN"
  
	//   '''
 //     }   
 //   }
 //   stage('Sonar Quality Gate Check') {
 //      steps {
 //        sh '''
	// sleep 20
 //        chmod +x sonar_scan.sh
 //        bash sonar_scan.sh
          
	//   '''
 //     }   
 //   }
   stage('Docker build and push') {
      steps {
        sh '''
         whoami
        
         DOCKER_LOGIN_PASSWORD=$(aws ecr get-login-password  --region us-east-2)
         docker login -u AWS -p $DOCKER_LOGIN_PASSWORD https://$DOCKER_REPO_URL
         docker build -t $DOCKER_REPO_URL/$DOCKER_REPO_NAME:$IMAGE_TAG .
         docker push $DOCKER_REPO_URL/$DOCKER_REPO_NAME:$IMAGE_TAG
	    '''
     }   
   }

   stage('syft scan') {
      steps {
        sh '''
	syft packages docker:771070158678.dkr.ecr.us-east-2.amazonaws.com/demo:demo-project-45 -o cyclonedx > syft_scanresults
	BOM_CONTENT_BASE64=$(base64 -w0 syft_scanresults)
	echo '{"project": "'"70009411-9135-4bd4-8618-40d8cf252157"'", "bom": "'"$BOM_CONTENT_BASE64"'"}' > json_payload.json
	  '''
     }   
   }

     stage('dependencyTrackPublisher') {
            steps {
	        withCredentials([string(credentialsId: 'api_key', variable: 'api_key')]) {
                    dependencyTrackPublisher artifact: 'json_payload.json', projectId: '70009411-9135-4bd4-8618-40d8cf252157', projectName: 'demo-project', projectVersion: 'anand', synchronous: true, dependencyTrackApiKey: api_key ; 
		}
		    
            }
        }
	  
     stage('dependency check') {
      steps {
        sh '''
    	sleep 20
        chmod +x dependency_check.sh 
        bash dependency_check.sh 
	  '''
     }   
   }

    stage('Image Scan') {
      steps {
        sh '''
    	sleep 20
        chmod +x image_scan.sh
        bash image_scan.sh     
	  '''
     }   
   }
//      stage('argocd deploy') {
//       steps {
//         sh '''
//         aws eks update-kubeconfig --name demo --region us-east-2
//   	    sed "s/changebuildnumber/${BUILD_NUMBER}/g" kubernetes/deploy.yml
//             git clone https://github.com/mahigandham142/panz.git
// 	    git add kubernetes/deploy.yml
//             git commit "eks deployment"
// 	    git push -u origin master
  
//   	  '''
//      }   
//    }
	  
//    stage('eks deploy') {
//      steps {
//        sh '''
            
//             aws eks update-kubeconfig --name demo --region us-east-2
//   	    sed "s/changebuildnumber/${BUILD_NUMBER}/g" deploy.yml 
//   	    kubectl apply -f deploy.yml
//   	    kubectl apply -f svc.yml
  
//   	  '''
//     }   
//   }
 }
 }
//       stage('ecs deploy') {
//       steps {
//           sh '''
//           chmod +x changebuildnumber.sh
//             ./changebuildnumber.sh $BUILD_NUMBER
//	     sh -x ecs-auto.sh
//             '''
//        }    
//       }
// }
// post {
//     failure {
//         mail to: 'unsolveddevops@gmail.com',
//              subject: "Failed Pipeline: ${BUILD_NUMBER}",
//              body: "Something is wrong with ${env.BUILD_URL}"
//     }
//      success {
//         mail to: 'unsolveddevops@gmail.com',
//              subject: "successful Pipeline:  ${env.BUILD_NUMBER}",
//              body: "Your pipeline is success ${env.BUILD_URL}"
//     }
// }
