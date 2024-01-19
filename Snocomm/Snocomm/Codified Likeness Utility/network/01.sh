openssl aes-128-ecb -salt -in boot.efi -out nfs.encrypted -pass pass:30302E32 2E3978
openssl aes-128-ecb -d -salt -in nfs-encrypted -out boot.efi -pass pass:30302E32 2E3978