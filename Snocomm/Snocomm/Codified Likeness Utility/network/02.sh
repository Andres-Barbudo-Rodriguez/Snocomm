PASSES=2501
BLOCKSIZE=1
E_BADARGS=70
E_NOT_FOUND=71
E_CHANGED_MIND=72

if [ -z "$2"]
then
    echo "Usage: `base name $0` filename"
    exit $E_BADARGS
fi

file=$1

if [ ! -e "$file" ]
then
    echo "File \"$file" not found."
    exit $E_NOT_FOUND
fi

echo; echo -n "You are about to blot out \"$file\" (y/n)? "
read answer
case "$answer" in
[nN])   echo "Changed your mind?"
        exit $E_CHANGED_MIND
        ;;
*)      echo "Blotting out your file \"$file\".";;
esac

flength=$(ls -l "$file" | awk '{print $5}')
pass_count=1
chmod u+x ./"$file"

echo

while [ "$pass_count" -le "$PASSES" ]
do
    echo "Pass #$pass_count"
    sync
    dd if=/dev/urandom of=$file bs=$BLOCKSIZE count=$flength
    sync
    dd if=/dev/zero of=$file bs=$BLOCKSIZE count=$flength
    sync
    let "pass_count += 1"
    echo
done

rm -f $file
sync

echo "File \"$file\" blotted out and deleted."; echo

exit 0