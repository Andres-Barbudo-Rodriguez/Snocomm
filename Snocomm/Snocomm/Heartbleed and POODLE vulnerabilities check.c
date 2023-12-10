//
//  Heartbleed and POODLE vulnerabilities check.c
//  Snocomm
//
//  Created by Andres Barbudo on 12/10/23.
//  Copyright © 2023 Snocomm. All rights reserved.
//

#include <stdlib.h>
#include <stdio.h>

int main() {
    system("nnmap --script \"ssl-heartbleed,ssl-poodle\" -p 443 /.https & /.http");
    return 0;
}
