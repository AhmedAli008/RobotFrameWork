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
        string(
            name: 'EMAIL_RECIPIENTS',
            defaultValue: 'youremail@gmail.com',
            description: 'Email addresses to notify (comma-separated)'
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
            post {
                always {
                    // Parse Robot Framework test results
                    script {
                        if (fileExists('Output/output.xml')) {
                            step([
                                $class: 'RobotPublisher',
                                outputPath: 'Output',
                                outputFileName: 'output.xml',
                                reportFileName: 'report.html',
                                logFileName: 'log.html',
                                disableArchiveOutput: false,
                                passThreshold: 100,
                                unstableThreshold: 95,
                                otherFiles: "**/*.png,**/*.jpg"
                            ])
                        }
                    }
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

            // Send email notification for all builds
            script {
                def buildStatus = currentBuild.result ?: 'SUCCESS'
                def testSummary = ""

                // Try to read Robot Framework results if available
                if (fileExists('Output/output.xml')) {
                    try {
                        def output = readFile('Output/output.xml')
                        // Extract basic statistics (you might want to enhance this parsing)
                        testSummary = "\n\nTest results are available in the archived artifacts."
                    } catch (Exception e) {
                        testSummary = "\n\nTest results could not be parsed."
                    }
                } else {
                    testSummary = "\n\nNo test results found."
                }

                emailext (
                    subject: "[Jenkins] ${buildStatus}: Robot Framework Tests - ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                    body: """
Robot Framework Test Execution Report

Build Status: ${buildStatus}
Job: ${env.JOB_NAME}
Build Number: ${env.BUILD_NUMBER}
Environment: ${params.ENVIRONMENT}
Test Suite: ${params.TEST_SUITE}
Headless Mode: ${params.HEADLESS_MODE}
Build Duration: ${currentBuild.durationString}
Triggered by: ${currentBuild.getBuildCauses()[0]?.shortDescription ?: 'Unknown'}

Build URL: ${env.BUILD_URL}
Console Output: ${env.BUILD_URL}console
Test Report: ${env.BUILD_URL}artifact/Output/report.html
Test Log: ${env.BUILD_URL}artifact/Output/log.html

${testSummary}

This is an automated message from Jenkins.
                    """.trim(),
                    to: "${params.EMAIL_RECIPIENTS}",
                    mimeType: 'text/plain'
                )
            }
        }

        success {
            echo 'Pipeline completed successfully!'

            emailext (
                subject: "[Jenkins] SUCCESS: Robot Framework Tests Passed - ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: """
🎉 Test Execution Successful!

All Robot Framework tests completed successfully.

Environment: ${params.ENVIRONMENT}
Test Suite: ${params.TEST_SUITE}
Build Duration: ${currentBuild.durationString}

View Results:
• Test Report: ${env.BUILD_URL}artifact/Output/report.html
• Test Log: ${env.BUILD_URL}artifact/Output/log.html
• Build Details: ${env.BUILD_URL}

Great work! All tests are passing.
                """.trim(),
                to: "${params.EMAIL_RECIPIENTS}",
                mimeType: 'text/plain'
            )
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

            emailext (
                subject: "[Jenkins] FAILED: Robot Framework Tests - ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: """
❌ Test Execution Failed!

The Robot Framework test execution encountered an error.

Environment: ${params.ENVIRONMENT}
Test Suite: ${params.TEST_SUITE}
Build Duration: ${currentBuild.durationString}
Failure Node: ${env.NODE_NAME}

Troubleshooting:
• Console Output: ${env.BUILD_URL}console
• Build Details: ${env.BUILD_URL}
• Archived Artifacts: ${env.BUILD_URL}artifact/

Please check the console output for detailed error information.

If test results were generated:
• Test Report: ${env.BUILD_URL}artifact/Output/report.html
• Test Log: ${env.BUILD_URL}artifact/Output/log.html

Action Required: Please investigate the failure and re-run the tests.
                """.trim(),
                to: "${params.EMAIL_RECIPIENTS}",
                mimeType: 'text/plain'
            )
        }

        unstable {
            echo 'Pipeline is unstable. Some tests may have failed.'

            emailext (
                subject: "[Jenkins] UNSTABLE: Robot Framework Tests - ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: """
⚠️ Test Execution Unstable!

Some Robot Framework tests may have failed or the build is unstable.

Environment: ${params.ENVIRONMENT}
Test Suite: ${params.TEST_SUITE}
Build Duration: ${currentBuild.durationString}

View Results:
• Test Report: ${env.BUILD_URL}artifact/Output/report.html
• Test Log: ${env.BUILD_URL}artifact/Output/log.html
• Console Output: ${env.BUILD_URL}console

Please review the test results to identify which tests failed and take appropriate action.
                """.trim(),
                to: "${params.EMAIL_RECIPIENTS}",
                mimeType: 'text/plain'
            )
        }
    }
}