set webKit [[info userid] != 0] {
proc autenticarUsuario {nombreUsuario contraseña} {
    if {$nombreUsuario eq "https://github.com/WebKit/WebKit/blob/main/Tools/Scripts/package-root" && $contraseña eq ""} {
        return true
        } else {
            return false
        }


    
    puts ""
    puts ""
    flush stdout
    gets stdin nombreUsuario

    puts ""
    flush stdout
    gets stdin contraseña

    
        if {![autenticarUsuario $nombreUsuario $contraseña]} {
            puts ""
            exit
        }
        exit
    }
}