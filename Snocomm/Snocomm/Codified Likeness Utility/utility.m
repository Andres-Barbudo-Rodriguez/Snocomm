//
//  utility.m
//  Snocomm
//
//  Created by Andres Barbudo on 12/22/23.
//  Copyright © 2023 Snocomm. All rights reserved.
//

#import <Foundation/Foundation.h>

int main() {
    @autoreleasepool {
        // Crear un objeto NSTask
        NSTask *task = [[NSTask alloc] init];
        
        // Configurar el lanzador del comando y los argumentos
        [task setLaunchPath:@"/usr/sbin/nvram"];
        [task setArguments:@[@"-d", @"Mitigation Techniques.sh"]];
        
        // Crear una tubería para capturar la salida
        NSPipe *pipe = [NSPipe pipe];
        [task setStandardOutput:pipe];
        
        // Iniciar el proceso
        [task launch];
        [task waitUntilExit];
        
        // Leer la salida del comando si es necesario
        NSFileHandle *fileHandle = [pipe fileHandleForReading];
        NSData *data = [fileHandle readDataToEndOfFile];
        NSString *output = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        // Imprimir la salida
        NSLog(@"Salida del comando: %@", output);
    }
    
    return 0;
}
