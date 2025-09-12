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
                    python -m venv venv
                    call venv\\Scripts\\activate.bat
                    pip install --upgrade pip
                    pip install robotframework==6.1.1
                    pip install robotframework-seleniumlibrary==6.2.0
                    pip install selenium==4.15.2
                    pip install requests==2.31.0
                    pip install webdriver-manager==4.0.1
                    robot --version
                '''
            }
        }

        stage('Setup Browser') {
            steps {
                echo 'Setting up browser drivers...'
                script {
                    writeFile file: 'setup_browser.py', text: '''
import sys
import os

try:
    print("Starting browser setup...")

    # Add some debugging info
    print(f"Python version: {sys.version}")
    print(f"Current working directory: {os.getcwd()}")

    from webdriver_manager.chrome import ChromeDriverManager
    from selenium import webdriver
    from selenium.webdriver.chrome.options import Options
    from selenium.webdriver.chrome.service import Service

    print("Installing ChromeDriver...")
    try:
        driver_path = ChromeDriverManager().install()
        print(f"ChromeDriver installed at: {driver_path}")
    except Exception as e:
        print(f"ChromeDriver installation failed: {e}")
        print("Trying alternative approach...")
        driver_path = ChromeDriverManager(version="114.0.5735.90").install()
        print(f"ChromeDriver installed at: {driver_path}")

    # Test browser with more robust options
    print("Testing browser...")
    options = Options()
    options.add_argument("--headless=new")
    options.add_argument("--no-sandbox")
    options.add_argument("--disable-dev-shm-usage")
    options.add_argument("--disable-gpu")
    options.add_argument("--disable-web-security")
    options.add_argument("--allow-running-insecure-content")
    options.add_argument("--disable-extensions")
    options.add_argument("--disable-plugins")
    options.add_argument("--disable-images")
    options.add_argument("--disable-javascript")
    options.add_argument("--remote-debugging-port=9222")

    service = Service(driver_path)
    driver = webdriver.Chrome(service=service, options=options)

    print("Browser created successfully, testing navigation...")
    driver.get("https://www.google.com")
    print(f"Browser test successful: {driver.title}")
    driver.quit()
    print("Browser setup completed successfully!")

except ImportError as e:
    print(f"Import error: {e}")
    print("Required packages might not be installed properly")
    sys.exit(1)
except Exception as e:
    print(f"Browser setup error: {str(e)}")
    print(f"Error type: {type(e).__name__}")
    import traceback
    print("Full traceback:")
    traceback.print_exc()
    sys.exit(1)
'''
                }

                bat '''
                    call venv\\Scripts\\activate.bat
                    python setup_browser.py
                    if %ERRORLEVEL% NEQ 0 (
                        echo Browser setup failed with exit code %ERRORLEVEL%
                        exit /b 1
                    )
                    del setup_browser.py
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
                echo Pip list:
                call venv\\Scripts\\activate.bat && pip list
            '''
        }
    }
}