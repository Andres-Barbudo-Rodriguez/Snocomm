from __future__ import print_function
import argparse

__authors__ = ["Snocomm"]
__date__ = 20240501
__description__ = 'argparse'

parser = argparse.ArgumentParser(
    description=__description__,
    epilog="Desarrollado por {} en {}".format (
        ", ".join(__authors__), __date__
    )
)

# argumentos posicionales

parser.add_argument("INPUT_FILE", help="ruta del archivo de entrada")
parser.add_argument("OUTPUT_FILE", help="ruta del archivo exportado")

# Argumentos Opcionales

parser.add_argument("--hash", help="Hash the files", action="store_true")
parser.add_argument("--hash-algorithm",
                    help="escriba el algoritmo que desea utilizar, ejemplos: md5, sha1, sha256",
                    choices=['md5', 'sha1', 'sha256'], default="sha256"
                    )

parser.add_argument("-v", "--version", "--script-version",
                    help="obtiene la informacion de version",
                    action="version", version=str(__date__)
                    )

parser.add_argument('-l', '--log', help="ruta para el archivo de reporte", required=True)

# convertir y utilizar argumentos
args = parser.parse_args()

input_file = args.INPUT_FILE
output_file = args.OUTPUT_FILE

if args.hash:
    ha = args.hash_algorithm
    print("hash de archivo activado con el algoritmo {}".format(ha))

if not args.log:
    print("el archivo de reporte no fue definido. Lo exportaré en stdout")

