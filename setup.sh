#!/bin/bash

install_requirements() {
    local requirements=(
        "paramiko"
        "base64"
        "traceback2"
        "keyboard"
        "platformdirs"
        "rich"
        "simple-term-menu"
        "Pillow"
        "ipaddress"
    )
cd /root/
python -m venv oneshot
source oneshot/bin/active
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
