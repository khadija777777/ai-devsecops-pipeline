pipeline {
    agent any

environment {
    RBENV_ROOT = '/var/lib/jenkins/.rbenv'
    RBENV_VERSION = '3.4.10'
    PATH = "/var/lib/jenkins/.rbenv/bin:/var/lib/jenkins/.rbenv/shims:$PATH"
}
    stages {

        stage('Informations système') {
            steps {
                sh 'pwd'
                sh 'ls -la'
            }
        }

stage('Version Ruby') {
    steps {
        sh 'ruby --version'
        sh 'which ruby'
    }
}

stage('Installer les dépendances') {
    steps {
        dir('ruby-app') {
            sh 'bundle install'
        }
    }
}

stage('Version Rails') {
    steps {
        dir('ruby-app') {
            sh 'bundle exec rails --version'
        }
    }
}
        stage('RuboCop') {
            steps {
                dir('ruby-app') {
                    sh 'bundle exec rubocop'
                }
            }
        }

        stage('RSpec Tests') {
            steps {
                dir('ruby-app') {
                    sh 'bundle exec rspec'
                }
            }
        }

        stage('Brakeman - SAST') {
            steps {
                dir('ruby-app') {
                    sh 'bundle exec brakeman'
                }
            }
        }
stage('Dependency Scan') {
    steps {
        dir('ruby-app') {
            sh 'bundle exec bundler-audit check --update'
        }
    }
}

stage('Docker Build') {
    steps {
        sh 'docker build -t ai-devsecops-ruby:latest ./ruby-app'
    }
}
stage('Trivy - Image Scan') {
    steps {
        sh '''
            trivy image \
              --db-repository ghcr.io/aquasecurity/trivy-db:2 \
              --scanners vuln \
              --pkg-types os \
              ai-devsecops-ruby:latest
        '''
    }
}
stage('Docker Push') {
    steps {
        withCredentials([
            usernamePassword(
                credentialsId: 'dockerhub-credentials',
                usernameVariable: 'DOCKER_USER',
                passwordVariable: 'DOCKER_TOKEN'
            )
        ]) {
            sh '''
                echo "$DOCKER_TOKEN" | docker login -u "$DOCKER_USER" --password-stdin

                docker tag ai-devsecops-ruby:latest "$DOCKER_USER/ai-devsecops-ruby:latest"

                docker push "$DOCKER_USER/ai-devsecops-ruby:latest"

                docker logout
            '''
        }
    }
}
}
}
