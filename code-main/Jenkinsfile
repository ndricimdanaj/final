pipeline {

    agent any

    environment {
        registry = "docker.io/ndricimdanaj/javacicd"
        registryCredential = 'docker'
        dockerImage = ''
    }

    stages {
        stage("build java application") {
            agent {
                docker {
                    image 'maven:3-alpine'
                    args '-v /root/.m2:/root/.m2'
                }
            }

            steps {

                sh 'mvn -B -DskipTests clean package'
                stash includes: 'target/*.jar', name: 'targetfiles'
            }
        }

/*         stage('Test') {
            agent {
                docker {
                    image 'maven:3-alpine'
                    args '-v /root/.m2:/root/.m2'
                }
            }

            steps {
                sh 'mvn test'
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        } */

        stage('Building image') {
            steps {
                script {
                    unstash 'targetfiles'
                    sh 'ls -l -R'
                    dockerImage = docker.build registry + ":$BUILD_NUMBER"
                }
            }
        }

        stage('Publish') {
            steps {
                script {
                    docker.withRegistry('', registryCredential) {
                        dockerImage.push()
                        dockerImage.push('latest')
                    }
                }
            }
        }

        stage('Remove Unused docker image') {
            steps {
                script {
                    sh "docker rmi -f $registry:$BUILD_NUMBER"
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    withCredentials([kubeconfigFile(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
                        sh "echo $KUBECONFIG > kubeconfig"
                        sh  'export KUBECONFIG="$PWD"/kubeconfig'
                        sh "kubectl get nodes"
                        sh "python -m pip install --upgrade --user openshift"
                        sh "ansible-playbook  kubernetes-deploy.yaml"
                    }
                }
            }
        }

    }
}