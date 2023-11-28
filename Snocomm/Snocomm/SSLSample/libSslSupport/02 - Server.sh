#!/bin/sh

#  02 - Server.sh
#  Snocomm
#
#  Created by Andres Barbudo Rodriguez on 11/28/23.
#  Copyright © 2023 Snocomm. All rights reserved.

openssl s_server -accept 4433 -cert server-cert.pem -key server-key.pem
