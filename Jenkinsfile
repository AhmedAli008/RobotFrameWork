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

    options {
        // Clean workspace before checkout
        skipDefaultCheckout(true)
        // Keep only last 10 builds
        buildDiscarder(logRotator(numToKeepStr: '10'))
        // Timeout after 30 minutes
        timeout(time: 30, unit: 'MINUTES')
    }

    environment {
        PYTHON_PATH = "${WORKSPACE}\\venv"
        ROBOT_OUTPUT_DIR = "${WORKSPACE}\\Output"
        ROBOT_LOG_DIR = "${WORKSPACE}\\log"
    }

    stages {
        stage('Clean and Checkout') {
            steps {
                echo 'Cleaning workspace and checking out code...'

                // Clean workspace completely
                cleanWs()

                // Checkout code with explicit configuration
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/master']],
                    userRemoteConfigs: [[
                        url: 'https://github.com/AhmedAli008/RobotFrameWork.git'
                    ]],
                    extensions: [
                        [$class: 'CleanBeforeCheckout'],
                        [$class: 'CloneOption', depth: 1, noTags: false, reference: '', shallow: true]
                    ]
                ])

                // Verify checkout
                bat '''
                    echo Verifying checkout...
                    dir
                    git --version
                    git status
                '''
            }
        }

        stage('Setup Python Environment') {
            steps {
                echo 'Setting up Python environment...'
                bat '''
                    echo Current directory:
                    cd
                    echo Creating Python virtual environment...
                    python -m venv venv
                    echo Activating virtual environment...
                    call venv\\Scripts\\activate.bat
                    echo Upgrading pip...
                    python -m pip install --upgrade pip
                    echo Installing Robot Framework...
                    pip install robotframework==6.1.1
                    echo Installing Selenium Library...
                    pip install robotframework-seleniumlibrary==6.2.0
                    echo Installing Selenium...
                    pip install selenium==4.15.2
                    echo Installing additional dependencies...
                    pip install requests==2.31.0
                    pip install webdriver-manager==4.0.1
                    echo Verifying installation...
                    robot --version
                    echo Python environment setup completed successfully!
                '''
            }
        }

        stage('Setup Browser Drivers') {
            steps {
                echo 'Setting up browser drivers...'
                script {
                    // Create Python script for driver setup
                    writeFile file: 'setup_browser.py', text: '''
import sys
import os

print("Starting browser driver setup...")
print(f"Current directory: {os.getcwd()}")
print(f"Python version: {sys.version}")

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
    options.add_argument("--disable-extensions")
    options.add_argument("--disable-plugins")

    print("Creating Chrome service...")
    service = Service(driver_path)

    print("Starting Chrome browser...")
    driver = webdriver.Chrome(service=service, options=options)

    print("Navigating to test page...")
    driver.get("https://www.google.com")
    title = driver.title

    print("Closing browser...")
    driver.quit()

    print(f"Browser test successful! Page title: {title}")
    print("Browser setup completed successfully!")

except ImportError as e:
    print(f"Import error: {e}")
    print("Please check if all required packages are installed")
    sys.exit(1)
except Exception as e:
    print(f"Error during browser setup: {e}")
    print("Browser setup failed, but continuing with pipeline...")
    # Don't exit with error to allow pipeline to continue

print("Browser driver setup stage completed.")
'''
                }

                bat '''
                    echo Executing browser setup script...
                    call venv\\Scripts\\activate.bat
                    python setup_browser.py
                    echo Cleaning up temporary files...
                    if exist setup_browser.py del setup_browser.py
                '''
            }
        }

        stage('Create Output Directories') {
            steps {
                echo 'Creating output directories...'
                bat '''
                    echo Creating Output directory...
                    if not exist Output mkdir Output
                    echo Creating log directory...
                    if not exist log mkdir log
                    echo Listing current directory contents...
                    dir
                    echo Output directories created successfully!
                '''
            }
        }

        stage('Validate Robot Framework') {
            steps {
                echo 'Validating Robot Framework setup...'
                bat '''
                    call venv\\Scripts\\activate.bat
                    echo Checking Robot Framework version...
                    robot --version
                    echo Checking test files...
                    dir Tests
                    echo Validation completed!
                '''
            }
        }

        stage('Run Robot Framework Tests') {
            steps {
                echo 'Starting Robot Framework test execution...'
                script {
                    def testCommand = ""

                    // Determine which test to run
                    switch(params.TEST_SUITE) {
                        case 'All_Tests':
                            testCommand = "Tests"
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
                            testCommand = "Tests"
                    }

                    echo "Executing test suite: ${testCommand}"
                    echo "Environment: ${params.ENVIRONMENT}"
                    echo "Headless mode: ${params.HEADLESS_MODE}"

                    bat """
                        call venv\\Scripts\\activate.bat
                        echo Starting Robot Framework execution...
                        robot -d Output ^
                              -L INFO ^
                              -v ENV:${params.ENVIRONMENT} ^
                              -v HEADLESS:${params.HEADLESS_MODE} ^
                              --timestampoutputs ^
                              --console verbose ^
                              --reporttitle "Robot Framework Test Report - ${params.TEST_SUITE}" ^
                              --logtitle "Robot Framework Test Log - ${params.TEST_SUITE}" ^
                              --reportbackground "#f0f0f0" ^
                              ${testCommand}
                        echo Robot Framework execution completed!
                    """
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline execution completed. Processing results...'

            script {
                try {
                    // List output files
                    bat '''
                        echo === OUTPUT DIRECTORY CONTENTS ===
                        if exist Output (
                            dir Output /b
                            echo Output files found
                        ) else (
                            echo No Output directory found
                        )

                        echo === LOG DIRECTORY CONTENTS ===
                        if exist log (
                            dir log /b
                            echo Log files found
                        ) else (
                            echo No log directory found
                        )
                    '''

                    // Archive all output files
                    archiveArtifacts artifacts: 'Output/**/*', allowEmptyArchive: true, fingerprint: true
                    archiveArtifacts artifacts: 'log/**/*', allowEmptyArchive: true

                    echo 'Test results archived successfully!'
                    echo 'Download reports from Build Artifacts section.'

                } catch (Exception e) {
                    echo "Error during result processing: ${e.getMessage()}"
                }
            }
        }

        success {
            echo 'All tests completed successfully!'
            script {
                try {
                    emailext (
                        subject: "✅ Jenkins SUCCESS: ${env.JOB_NAME} - Build #${env.BUILD_NUMBER}",
                        body: """
Test execution completed successfully!

📊 Test Details:
• Environment: ${params.ENVIRONMENT}
• Test Suite: ${params.TEST_SUITE}
• Headless Mode: ${params.HEADLESS_MODE}
• Build Number: ${env.BUILD_NUMBER}

🔗 Links:
• View Build: ${env.BUILD_URL}
• Console Output: ${env.BUILD_URL}console
• Download Reports: ${env.BUILD_URL}artifact/

The test reports are available in the Build Artifacts section.
                        """,
                        mimeType: 'text/plain'
                    )
                } catch (Exception e) {
                    echo "Email notification failed: ${e.getMessage()}"
                }
            }
        }

        failure {
            echo 'Pipeline execution failed!'
            script {
                try {
                    emailext (
                        subject: "❌ Jenkins FAILURE: ${env.JOB_NAME} - Build #${env.BUILD_NUMBER}",
                        body: """
Test execution failed!

📊 Test Details:
• Environment: ${params.ENVIRONMENT}
• Test Suite: ${params.TEST_SUITE}
• Build Number: ${env.BUILD_NUMBER}

🔗 Troubleshooting:
• Console Output: ${env.BUILD_URL}console
• Build Details: ${env.BUILD_URL}

Please check the console output for detailed error information.
                        """,
                        mimeType: 'text/plain'
                    )
                } catch (Exception e) {
                    echo "Email notification failed: ${e.getMessage()}"
                }
            }
        }

        unstable {
            echo 'Tests completed with some failures!'
        }
    }
}