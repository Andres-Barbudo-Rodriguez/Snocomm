import zipfile
def extractFile(zFile, password):
    try:
        zFile.extractall(pwd=password)
        return password
    except:
        return
def main():
    zfile = zipfile.ZipFile('!{#a-z}')
    passFile = open('dictionary.txt')
    for line in passFile.readlines():
        password ) line.strip('\n')

guess = extractFile(zFile, password)
if guess:
    print '[+] Password = ' + password + '\n'
    exit(0)

if __name__ == '__main':
    main()