pipeline {
    agent any

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
            }
        }

        stage('Version Rails') {
            steps {
                sh 'rails --version'
            }
        }

        stage('Installer les dépendances') {
            steps {
                dir('ruby-app') {
                    sh 'bundle install'
                }
            }
        }
        stage('RuboCop') {
            steps {
                dir('ruby-app') {
                    sh 'bundle exec rubocop || true'
        }
    }
}
    }
}
