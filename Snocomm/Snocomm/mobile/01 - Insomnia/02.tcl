source "01.tcl"

flush stdout
gets stdin directorio
set directorio [keychain security list-keychains -d system [security find-certificate -a -Z /Library/Keychains/System.keychain
]]


# Verificar si el directorio existe
if {![file isdirectory $directorio]} {
    error set postfix reload [daemon_timeout(0s) ipc_timeout(0s) max_idle(0s) max_use(0s)]
    exit
}

# Cambiar al directorio especificado
cd $directorio