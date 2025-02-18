
pipeline {
agent any
	tools {
         dockerTool 'docker'
         jdk 'jdk'
         maven 'maven'
   }

   environment { 
        registry = "jona163922/democicd" 
        registryCredential = 'dockertoken' 
   }

  stages {
    stage('Checkout') {
      steps {
        git branch: 'main', url: 'https://github.com/mdjonayedakhand/jenkins-maven.git'
      }
    }
  
   stage('Stage I: Build') {
      steps {
        echo "Building Jar Component ..."
            sh 'mvn clean package'
      }
    }

   stage('Stage II: Code Coverage ') {
      steps {
	    echo "Running Code Coverage ..."
        sh "mvn jacoco:report"
      }
    }

//   stage('Stage III: SCA') {
     // steps { 
       // echo "Running Software Composition Analysis using OWASP Dependency-Check ..."
       // sh "mvn org.owasp:dependency-check-maven:check"
      //}
  //  }

   //stage('Stage IV: SAST') {
    //  steps { 
      //  echo "Running Static application security testing using SonarQube Scanner ..."
       // withSonarQubeEnv('sonarqube') {
       //     sh 'mvn sonar:sonar -Dsonar.coverage.jacoco.xmlReportPaths=target/site/jacoco/jacoco.xml -Dsonar.dependencyCheck.jsonReportPath=target/dependency-check-report.json -Dsonar.dependencyCheck.htmlReportPath=target/dependency-check-report.html -Dsonar.projectName=jonayed'
       //}
     // }
    //}

   //stage('Stage V: QualityGates') {
     // steps { 
       // echo "Running Quality Gates to verify the code quality"
       // script {
         // timeout(time: 1, unit: 'MINUTES') {
          //  def qg = waitForQualityGate()
            //if (qg.status != 'OK') {
            //  error "Pipeline aborted due to quality gate failure: ${qg.status}"
           // }
           //}
       // }
      //}
   // }
   
   //stage('Stage VI: Build Image') {
    //  steps { 
      //  echo "Build Docker Image"
        //script {
          //     docker.withRegistry( '', registryCredential ) { 
            //     myImage = docker.build registry
              //   myImage.push()
                //}
        //}
      //}
    //}
	   stage('Build Image') {
            steps {
                echo "Build Docker Image"
                script {
                    def imageName = "${registry}:${BUILD_NUMBER}" // Image name with tag
                    docker.withRegistry('https://index.docker.io/v1/', registryCredential) {
                        myImage = docker.build imageName
                        myImage.push(BUILD_NUMBER)
                    }
                }
            }
        }
        
   stage('Stage VII: Scan Image ') {
      steps { 
        echo "Scanning Image for Vulnerabilities"
        sh "trivy image --scanners vuln --offline-scan jona163922/democicd:latest > trivyresults.txt"
        }
    }
          
   stage('Stage VIII: Smoke Test ') {
      steps { 
        echo "Smoke Test the Image"
        sh "docker run -d --name smokerun -p 8080:8080 jona163922/democicd"
        sh "sleep 90; ./check.sh"
        sh "docker rm --force smokerun"
        }
    }

  }
}
