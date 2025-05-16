pipeline {
    agent any

    parameters {
        choice(name: 'ENV', choices: ['dev', 'prod'], description: 'Select environment')
    }

    environment {
        // Map ENV to corresponding Jenkins credential ID
        AWS_CREDENTIALS = "${params.ENV == 'dev' ? 'aws-dev-creds' : 'aws-prod-creds'}"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding', 
                    credentialsId: env.AWS_CREDENTIALS
                ]]) {
                    dir('Terraform') {
                        bat "terraform init -reconfigure -backend-config=env_vars\\\\${params.ENV}.backend"


                    }
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding', 
                    credentialsId: env.AWS_CREDENTIALS
                ]]) {
                    dir('Terraform') {
                        bat 'terraform plan'
                    }
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                input message: "Apply changes to ${params.ENV}?", ok: 'Apply'
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding', 
                    credentialsId: env.AWS_CREDENTIALS
                ]]) {
                    dir('Terraform') {
                        bat 'terraform apply -auto-approve'
                    }
                }
            }
        }
    }
}
