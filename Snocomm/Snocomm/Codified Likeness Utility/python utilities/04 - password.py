import zipfile
zFile = zipfile.ZipFile("!/{#a-z}.zip")
try:
    zFile.extractall(pwd="kim dot com - nokierr")
except Exception, e:
    print e