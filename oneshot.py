#   ⸙  ────     ────     ───── ❝ corrupted tools ❞ ─────    ────     ────  ⸙
#
#        This scipt was created by Biel & Jan, by autists for autists :)
#
#               _________                                  _____     _________
#               __  ____/_______________________  ___________  /___________  /
#               _  /    _  __ \_  ___/_  ___/  / / /__  __ \  __/  _ \  __  / 
#               / /___  / /_/ /  /   _  /   / /_/ /__  /_/ / /_ /  __/ /_/ /  
#               \____/  \____//_/    /_/    \__,_/ _  .___/\__/ \___/\__,_/   
#                                                  /_/                        
#                          _____            ______                            
#                          __  /_______________  /_______                     
#                          _  __/  __ \  __ \_  /__  ___/                     
#                          / /_ / /_/ / /_/ /  / _(__  )                      
#                          \__/ \____/\____//_/  /____/   

import os
import sys
import paramiko
import time
import base64
import traceback
import subprocess
import keyboard
import platform
import socket
import ipaddress
import concurrent.futures
from rich.progress import Progress
from tabulate import tabulate
from simple_term_menu import TerminalMenu
from rich import print
from PIL import Image
##########       GLOBAL      ##########

localpath="/etc/local.sh"
remotepath="/etc/remote.sh"
saltmasterip = ""
nftablesipext = ""
nftablesiplan = ""
nftablesipdmz = ""
dhcpip = ""
vpnip = ""
caip = ""
webip = ""

##########        MISC       ##########
            
def imprimir_titulo(titulo):
    table = tabulate([[titulo]], tablefmt="rounded_outline")
    print(table)

def main_menu():
    imprimir_titulo("Corrupted Tools Menu")

    options = [
        "Desplegar Salt-Minion per la xarxa",
        "Prueba doble menu",
        "Sortir"
    ]

    menu = TerminalMenu(options, title="")
    menu.show()
    option = menu.chosen_menu_entry

    return option

def crear_menu(opciones):
    menu = TerminalMenu(opciones, title="")
    opcion = menu.show()
    return opciones[opcion]

def clear_terminal():
    os.system('cls' if os.name == 'nt' else 'clear')

def tarea(progress, tiempo):
    def tareatiempo(progress, tiempo):
        tiempo = tiempo*100
        for n in progress.track(range(tiempo), description=""):
            time.sleep(0.01)

    with Progress() as progress:
        tareatiempo(progress=progress, tiempo=tiempo)

##########      INPUTS       ##########

def localnetipgrab():
    ip_addresses = {}
    ip_info = [
        ("Salt Master IP", "green"),
        ("NFTABLES External IP", "blue"),
        ("NFTABLES LAN IP", "yellow"),
        ("NFTABLES DMZ IP", "red"),
        ("DHCP-DNS IP", "purple"),
        ("WebServer IP", "magenta"),
        ("VPN IP", "cyan"),
        ("CA IP", "cyan"),
    ]

    custom_variable_names = {
        "Salt Master IP": "saltmasterip",
        "NFTABLES External IP": "nftablesipext",
        "NFTABLES LAN IP": "nftablesiplan",
        "NFTABLES DMZ IP": "nftablesipdmz",
        "DHCP-DNS IP": "dhcpip",
        "WebServer IP": "webip",
        "VPN IP": "vpnip",
        "CA IP": "caip",
    }

    for prompt, color in ip_info:
        ip = input(f"Introduïu la ip de la maquina {prompt}: ")
        ip_addresses[prompt] = (ip, color)
        clear_terminal()
        imprimir_titulo("Corrupted Tools Menu (Salt)")

    for label, (ip, color) in ip_addresses.items():
        print(f"{label}: [bold {color}]{ip}[/bold {color}]")

    print()
    print("[bold] Són correctes aquestes IP's?[/bold]")
    
    # Assign all IP addresses to separate variables with custom names
    for prompt, (ip, _) in ip_addresses.items():
        custom_name = custom_variable_names.get(prompt)
        if custom_name:
            globals()[custom_name] = ip
    
    return ip_addresses



    
    ##########      IMAGING      ##########

