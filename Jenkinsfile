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

                // Verify checkout
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
try:
    from webdriver_manager.chrome import ChromeDriverManager
    from selenium import webdriver
    from selenium.webdriver.chrome.options import Options
    from selenium.webdriver.chrome.service import Service

    print("Installing ChromeDriver...")
    driver_path = ChromeDriverManager().install()
    print(f"ChromeDriver installed at: {driver_path}")

    # Test browser
    options = Options()
    options.add_argument("--headless")
    options.add_argument("--no-sandbox")
    options.add_argument("--disable-dev-shm-usage")

    service = Service(driver_path)
    driver = webdriver.Chrome(service=service, options=options)
    driver.get("https://www.google.com")
    print(f"Browser test successful: {driver.title}")
    driver.quit()

except Exception as e:
    print(f"Browser setup error: {e}")
'''
                }

                bat '''
                    call venv\\Scripts\\activate.bat
                    python setup_browser.py
                    del setup_browser.py
                '''
            }
        }

        stage('Create Directories') {
            steps {
                bat '''
                    if not exist Output mkdir Output
                    if not exist log mkdir log
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
            '''
        }

        success {
            echo 'Pipeline completed successfully!'
        }

        failure {
            echo 'Pipeline failed. Check logs for details.'
        }
    }
}
```

## Why This Fixes The Issue

1. **Direct Git checkout** using simple `git` step instead of complex SCM configuration
2. **No dependency on external Jenkinsfile** - everything is in the job configuration
3. **Simplified approach** that bypasses the Git workspace initialization issue
4. **Immediate execution** without Jenkins trying to read files from repository first

## Alternative Solution: Fix SCM Configuration

If you prefer to keep using "Pipeline script from SCM":

1. **Check your GitHub repository** - make sure the Jenkinsfile exists in the root
2. **Try different branch** - use 'main' instead of 'master' if that's your default branch
3. **Add Git credentials** if repository is private
4. **Check Jenkins Git plugin** is properly installed

But the inline script approach above should work immediately and bypass all Git configuration issues.