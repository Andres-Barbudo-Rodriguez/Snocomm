//
//  SSL-TLS Vunerabilities and Weak Ciphers Scan.c
//  Snocomm
//
//  Created by Andres Barbudo on 12/10/23.
//  Copyright © 2023 Snocomm. All rights reserved.
//

#include <stdlib.h>
#include <stdio.h>

int main(){
    system("nmap --script ssl-enum-ciphers,sslv2,sslv3,tlsv1 --script-args vulns.showall -p 443 /.https && /.http");
    return 0;
}
