pipeline {
    agent any

    parameters {
        choice(name: 'ENV', choices: ['dev', 'prod'], description: 'Select environment')
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                dir('Terraform') {
                    bat "terraform init -backend-config=env_vars\\${params.ENV}.backend"
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir('Terraform') {
                    bat 'terraform plan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                input message: "Apply changes to ${params.ENV}?", ok: 'Apply'
                dir('Terraform') {
                    bat 'terraform apply -auto-approve'
                }
            }
        }
    }
}
