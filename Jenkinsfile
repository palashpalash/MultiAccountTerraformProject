pipeline {
    agent any

    parameters {
        choice(name: 'ENV', choices: ['dev', 'prod'], description: 'Environment to deploy to')
    }

    environment {
        AWS_CREDENTIALS = credentials("aws-${params.ENV}-creds")
    }

    stages {
        stage('Clone Repo') {
            steps {
                git url: 'https://github.com/your-org/your-repo.git', branch: 'main'
            }
        }

        stage('Terraform Init') {
            steps {
                bat "terraform init -backend-config=env_vars/${params.ENV}.tfvars"
            }
        }

        stage('Terraform Plan') {
            steps {
                bat "terraform plan -var-file=env_vars/${params.ENV}.tfvars"
            }
        }

        stage('Terraform Apply') {
            steps {
                input message: "Approve apply for ${params.ENV}?"
                bat "terraform apply -auto-approve -var-file=env_vars/${params.ENV}.tfvars"
            }
        }
    }
}
