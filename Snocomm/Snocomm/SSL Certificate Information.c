//
//  SSL Certificate Information.c
//  Snocomm
//
//  Created by Andres Barbudo on 12/10/23.
//  Copyright © 2023 Snocomm. All rights reserved.
//

#include <stdlib.h>
#include <stdio.h>

int main(){
    system("nmap --script ssl-cert -p 443 /.https && /.http");
    return 0;
}