def base64_show(base64_string, output_path):
    try:
        # Decode base64 string
        image_data = base64.b64decode(base64_string)

        # Write the decoded image data to a file
        with open(output_path, 'wb') as file:
            file.write(image_data)

        print("Image saved successfully at:", output_path)
    except Exception as e:
        print("Error saving image:", str(e))

##########      SSH EXE      ##########

def salt_content_update(masterip, saltid):
        script_content = f"""#!/bin/bash
        apt install curl -y
        curl -fsSL -o /etc/apt/keyrings/salt-archive-keyring-2023.gpg https://repo.saltproject.io/salt/py3/debian/12/amd64/SALT-PROJECT-GPG-PUBKEY-2023.gpg
        echo "deb [signed-by=/etc/apt/keyrings/salt-archive-keyring-2023.gpg arch=amd64] https://repo.saltproject.io/salt/py3/debian/12/amd64/latest bookworm main" | tee /etc/apt/sources.list.d/salt.list
        apt update
        apt install salt-minion -y
        echo -e "master: "{masterip}"" > /etc/salt/minion
        echo -e "id: "{saltid}"" >> /etc/salt/minion
        """
        file_path = localpath  # Cambiado a ".sh" al final

        # Abre el archivo en modo escritura "w"
        with open(file_path, 'w') as file:
            # Escribe el contenido del script en el archivo
            file.write(script_content)

        clear_terminal()

def ssh_execute_command(hostname, username, password, command):

    client = paramiko.SSHClient()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())

    try:
        client.connect(hostname, username=username, password=password)
        print("[bold green]Connexió SSH amb èxit.[/bold green]")

        stdin, stdout, stderr = client.exec_command(command)

        while not stdout.channel.exit_status_ready() and not stderr.channel.exit_status_ready():
            time.sleep(1)

        print("[bold green]Sortida de la comanda:[/bold green] ↓")
        print(stdout.read().decode())

        print("[bold red]Sortida d'error de la comanda:[/bold red]")
        print(stderr.read().decode())

    except Exception as e:
        print(f"Error: {e}")
        print("Traça de la excepció:", traceback.format_exc())

    finally:
        client.close()

def execute_remote_script(host, username, password, local_script_path, remote_script_path):
    try:
        ssh_client = paramiko.SSHClient()
        ssh_client.set_missing_host_key_policy(paramiko)

        ssh_client.connect(hostname=host, username=username, password=password)

        with open(local_script_path, 'rb') as local_file:
            ssh_client.exec_command(f'mkdir -p $(dirname {remote_script_path})')
            ftp_client = ssh_client.open_sftp()
            ftp_client.putfo(local_file, remote_script_path)
            ftp_client.close()

        stdin, stdout, stderr = ssh_client.exec_command(f'bash {remote_script_path}')
        print("Remote script executed successfully.")

    except Exception as e:
        print(f"Error executing remote script: {e}")
        print("Exception traceback:", traceback.format_exc())

    finally:
        ssh_client.close()
  
##########       EXTRA       ##########

def mostrar_imagen(ruta, width, height, x_pos, y_pos):
    def get_image_viewer():
        system = platform.system()
        if system == 'Linux':
            # Check if the image viewer 'eog' is available
            result = subprocess.run(['which', 'eog'], capture_output=True, text=True)
            if result.returncode == 0:
                return 'eog'
            else:
                return None  # Return None if eog is not found

    try:
         imagen = Image.open(ruta)
         imagen = imagen.resize((width, height))
         imagen.show()
 
         image_viewer = get_image_viewer()
 
         if image_viewer == 'eog':
             # If using eog, we can't directly position the window via command line
             print("eog does not support window positioning via command line.")
             print("You may need to manually position the window.")
 
         else:
             # If feh is being used, move the window using wmctrl
             move_cmd = ["wmctrl", "-r", "feh", "-e", f"0,{x_pos},{y_pos},-1,-1"]
             subprocess.run(move_cmd, check=True)   
    except Exception as e:       
        print(f"Error al abrir la imagen: {e}")

        
def goback_return():
    input("Prem Enter per a tornar al inici")
    p = subprocess.Popen("python oneshot.py", shell=True)
    time.sleep(5)
    keyboard.send('ctrl+c')
    p.communicate()

#######################################
        
