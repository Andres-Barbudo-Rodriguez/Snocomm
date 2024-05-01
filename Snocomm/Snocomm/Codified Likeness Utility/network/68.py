from __future__ import print_function
import argparse
import os

__authors__ = ["Snocomm"]
__date__ = 20240501
__description__ = "este programa navega através de directorios en dispositivo magnetico y de estado solido"

parser = argparse.ArgumentParser(
    description=__description__,
    epilog="Desarrollado por {} en {}".format(
        ", ".join(__authors__), __date__
    )
)
parser.add_argument("DIR_PATH", help="ingrese la ruta al directorio a explorar")
args = parser.parse_args()
path_to_scan = args.DIR_PATH

# iteraciones sobre path_to_scan
for root, directories, files in os.walk(path_to_scan):
    # iteraciones obre los archivos en el directorio "root" actual
    for file_entry in files:
        # crear la ruta relativa al archivo
        file_path = os.path.join(root, file_entry)
        print(file_path)