#!/bin/bash
apt install -y pip
apt install -y python3
apt install -y python3-venv
install_requirements() {
    local requirements=(
        "paramiko"
        "tabulate"
        "traceback2"
        "keyboard"
        "platformdirs"
        "rich"
        "simple-term-menu"
        "Pillow"
        "ipaddress"
    )
    for pkg in "${requirements[@]}"; do
        if pip install "$pkg"; then
            echo "Paquete '$pkg' instalado con éxito."
        else
            echo "Error al instalar el paquete '$pkg'."
            exit 1
        fi
    done
}

main() {
    if ! command -v pip >/dev/null; then
        echo "Error: pip no está instalado. Asegúrate de tener Python y pip instalados."
        exit 1
    fi

    install_requirements
}

main

python3 -m venv /root/oneshot
source oneshot/bin/activate
read -p "Presionar [Enter] per a executar oneshot.py"
python3 $(pwd)/oneshot.py