if __name__ == "__main__":
    clear_terminal()
    tarea(Progress(), 1)
    clear_terminal()
    while True:
        choice = main_menu()

        if choice == "Desplegar Salt-Minion per la xarxa":
            if __name__ == "__main__":
                tarea(Progress(),1)
                clear_terminal()
                imprimir_titulo("Corrupted Tools Menu (Salt)")
                ip_addresses = localnetipgrab()
                ips_be = crear_menu(["Si", "No"])
                if ips_be == "Si":
                    print()
                elif ips_be == "No":
                    clear_terminal()
                    break

                ##########################################
                ###########CAPTURACION DE MACS############
                ##########################################
                username = "root"
                password = "alumnat"

                hostname = f"{saltmasterip}"
                saltmastermac = ssh_execute_command(hostname, username, password, "ip link show enp0s3 | awk '/link\/ether/ {print $2}'")

                hostname = f"{vpnip}"
                vpnmac = ssh_execute_command(hostname, username, password, "ip link show enp0s3 | awk '/link\/ether/ {print $2}'")

                hostname = f"{caip}"
                camac = ssh_execute_command(hostname, username, password, "ip link show enp0s3 | awk '/link\/ether/ {print $2}'")

                hostname = f"{webip}"
                dmzmac = ssh_execute_command(hostname, username, password, "ip link show enp0s3 | awk '/link\/ether/ {print $2}'")

                hostname = f"{dhcpip}"
                dhcpmac = ssh_execute_command(hostname, username, password, "ip link show enp0s3 | awk '/link\/ether/ {print $2}'")
                ##########################################
                ##########################################
                ##########################################

                #######################ABEL EN BASE 64#######################

                ##############################################################################################################################################################
                clear_terminal()
                hostname = f"{nftablesiplan}"
                saltid = "NfTables"
                salt_content_update(saltmasterip, saltid)
                execute_remote_script(hostname, username, password, "/etc/salt-minion.sh" , "/tmp/salt.minion.sh" )


                clear_terminal()
                hostname = f"{dhcpip}"
                saltid = "DHCP"
                salt_content_update(saltmasterip, saltid)
                execute_remote_script(hostname, username, password, "/etc/salt-minion.sh" , "/tmp/salt.minion.sh" )


                clear_terminal()
                hostname = f"{vpnip}"
                saltid = "VPN"
                salt_content_update(saltmasterip, saltid)
                execute_remote_script(hostname, username, password, "/etc/salt-minion.sh" , "/tmp/salt.minion.sh" )

                clear_terminal()
                hostname = f"{caip}"
                saltid = "CA"
                salt_content_update(saltmasterip, saltid)
                execute_remote_script(hostname, username, password, "/etc/salt-minion.sh" , "/tmp/salt.minion.sh" )

                clear_terminal()
                hostname = f"{webip}"
                saltid = "WebServer"
                salt_content_update(saltmasterip, saltid)
                execute_remote_script(hostname, username, password, f"{localpath}" , f"{remotepath}" )

                
                goback_return()
        elif choice == "Prueba doble menu":
            if __name__ == "__main__":
                tarea(Progress(), 1)
                clear_terminal()
                imprimir_titulo("Corrupted Tools Menu (Salt)")
                if __name__ == "__main__":
                    listaprueba = [
                        "caca",
                        "pipi"
                    ]
                    if listaprueba:
                        seleccion = crear_menu(listaprueba)
                        print(f"Ha seleccionado: {seleccion}")
                        goback_return()

        elif choice == "Sortir":
                abel64 = """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"""
                bernat64 = """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"""
                base64_image = f"{abel64}"
                output_file_path = "/tmp/abel.jpg" 
                base64_show(base64_image, output_file_path)
                ruta_imagen = "/tmp/abel.jpg"
                mostrar_imagen(ruta_imagen, 400, 400, 0, 0)
                base64_image = f"{bernat64}"
                output_file_path = "/tmp/bernat.jpg"
                base64_show(base64_image, output_file_path)
                ruta_imagen = "/tmp/bernat.jpg"
                mostrar_imagen(ruta_imagen, 400, 400, 350, 340)
                clear_terminal()      
                print("[bold red]◄ Heu sortit de l'script 🖕🏻 ►[/bold red]")
                break

        else:
            clear_terminal()
            break
