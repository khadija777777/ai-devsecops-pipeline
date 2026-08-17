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

        stage('OWASP ZAP - DAST') {
            steps {
                sh '''
                    set -e

                    echo "=== Nettoyage ancien conteneur ZAP ==="
                    docker rm -f rails-zap-target 2>/dev/null || true

                    echo "=== Démarrage de l'application Rails ==="
                    SECRET_KEY_BASE=$(openssl rand -hex 64)

                    docker run -d \
                      --name rails-zap-target \
                      -p 3000:80 \
                      -e SECRET_KEY_BASE="$SECRET_KEY_BASE" \
                      ai-devsecops-ruby:latest

                    echo "=== Attente du démarrage de Rails ==="

                    for i in $(seq 1 30); do
                        if curl -s -o /dev/null http://localhost:3000; then
                            echo "Rails est disponible."
                            break
                        fi

                        echo "Rails n'est pas encore prêt... ($i/30)"
                        sleep 2
                    done

                    echo "=== Vérification de l'application ==="
                    curl -I http://localhost:3000 || true

                    mkdir -p reports

                    echo "=== Lancement OWASP ZAP ==="

                    /snap/zaproxy/70/zap.sh \
                      -cmd \
                      -port 8090 \
                      -quickurl http://localhost:3000 \
                      -quickprogress \
                      -quickout "$WORKSPACE/reports/zap-report.xml"

                    echo "=== Rapport ZAP ==="
                    ls -lh reports/zap-report.xml
                '''
            }

            post {
                always {
                    sh '''
                        docker rm -f rails-zap-target 2>/dev/null || true
                    '''
                }
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

    post {
        always {
            archiveArtifacts artifacts: 'reports/zap-report.xml',
                             allowEmptyArchive: true
        }
    }
}
