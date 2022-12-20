pipeline{
    agent any
    parameters {
        string(name: 'git_url', description: 'url of github', defaultValue: 'https://github.com/vanehru/demophp.git')
        choice(name: 'deploy', choices: ['true', 'False'], description: 'deploy')

    }

    stages{
            stage('clone'){
                when {
                    anyOf {
                        expression { env.BRANCH_NAME == 'master' }
                        expression { env.BRANCH_NAME == 'dev' }
                        }
                }
                steps{
                    checkout([
                        $class: 'GitSCM', 
                        branches: [[name: "${env.BRANCH_NAME}"]],
                        userRemoteConfigs: [[credentialsId: 'Githubcred', url: "${params.git_url}"]]
                        ])
                    }
                }
            stage('docker image stages'){
                when {
                    allOf {
                        anyOf {
                            expression { env.BRANCH_NAME == 'master' }
                            expression { env.BRANCH_NAME == 'dev' }
                            }
                        expression { params.deploy == "true" }
                        }
                    }
                stages{
                    stage('set env_name'){
                        steps{
                            script {
                                if (env.BRANCH_NAME == 'master') {
                                    env_name= 'prod'
                                } else if (env.BRANCH_NAME == 'dev') {
                                    env_name= 'dev'
                                } else {
                                    println('branch is not listed')
                                    sh'exit 0'
                                }
                            }
                        }
                    }

                
                    stage('docker build'){
                        steps{
                        sh """docker build -t myphp.azurecr.io/demo/${env_name}:${BUILD_NUMBER} ."""
                        }
                    }

                    stage('docker push'){
                        steps{
                        sh """
                        
                        docker push myphp.azurecr.io/demo/${env_name}:$BUILD_NUMBER 
                        """
                        }
                    }

                    
                } 
            }
        }
}
