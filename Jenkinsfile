pipeline {
    agent any

    parameters {
        choice(
            name: 'ENVIRONMENT',
            choices: ['test', 'stage'],
            description: 'Select environment to run tests'
        )
        choice(
            name: 'TEST_SUITE',
            choices: [
                'All_Tests',
                'Adhoc_Inbound_and_Outbound',
                'Auto_Accept_Auto_Ship_Out',
                'Decommission',
                'Pack_And_Decommisson',
                'Pack_Unpack_Child',
                'Pack_Unpack_Parent'
            ],
            description: 'Select test suite to execute'
        )
        booleanParam(
            name: 'HEADLESS_MODE',
            defaultValue: true,
            description: 'Run tests in headless mode'
        )
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out code from repository...'
                git branch: 'master', url: 'https://github.com/AhmedAli008/RobotFrameWork.git'

                bat '''
                    echo Current directory contents:
                    dir
                    echo Git status:
                    git status
                '''
            }
        }

        stage('Setup Python Environment') {
            steps {
                echo 'Setting up Python environment...'
                bat '''
                    echo Creating virtual environment...
                    python -m venv venv

                    echo Activating virtual environment...
                    call venv\\Scripts\\activate.bat

                    echo Upgrading pip...
                    python -m pip install --upgrade pip

                    echo Installing packages...
                    python -m pip install robotframework==6.1.1
                    python -m pip install robotframework-seleniumlibrary==6.2.0
                    python -m pip install selenium==4.15.2
                    python -m pip install requests==2.31.0
                    python -m pip install webdriver-manager==4.0.1

                    echo Verifying installation...
                    robot --version || echo Robot Framework version check completed

                    echo All packages installed successfully!
                    exit /b 0
                '''
            }
        }

        stage('Create Directories') {
            steps {
                bat '''
                    if not exist Output mkdir Output
                    if not exist log mkdir log
                    echo Directories created successfully
                '''
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    def testCommand = ""
                    switch(params.TEST_SUITE) {
                    case 'All_Tests':
                            testCommand = "Tests"
                            break
                        case 'Auto_Accept_Auto_Ship_Out':
                            testCommand = "Tests\\Auto_Accept_Auto_Ship_Out.robot"
                            break
                        default:
                            testCommand = "Tests\\${params.TEST_SUITE}.robot"
                    }

                    bat """
                        echo Activating virtual environment...
                        call venv\\Scripts\\activate.bat

                        echo Running tests with command: robot -d Output -v ENV:${params.ENVIRONMENT} -v HEADLESS:${params.HEADLESS_MODE} --timestampoutputs ${testCommand}
                        robot -d Output ^
                              -v ENV:${params.ENVIRONMENT} ^
                              -v HEADLESS:${params.HEADLESS_MODE} ^
                              --timestampoutputs ^
                              ${testCommand}
                    """
                }
            }
        }
    }

    post {
        always {
            echo 'Archiving results...'
            archiveArtifacts artifacts: 'Output/**/*', allowEmptyArchive: true

            bat '''
                echo Test results:
                if exist Output dir Output
                echo Pipeline execution completed
            '''
        }

        success {
            echo 'Pipeline completed successfully!'
        }

        failure {
            echo 'Pipeline failed. Check logs for details.'
            bat '''
                echo Debugging information:
                echo Python version:
                python --version
                echo Current directory:
                cd
                echo Directory contents:
                dir
                if exist venv (
                    echo Virtual environment exists
                    call venv\\Scripts\\activate.bat && pip list
                ) else (
                    echo Virtual environment not found
                )
            '''
        }
    }
}