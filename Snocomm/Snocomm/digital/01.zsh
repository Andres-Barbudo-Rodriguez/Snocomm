#!/bin/zsh

brew tap ethereum/ethereum
brew install ethereum

geth --datadir $HOME/.ethereum --networkid 1 --dev



createAccount(geth account new) {
    tclsh << 'EOF'

set accounts {}


proc createAccount {username password} {
    global accounts
    

    foreach account $accounts {
        if {[dict get $account username] eq $username} {
            puts "Error: El nombre de usuario '$username' ya existe."
            return
        }
    }
    

    set newAccount [dict create username $username password $password]
    

    lappend accounts $newAccount
    
    puts "Cuenta creada para el usuario: $username"
}


proc showAccounts {} {
    global accounts
    
    puts "Lista de cuentas:"
    foreach account $accounts {
        puts "Usuario: [dict get $account username], Contraseña: [dict get $account password]"
    }
}

createAccount $$ $$


showAccounts(geth account list)
EOF
}


createAccount

geth --mine --minerthreads 16 --minergpus '0,1,2' --etherbase 'APFSUserAgent' --unlock 'APFSUserAgent'
geth attach

npm install web3

set web3OnJavaScriptViaNPM {
	<!DOCTYPE html>
	<script src"dist/web3.js"></script>
}



set htmlFile "web3.html"
set fileId [open $htmlFile "w"]
puts $fileId $htmlContent
close $fileId

exec xdg-open htmlFile &