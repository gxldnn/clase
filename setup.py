import os
import subprocess

def create_virtual_environment(env_name):
    try:
        subprocess.run(["python", "-m", "venv", env_name], check=True)
        print(f"Entorno virtual '{env_name}' creado con éxito.")
    except subprocess.CalledProcessError:
        print(f"Error al crear el entorno virtual '{env_name}'.")

def install_requirements(env_name, requirements_file):
    try:
        subprocess.run([os.path.join(env_name, "bin", "pip"), "install", "-r", requirements_file], check=True)
        print("Requerimientos instalados con éxito.")
    except subprocess.CalledProcessError:
        print("Error al instalar los requerimientos.")

def execute_script(env_name, script_path):
    try:
        subprocess.run([os.path.join(env_name, "bin", "python"), script_path], check=True)
        print("Script ejecutado con éxito.")
    except subprocess.CalledProcessError:
        print("Error al ejecutar el script.")

def main():
    # Nombre del entorno virtual y archivo de requerimientos
    env_name = "oneshot"
    requirements_file = "requirements.txt"
    script_path = "/root/clase/oneshot.py"

    # Crear entorno virtual
    create_virtual_environment(env_name)

    # Instalar requerimientos
    install_requirements(env_name, requirements_file)

    # Ejecutar script
    execute_script(env_name, script_path)

if __name__ == "__main__":
    main()

