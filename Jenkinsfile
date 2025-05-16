pipeline {
    agent any

    parameters {
        choice(name: 'env', choices: ['dev', 'prod'], description: 'Choose the environment')
    }

    environment {
        TF_ENV = "${params.env}"
        AWS_CREDENTIALS_ID = "${params.env == 'prod' ? 'aws-prod-creds' : 'aws-dev-creds'}"
        TF_VAR_FILE = "terraform/env_vars/${params.env}.tfvars"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding',
                                  credentialsId: "${env.AWS_CREDENTIALS_ID}"]]) {
                    dir('terraform') {
                        sh """
                            terraform init \
                              -backend-config="bucket=\$(grep bucket ${env.TF_VAR_FILE} | awk '{print \$3}' | tr -d '\"')" \
                              -backend-config="key=\$(grep key ${env.TF_VAR_FILE} | awk '{print \$3}' | tr -d '\"')" \
                              -backend-config="region=\$(grep region ${env.TF_VAR_FILE} | awk '{print \$3}' | tr -d '\"')"
                        """
                    }
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir('terraform') {
                    sh "terraform plan -var-file=${env.TF_VAR_FILE}"
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                input message: "Apply changes to ${params.env} environment?"
                dir('terraform') {
                    sh "terraform apply -auto-approve -var-file=${env.TF_VAR_FILE}"
                }
            }
        }
    }
}
