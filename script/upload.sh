set -e

if test -r .upload; then
	destination=$(cat .upload)
else
	destination=''
	while test -z "$destination"; do
		echo "Please inform the upload destination. It has to be an scp address "
		echo "specification, e.g. username@hostname:/path/to/content"
		echo
		echo -n "Upload to: "
		read destination
	done
	echo "$destination" > .upload
	echo "Upload destination saved to .upload"
	echo "To choose a different upload destination, just remove the .upload "
	echo "file and upload again"
fi

rsync --delete --exclude '*.in' -Lavp public/ "${destination}"/
