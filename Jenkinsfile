pipeline {
    agent any

    parameters {
        choice(name: 'ENV', choices: ['dev', 'prod'], description: 'Select the environment')
    }

    environment {
        TF_VAR_env = "${params.ENV}"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git 'https://github.com/your-username/your-terraform-repo.git'
            }
        }

        stage('Set AWS Credentials') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: "aws-${params.ENV}-creds"
                ]]) {
                    echo "Using AWS credentials for ${params.ENV} environment"
                }
            }
        }

        stage('Terraform Init') {
            steps {
                bat """
                    terraform init -backend-config=env_vars/${params.ENV}.backend
                """
            }
        }

        stage('Terraform Plan') {
            steps {
                bat "terraform plan"
            }
        }

        stage('Terraform Apply') {
            steps {
                input message: "Apply Terraform changes to ${params.ENV}?"
                bat "terraform apply -auto-approve"
            }
        }
    }
}
