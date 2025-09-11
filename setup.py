#!/usr/bin/env python3
"""
Setup script for Origin Robot Framework Test Automation
This script helps set up the environment for running tests locally or in CI/CD
"""

import os
import sys
import subprocess
import platform

def run_command(command, shell=False):
    """Run a command and return the result"""
    try:
        result = subprocess.run(command, shell=shell, check=True,
                              capture_output=True, text=True)
        print(f"✓ Command executed successfully: {' '.join(command) if isinstance(command, list) else command}")
        return result
    except subprocess.CalledProcessError as e:
        print(f"✗ Command failed: {' '.join(command) if isinstance(command, list) else command}")
        print(f"Error: {e.stderr}")
        return None

def create_virtual_environment():
    """Create Python virtual environment"""
    print("Creating Python virtual environment...")

    if platform.system() == "Windows":
        python_cmd = "python"
        venv_activate = os.path.join("venv", "Scripts", "activate.bat")
    else:
        python_cmd = "python3"
        venv_activate = os.path.join("venv", "bin", "activate")

    # Create virtual environment
    run_command([python_cmd, "-m", "venv", "venv"])

    return venv_activate

def install_dependencies(venv_activate):
    """Install required Python packages"""
    print("Installing Python dependencies...")

    if platform.system() == "Windows":
        pip_cmd = os.path.join("venv", "Scripts", "pip.exe")
    else:
        pip_cmd = os.path.join("venv", "bin", "pip")

    # Upgrade pip
    run_command([pip_cmd, "install", "--upgrade", "pip"])

    # Install requirements
    if os.path.exists("requirements.txt"):
        run_command([pip_cmd, "install", "-r", "requirements.txt"])
    else:
        # Install basic requirements
        packages = [
            "robotframework==6.1.1",
            "robotframework-seleniumlibrary==6.2.0",
            "selenium==4.15.2",
            "requests==2.31.0",
            "webdriver-manager==4.0.1",
            "Pillow==10.0.1",
            "python-dateutil==2.8.2"
        ]

        for package in packages:
            run_command([pip_cmd, "install", package])

def setup_browser_drivers():
    """Setup browser drivers using webdriver-manager"""
    print("Setting up browser drivers...")

    if platform.system() == "Windows":
        python_cmd = os.path.join("venv", "Scripts", "python.exe")
    else:
        python_cmd = os.path.join("venv", "bin", "python")

    setup_script = """
from webdriver_manager.chrome import ChromeDriverManager
from webdriver_manager.firefox import GeckoDriverManager
from webdriver_manager.microsoft import EdgeChromiumDriverManager

print("Installing ChromeDriver...")
chrome_path = ChromeDriverManager().install()
print(f"ChromeDriver installed at: {chrome_path}")

print("Installing GeckoDriver...")
firefox_path = GeckoDriverManager().install()
print(f"GeckoDriver installed at: {firefox_path}")

print("Installing EdgeDriver...")
edge_path = EdgeChromiumDriverManager().install()
print(f"EdgeDriver installed at: {edge_path}")

print("All browser drivers installed successfully!")
"""

    # Write and execute the setup script
    with open("temp_driver_setup.py", "w") as f:
        f.write(setup_script)

    result = run_command([python_cmd, "temp_driver_setup.py"])

    # Clean up temporary file
    if os.path.exists("temp_driver_setup.py"):
        os.remove("temp_driver_setup.py")

    return result is not None

def create_directories():
    """Create necessary directories"""
    print("Creating output directories...")

    directories = ["Output", "log", "Results"]

    for directory in directories:
        if not os.path.exists(directory):
            os.makedirs(directory)
            print(f"✓ Created directory: {directory}")
        else:
            print(f"✓ Directory already exists: {directory}")

def validate_setup():
    """Validate the setup by checking if Robot Framework is installed correctly"""
    print("Validating setup...")

    if platform.system() == "Windows":
        robot_cmd = os.path.join("venv", "Scripts", "robot.exe")
    else:
        robot_cmd = os.path.join("venv", "bin", "robot")

    # Check Robot Framework version
    result = run_command([robot_cmd, "--version"])

    if result:
        print("✓ Robot Framework setup validation successful!")
        return True
    else:
        print("✗ Robot Framework setup validation failed!")
        return False

def main():
    """Main setup function"""
    print("=" * 60)
    print("Origin Robot Framework Test Automation Setup")
    print("=" * 60)

    try:
        # Create virtual environment
        venv_activate = create_virtual_environment()

        # Install dependencies
        install_dependencies(venv_activate)

        # Setup browser drivers
        setup_browser_drivers()

        # Create directories
        create_directories()

        # Validate setup
        if validate_setup():
            print("\n" + "=" * 60)
            print("✓ Setup completed successfully!")
            print("=" * 60)
            print("\nTo run tests manually:")
            if platform.system() == "Windows":
                print("1. Activate virtual environment: venv\\Scripts\\activate.bat")
                print("2. Run tests: robot -d Output -v ENV:test Tests/")
            else:
                print("1. Activate virtual environment: source venv/bin/activate")
                print("2. Run tests: robot -d Output -v ENV:test Tests/")
            print("\nOr use Jenkins pipeline for automated execution.")
        else:
            print("\n" + "=" * 60)
            print("✗ Setup failed! Please check the errors above.")
            print("=" * 60)
            sys.exit(1)

    except Exception as e:
        print(f"\n✗ Setup failed with error: {str(e)}")
        sys.exit(1)

if __name__ == "__main__":
    main()