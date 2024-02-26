import os
import platform
import paramiko

# Function to clear the terminal screen
def clear_screen():
    if platform.system() == 'Windows':
        os.system('cls')
    else:
        os.system('clear')

# ANSI escape codes for colors
class colors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'

def execute_remote_command(host, username, password, command):
    try:
        # Connect to the remote host
        ssh_client = paramiko.SSHClient()
        ssh_client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        ssh_client.connect(hostname=host, username=username, password=password)

        # Execute the command
        stdin, stdout, stderr = ssh_client.exec_command(command)

        # Print output header
        print(colors.HEADER + "> Output from remote command:" + colors.ENDC)

        # Print stdout
        print(colors.OKBLUE + "Standard Output:" + colors.ENDC)
        print(colors.OKGREEN + stdout.read().decode() + colors.ENDC)

        # Print stderr
        print(colors.WARNING + "Standard Error:" + colors.ENDC)
        print(colors.FAIL + stderr.read().decode() + colors.ENDC)

        # Close the SSH connection
        ssh_client.close()

    except Exception as e:
        print(f"{colors.FAIL}Error: {e}{colors.ENDC}")

def execute_remote_script(host, username, password, local_script_path, remote_script_path):
    try:
        # Connect to the remote host
        ssh_client = paramiko.SSHClient()
        ssh_client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        ssh_client.connect(hostname=host, username=username, password=password)

        # Upload the local script to the remote server
        with open(local_script_path, 'rb') as local_file:
            # Create directory on the remote server if it doesn't exist
            ssh_client.exec_command(f'mkdir -p $(dirname {remote_script_path})')
            # Open an SFTP session to transfer files
            ftp_client = ssh_client.open_sftp()
            # Upload the local script to the remote server
            ftp_client.putfo(local_file, remote_script_path)
            # Close the SFTP session
            ftp_client.close()

        # Execute the script on the remote server
        stdin, stdout, stderr = ssh_client.exec_command(f'bash {remote_script_path}')

        # Print output header
        print(colors.OKGREEN + "Authentication succesfull!" + colors.ENDC)
        print(colors.OKGREEN + stdout.read().decode() + colors.ENDC)
        print(colors.HEADER + "> Output from remote script:" + colors.ENDC)

        # Print stdout
        print(colors.OKBLUE + "Standard Output:" + colors.ENDC)
        print(colors.OKGREEN + stdout.read().decode() + colors.ENDC)

        # Print stderr
        print(colors.WARNING + "Standard Error:" + colors.ENDC)
        print(colors.FAIL + stderr.read().decode() + colors.ENDC)

        # Close the SSH connection
        ssh_client.close()

    except Exception as e:
        print(f"{colors.FAIL}Error: {e}{colors.ENDC}")

# Clear the terminal screen
clear_screen()

# Take target IP, username, and password as input
host = input("Enter the target IP address: ")
username = input("Enter your username: ")
password = input("Enter your password: ")  # You may want to modify this to get password input securely

# Choose between executing a single command or running a remote script
choice = input("Choose an option:\n1. Execute a single shell command\n2. Execute a remote shell script\nEnter your choice (1 or 2): ")

clear_screen()
if choice == '1':
    command = input("Enter the shell command to execute remotely: ")
    execute_remote_command(host, username, password, command)
elif choice == '2':
    local_script_path = 'C:/Users/Jan/Documents/.Proyectos/asd.sh'  # Update with the path to your local script
    remote_script_path = '/srv/oneshot/salt-troubleshoot.sh'  # Update with the path where you want to upload the script on the remote server
    execute_remote_script(host, username, password, local_script_path, remote_script_path)
else:
    print("Invalid choice. Please choose either 1 or 2.")
