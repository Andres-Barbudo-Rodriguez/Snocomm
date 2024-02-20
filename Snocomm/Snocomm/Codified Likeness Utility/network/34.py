#!/usr/bin/env python

import subprocess
import shlex

command_line = "ping -c 1 www.google.com"
args = shlex.split(command_line)
try:
    subprocess.check_call(args,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
    print("el servidor de Google esta ejecutandose en modo up")
except subprocess.CalledProcessError:
    print("Fallo al obtener el ping")
    