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

}
}
