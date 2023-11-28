#!/bin/sh

#  Certificate.sh
#  Snocomm
#
#  Created by Andres Barbudo Rodriguez on 11/28/23.
#  Copyright © 2023 Snocomm. All rights reserved.


openssl req -x509 -newkey rsa:4096 -keyout server-key.pem -out server-cert.pem - days 365 -nodes
