pipeline {
	agent any
	triggers {
 		pollSCM('* * * * *')		 		
 	}
        stages {
		stage("Compile") {
			steps {
                		sh "./gradlew compileJava"
			} 
		}
		stage("Unit test") {
        		steps {
                		sh "./gradlew test"
			}
		}
		stage("Code coverage") {
			steps {
				sh "./gradlew jacocoTestReport"
				publishHTML (target: [
				    reportDir: 'build/reports/jacoco/test/html',
				    reportFiles: 'index.html',
				    reportName: 'JaCoCo Report'
				])
				sh "./gradlew jacocoTestCoverageVerification"
			}
		}
		stage("Static code analysis") {
			steps {
				sh "./gradlew checkstyleMain"
				publishHTML (target: [
				    reportDir: 'build/reports/checkstyle',
				    reportFiles: 'main.html',
				    reportName: 'Checkstyle Report'
				])
			}
                }
		stage("Package") {
		    steps {
		        sh "./gradlew build"
		    }
		}
		stage("Docker build") {
		        steps {
		            sh "docker build -t 172.17.0.1:5000/calculator ."
		        }
		}
                stage('Docker push') {
                        steps {
                            sh "docker push 172.17.0.1:5000/calculator"
                        }
                }
        	stage("Deploy to staging") {
            		steps {
                		sh "docker-compose up -d"
            		}                
        	}
		stage("Acceptance test") {
       			steps {
			   sh "docker-compose -f docker-compose.yml -f acceptance/docker-compose-acceptance.yml build test"
			   sh "docker-compose -f docker-compose.yml -f acceptance/docker-compose-acceptance.yml -p acceptance up -d"
			   sh 'test $(docker wait acceptance_test_1) -eq 0'
			   sh "./acceptance_test.sh"
			}
                }
        }
	post {
		always {
	     		sh "docker-compose down"
		}
	}
}
