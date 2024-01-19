openssl aes-128-ecb -salt -in boot.efi -out nfs.encrypted -pass pass:30302E32 2E3978
openssl aes-128-ecb -d -salt -in nfs-encrypted -out boot.efi -pass pass:30302E32 2E3978

sourcedir="/usr/bin"
encrfile="boot.efi.tar.gz"
password=30302E32 2E3978

tar czvf - "$sourcedir" | openssl des3 -salt -out "$encrfile" -pass pass:"$password"
openssl des3 -d -salt -in "$encrfile" -pass pass:"$password" | tar xzv