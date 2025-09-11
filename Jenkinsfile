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

    environment {
        PYTHON_PATH = "${WORKSPACE}/venv"
        ROBOT_OUTPUT_DIR = "${WORKSPACE}/Output"
        ROBOT_LOG_DIR = "${WORKSPACE}/log"
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out code from repository...'
                checkout scm
            }
        }

        stage('Setup Python Environment') {
            steps {
                script {
                    if (isUnix()) {
                        // Linux/Mac setup
                        sh '''
                            python3 -m venv venv
                            . venv/bin/activate
                            pip install --upgrade pip
                            pip install robotframework
                            pip install robotframework-seleniumlibrary
                            pip install selenium
                            pip install requests
                            pip install webdriver-manager
                        '''
                    } else {
                        // Windows setup
                        bat '''
                            python -m venv venv
                            call venv\\Scripts\\activate.bat
                            pip install --upgrade pip
                            pip install robotframework
                            pip install robotframework-seleniumlibrary
                            pip install selenium
                            pip install requests
                            pip install webdriver-manager
                        '''
                    }
                }
            }
        }

        stage('Install Browser Dependencies') {
            steps {
                script {
                    if (isUnix()) {
                        sh '''
                            . venv/bin/activate
                            python -c "
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager
import os

# Download and setup ChromeDriver
chrome_driver_path = ChromeDriverManager().install()
print(f'ChromeDriver installed at: {chrome_driver_path}')

# Setup Chrome options for headless mode
from selenium.webdriver.chrome.options import Options
chrome_options = Options()
chrome_options.add_argument('--headless')
chrome_options.add_argument('--no-sandbox')
chrome_options.add_argument('--disable-dev-shm-usage')
chrome_options.add_argument('--disable-gpu')
chrome_options.add_argument('--window-size=1920,1080')

print('Browser dependencies installed successfully')
"
                        '''
                    } else {
                        bat '''
                            call venv\\Scripts\\activate.bat
                            python -c "
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager
import os

# Download and setup ChromeDriver
chrome_driver_path = ChromeDriverManager().install()
print(f'ChromeDriver installed at: {chrome_driver_path}')

print('Browser dependencies installed successfully')
"
                        '''
                    }
                }
            }
        }

        stage('Create Output Directories') {
            steps {
                script {
                    if (isUnix()) {
                        sh '''
                            mkdir -p Output
                            mkdir -p log
                        '''
                    } else {
                        bat '''
                            if not exist Output mkdir Output
                            if not exist log mkdir log
                        '''
                    }
                }
            }
        }

        stage('Run Robot Framework Tests') {
            steps {
                script {
                    def testCommand = ""
                    def outputDir = "Output"
                    def logDir = "log"

                    // Determine which test to run
                    switch(params.TEST_SUITE) {
                        case 'All_Tests':
                            testCommand = "Tests/"
                            break
                        case 'Adhoc_Inbound_and_Outbound':
                            testCommand = "Tests/Adhoc_Inbound_and_Outbound.robot"
                            break
                        case 'Auto_Accept_Auto_Ship_Out':
                            testCommand = "Tests/Auto_Accept_Auto_Ship_Out.robot"
                            break
                        case 'Decommission':
                            testCommand = "Tests/Decommission.robot"
                            break
                        case 'Pack_And_Decommisson':
                            testCommand = "Tests/Pack_And_Decommisson.robot"
                            break
                        case 'Pack_Unpack_Child':
                            testCommand = "Tests/Pack_Unpack_Child.robot"
                            break
                        case 'Pack_Unpack_Parent':
                            testCommand = "Tests/Pack_Unpack_Parent.robot"
                            break
                        default:
                            testCommand = "Tests/"
                    }

                    if (isUnix()) {
                        sh """
                            . venv/bin/activate
                            robot -d ${outputDir} \\
                                  -L DEBUG \\
                                  -v ENV:${params.ENVIRONMENT} \\
                                  -v HEADLESS:${params.HEADLESS_MODE} \\
                                  --timestampoutputs \\
                                  --console verbose \\
                                  ${testCommand}
                        """
                    } else {
                        bat """
                            call venv\\Scripts\\activate.bat
                            robot -d ${outputDir} ^
                                  -L DEBUG ^
                                  -v ENV:${params.ENVIRONMENT} ^
                                  -v HEADLESS:${params.HEADLESS_MODE} ^
                                  --timestampoutputs ^
                                  --console verbose ^
                                  ${testCommand}
                        """
                    }
                }
            }
        }
    }

    post {
        always {
            echo 'Cleaning up and publishing results...'

            // Archive test results
            archiveArtifacts artifacts: 'Output/**/*', allowEmptyArchive: true
            archiveArtifacts artifacts: 'log/**/*', allowEmptyArchive: true

            // Publish Robot Framework results
            publishHTML([
                allowMissing: false,
                alwaysLinkToLastBuild: true,
                keepAll: true,
                reportDir: 'Output',
                reportFiles: '*.html',
                reportName: 'Robot Framework Test Results',
                reportTitles: 'Test Report'
            ])

            // Clean workspace if needed
            script {
                if (params.CLEAN_WORKSPACE == true) {
                    cleanWs()
                }
            }
        }

        success {
            echo 'Tests completed successfully!'
            // You can add notifications here (email, Slack, etc.)
        }

        failure {
            echo 'Tests failed!'
            // You can add failure notifications here
        }

        unstable {
            echo 'Tests completed with some failures!'
        }
    }
}