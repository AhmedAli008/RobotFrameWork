import os
import sys
import subprocess
import argparse
import platform
from datetime import datetime

class TestRunner:
    def __init__(self):
        self.project_root = os.path.dirname(os.path.abspath(__file__))
        self.output_dir = os.path.join(self.project_root, "Output")
        self.log_dir = os.path.join(self.project_root, "log")

        # Determine robot command based on platform
        if platform.system() == "Windows":
            self.robot_cmd = os.path.join("venv", "Scripts", "robot.exe")
            self.python_cmd = os.path.join("venv", "Scripts", "python.exe")
        else:
            self.robot_cmd = os.path.join("venv", "bin", "robot")
            self.python_cmd = os.path.join("venv", "bin", "python")

    def create_output_dirs(self):
        """Create output directories if they don't exist"""
        for directory in [self.output_dir, self.log_dir]:
            if not os.path.exists(directory):
                os.makedirs(directory)
                print(f"Created directory: {directory}")

    def create_pause_modifier(self, pause_seconds=2):
        """Create a pause modifier file for Robot Framework"""
        modifier_content = f'''
import time

class PauseModifier:
    """Modifier that adds a pause after each test case"""
    
    ROBOT_LISTENER_API_VERSION = 2
    
    def __init__(self):
        self.pause_seconds = {pause_seconds}
    
    def end_test(self, name, attributes):
        """Called when a test case ends"""
        print(f"Pausing for {{self.pause_seconds}} seconds after test: {{name}}")
        time.sleep(self.pause_seconds)
'''

        modifier_path = os.path.join(self.project_root, "pause_modifier.py")
        with open(modifier_path, 'w') as f:
            f.write(modifier_content)

        return modifier_path

    def run_robot_tests(self, test_suite, environment, headless=True, browser="chrome",
                        tags=None, variables=None, additional_args=None, pause_between_tests=0):
        """Run Robot Framework tests with specified parameters"""

        # Create output directories
        self.create_output_dirs()

        # Build robot command
        cmd = [self.robot_cmd]

        # Add output directory
        cmd.extend(["-d", self.output_dir])

        # Add log level
        cmd.extend(["-L", "DEBUG"])

        # Add timestamp to outputs
        cmd.append("--timestampoutputs")

        # Add console verbosity
        cmd.extend(["--console", "verbose"])

        # Add environment variable
        cmd.extend(["-v", f"ENV:{environment}"])

        # Add headless mode variable
        cmd.extend(["-v", f"HEADLESS:{headless}"])

        # Add browser variable
        cmd.extend(["-v", f"BROWSER:{browser}"])

        # Add pause modifier if requested
        if pause_between_tests > 0:
            modifier_path = self.create_pause_modifier(pause_between_tests)
            cmd.extend(["--listener", modifier_path])
            print(f"Adding {pause_between_tests} second pause between test cases")

        # Add tags if specified
        if tags:
            for tag in tags:
                cmd.extend(["-i", tag])

        # Add custom variables if specified
        if variables:
            for var_name, var_value in variables.items():
                cmd.extend(["-v", f"{var_name}:{var_value}"])

        # Add additional arguments if specified
        if additional_args:
            cmd.extend(additional_args)

        # Add test suite path
        if test_suite == "all":
            cmd.append("Tests/")
        else:
            cmd.append(f"Tests/{test_suite}.robot")

        print("=" * 80)
        print("Running Robot Framework Tests")
        print("=" * 80)
        print(f"Command: {' '.join(cmd)}")
        print(f"Test Suite: {test_suite}")
        print(f"Environment: {environment}")
        print(f"Headless Mode: {headless}")
        print(f"Browser: {browser}")
        if pause_between_tests > 0:
            print(f"Pause between tests: {pause_between_tests} seconds")
        print("=" * 80)

        # Run the command
        try:
            result = subprocess.run(cmd, cwd=self.project_root, check=False)

            # Clean up the temporary modifier file
            if pause_between_tests > 0:
                try:
                    os.remove(modifier_path)
                except:
                    pass

            return result.returncode
        except Exception as e:
            print(f"Error running tests: {e}")
            return 1

    def list_available_tests(self):
        """List all available test suites"""
        tests_dir = os.path.join(self.project_root, "Tests")
        if not os.path.exists(tests_dir):
            print("Tests directory not found!")
            return []

        test_files = [f for f in os.listdir(tests_dir) if f.endswith('.robot')]
        test_suites = [os.path.splitext(f)[0] for f in test_files]

        print("Available test suites:")
        print("-" * 40)
        for i, suite in enumerate(test_suites, 1):
            print(f"{i:2d}. {suite}")
        print(f"{len(test_suites) + 1:2d}. all (run all test suites)")

        return test_suites

def main():
    """Main function to parse arguments and run tests"""
    parser = argparse.ArgumentParser(description="Run Origin Robot Framework Tests")

    parser.add_argument(
        "--suite", "-s",
        choices=[
            "all",
            "Auto_Accept_Auto_Ship_Out",
            "Decommission",
            "Pack_And_Decommisson",
            "Pack_Unpack_Child",
            "Pack_Unpack_Parent"
        ],
        default="all",
        help="Test suite to run"
    )

    parser.add_argument(
        "--env", "-e",
        choices=["test", "stage"],
        default="test",
        help="Environment to run tests against"
    )

    parser.add_argument(
        "--browser", "-b",
        choices=["chrome", "firefox", "edge"],
        default="chrome",
        help="Browser to use for testing"
    )

    parser.add_argument(
        "--headless",
        action="store_true",
        default=True,
        help="Run browser in headless mode"
    )

    parser.add_argument(
        "--headed",
        action="store_true",
        help="Run browser in headed mode (opposite of headless)"
    )

    parser.add_argument(
        "--tags", "-t",
        nargs="*",
        help="Tags to include in test execution"
    )

    parser.add_argument(
        "--variables", "-v",
        nargs="*",
        help="Additional variables in format KEY:VALUE"
    )

    parser.add_argument(
        "--list", "-l",
        action="store_true",
        help="List available test suites"
    )

    parser.add_argument(
        "--pause", "-p",
        type=int,
        default=0,
        help="Pause in seconds between test cases (default: 0 - no pause)"
    )

    args = parser.parse_args()

    runner = TestRunner()

    # List available tests if requested
    if args.list:
        runner.list_available_tests()
        return

    # Handle headed/headless mode
    headless_mode = args.headless and not args.headed

    # Parse additional variables
    variables = {}
    if args.variables:
        for var in args.variables:
            if ":" in var:
                key, value = var.split(":", 1)
                variables[key] = value

    # Run tests
    exit_code = runner.run_robot_tests(
        test_suite=args.suite,
        environment=args.env,
        headless=headless_mode,
        browser=args.browser,
        tags=args.tags,
        variables=variables,
        pause_between_suites=args.pause
    )

    # Print results summary
    print("\n" + "=" * 80)
    if exit_code == 0:
        print("✓ All tests passed successfully!")
    else:
        print("✗ Some tests failed or encountered errors")

    print(f"Test results available in: {runner.output_dir}")
    print("=" * 80)

    sys.exit(exit_code)

if __name__ == "__main__":
    main()