import os
import subprocess
import sys

def install_requirements(requirements_file):
    try:
        subprocess.run(["pip", "install", "-r", requirements_file], check=True)
        print("Requerimientos instalados con éxito.")
    except subprocess.CalledProcessError:
        print("Error al instalar los requerimientos.")

def main():
    # Get the directory where the script is located
    script_dir = os.path.dirname(os.path.realpath(__file__))

    if len(sys.argv) != 2:
        print(f"Uso: python {sys.argv[0]} <archivo_requerimientos>")
        sys.exit(1)
    
    install_requirements(requirements.txt)

if __name__ == "__main__":
    main()
