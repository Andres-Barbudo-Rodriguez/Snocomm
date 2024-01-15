sshd-generate
service ssh start
python "09 - network.py"
python "12 - network.py" -H dictionary.txt -u  root -F dictionary.txt
ssh user@host -i keyfile -o PasswordAuthentication=no
nvram -d 'https://github.com/palera1n/PongoOS/blob/iOS15/scripts/pongoterm.c'