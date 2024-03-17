import os
import subprocess
import time

LOGFILE = os.path.join(os.getcwd(), 'setup', 'log.log')
ERRFILE = os.path.join(os.getcwd(), 'setup', 'err.log')
RED = "\033[31m"
GREEN = "\033[32m"
YELLOW = "\033[33m"
BLUE = "\033[34m"
MAGENTA = "\033[35m"
CYAN = "\033[36m"
GREY = "\033[37m"
RESET = "\033[0m"

TICK = u"\u2713"
CROSS = u"\u2718"

STDCOLOR = "\033[96m"
ERRCOLOR = "\033[91m"

def install_requirements():
    requirements = [
        "paramiko",
        "tabulate",
        "traceback2",
        "keyboard",
        "platformdirs",
        "rich",
        "simple-term-menu",
        "Pillow",
        "ipaddress",
    ]
    for pkg in requirements:
        result = subprocess.run(['pip', 'install', pkg], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        if result.returncode == 0:
            print(f"Paquet '{pkg}' instal·lat correctament.")
        else:
            print(f"Error al instalar paquet '{pkg}'.")
            exit(1)

def dot_check(process_id, message):
    print(message, end='', flush=True)
    dots = 0

    while process_id.poll() is None:
        if dots >= 4:
            print("\b\b\b\b\b         \b\b\b\b\b\b\b\b\b\b\b\b", end='', flush=True)
            dots = 0
        print(".", end='', flush=True)
        dots += 1
        time.sleep(0.5)

    if process_id.returncode == 0:
        print(f"\r{message:<35s}[ {GREEN}{TICK}{RESET} ] done.")
    else:
        print(f"\r{message:<35s}[ {RED}{CROSS}{RESET} ]")
        print(f"Check the error at: {ERRFILE}\n")
        exit()

def main():
    result = subprocess.run(['pip', '--version'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    if result.returncode != 0:
        print("Error: pip no está instal·lat")
        exit(1)

    install_requirements()
    clear()

def clear():
    os.system('clear')

def execute_command(command, message):
    process = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    dot_check(process, message)

def create_virtualenv():
    execute_command(['apt', 'install', '-y', 'python3'], "Intstalant python")
    execute_command(['apt', 'install', '-y', 'python3-pip'], "Intstalant pip")
    execute_command(['apt', 'install', '-y', 'python3-venv'], "Intstalant venv")
    execute_command(['python3', '-m', 'venv', '/root/oneshot'], "Creant entorn virtualitzat")

def run():
    os.makedirs(os.path.join(os.getcwd(), 'setup'), exist_ok=True)
    with open(LOGFILE, 'w') as log_file, open(ERRFILE, 'w') as err_file:
        create_virtualenv()
        activate_virtualenv()
        main()
        input("El Setup ha fet correctament la seva funció, si us plau executi oneshot.py [Enter]: ")

def activate_virtualenv():
    activate_script = os.path.join('root', 'oneshot', 'bin', 'activate')
    if os.path.exists(activate_script):
        activate_cmd = f"source {activate_script}"
        proc = subprocess.Popen(activate_cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
        stdout, stderr = proc.communicate()
        if proc.returncode == 0:
            env_vars = dict(line.split("=", 1) for line in stdout.decode().splitlines())
            os.environ.update(env_vars)
            print("Virtual environment activated successfully.")
        else:
            print("Error activating virtual environment.")
    else:
        print("Virtual environment activation script not found.")

if __name__ == "__main__":
    run()
