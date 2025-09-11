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
        PYTHON_PATH = "${WORKSPACE}\\venv"
        ROBOT_OUTPUT_DIR = "${WORKSPACE}\\Output"
        ROBOT_LOG_DIR = "${WORKSPACE}\\log"
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
                bat '''
                    echo Setting up Python environment...
                    python -m venv venv
                    call venv\\Scripts\\activate.bat
                    python -m pip install --upgrade pip
                    pip install robotframework==6.1.1
                    pip install robotframework-seleniumlibrary==6.2.0
                    pip install selenium==4.15.2
                    pip install requests==2.31.0
                    pip install webdriver-manager==4.0.1
                    echo Python environment setup completed
                '''
            }
        }

        stage('Setup Browser Drivers') {
            steps {
                script {
                    // Create Python script for driver setup
                    writeFile file: 'setup_browser.py', text: '''
import sys
try:
    from webdriver_manager.chrome import ChromeDriverManager
    from selenium import webdriver
    from selenium.webdriver.chrome.options import Options
    from selenium.webdriver.chrome.service import Service

    print("Installing ChromeDriver...")
    driver_path = ChromeDriverManager().install()
    print(f"ChromeDriver installed successfully at: {driver_path}")

    # Test browser setup
    print("Testing browser setup...")
    options = Options()
    options.add_argument("--headless")
    options.add_argument("--no-sandbox")
    options.add_argument("--disable-dev-shm-usage")
    options.add_argument("--disable-gpu")
    options.add_argument("--window-size=1920,1080")

    service = Service(driver_path)
    driver = webdriver.Chrome(service=service, options=options)
    driver.get("https://www.google.com")
    title = driver.title
    driver.quit()

    print(f"Browser test successful. Page title: {title}")
    print("Browser setup completed successfully!")

except Exception as e:
    print(f"Error during browser setup: {e}")
    sys.exit(1)
'''
                }

                bat '''
                    call venv\\Scripts\\activate.bat
                    python setup_browser.py
                    del setup_browser.py
                '''
            }
        }

        stage('Create Output Directories') {
            steps {
                bat '''
                    if not exist Output mkdir Output
                    if not exist log mkdir log
                    echo Output directories created
                '''
            }
        }

        stage('Run Robot Framework Tests') {
            steps {
                script {
                    def testCommand = ""

                    // Determine which test to run
                    switch(params.TEST_SUITE) {
                        case 'All_Tests':
                            testCommand = "Tests\\"
                            break
                        case 'Adhoc_Inbound_and_Outbound':
                            testCommand = "Tests\\Adhoc_Inbound_and_Outbound.robot"
                            break
                        case 'Auto_Accept_Auto_Ship_Out':
                            testCommand = "Tests\\Auto_Accept_Auto_Ship_Out.robot"
                            break
                        case 'Decommission':
                            testCommand = "Tests\\Decommission.robot"
                            break
                        case 'Pack_And_Decommisson':
                            testCommand = "Tests\\Pack_And_Decommisson.robot"
                            break
                        case 'Pack_Unpack_Child':
                            testCommand = "Tests\\Pack_Unpack_Child.robot"
                            break
                        case 'Pack_Unpack_Parent':
                            testCommand = "Tests\\Pack_Unpack_Parent.robot"
                            break
                        default:
                            testCommand = "Tests\\"
                    }

                    bat """
                        call venv\\Scripts\\activate.bat
                        robot -d Output ^
                              -L DEBUG ^
                              -v ENV:${params.ENVIRONMENT} ^
                              -v HEADLESS:${params.HEADLESS_MODE} ^
                              --timestampoutputs ^
                              --console verbose ^
                              --reporttitle "Robot Framework Test Report" ^
                              --logtitle "Robot Framework Test Log" ^
                              ${testCommand}
                    """
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline completed. Archiving results...'

            // Archive all output files
            archiveArtifacts artifacts: 'Output/**/*', allowEmptyArchive: true, fingerprint: true
            archiveArtifacts artifacts: 'log/**/*', allowEmptyArchive: true

            // List output files for verification
            bat '''
                echo Listing output files:
                dir Output /b
            '''

            echo 'Results archived successfully!'
            echo 'You can download the HTML reports from the Build Artifacts section.'
        }

        success {
            echo 'All tests completed successfully!'
            emailext (
                subject: "Jenkins Success: ${env.JOB_NAME} - Build ${env.BUILD_NUMBER}",
                body: """
Test execution completed successfully!

Environment: ${params.ENVIRONMENT}
Test Suite: ${params.TEST_SUITE}
Headless Mode: ${params.HEADLESS_MODE}

View results at: ${env.BUILD_URL}

Download reports from the Build Artifacts section.
                """,
                to: "${env.CHANGE_AUTHOR_EMAIL}",
                mimeType: 'text/plain'
            )
        }

        failure {
            echo 'Pipeline failed! Check the console output for details.'
            emailext (
                subject: "Jenkins Failure: ${env.JOB_NAME} - Build ${env.BUILD_NUMBER}",
                body: """
Test execution failed!

Environment: ${params.ENVIRONMENT}
Test Suite: ${params.TEST_SUITE}

Check the console output at: ${env.BUILD_URL}console

Please review the logs and fix the issues.
                """,
                to: "${env.CHANGE_AUTHOR_EMAIL}",
                mimeType: 'text/plain'
            )
        }

        unstable {
            echo 'Tests completed with some failures!'
        }
    }
}