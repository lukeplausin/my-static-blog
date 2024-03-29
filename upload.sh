#!/bin/bash

BUCKET=luke.plaus.in
SITE_DIR=site

echo "Compiling site"
cd $SITE_DIR
rm -rf public
hugo

echo "Uploading site"
aws s3 sync public "s3://$BUCKET" --delete

echo "Reuploading index files to trunk"
cd public
regex="./(.*)/index.html"
find . | while read -r line; do
    if [[ $line =~ $regex ]]; then
        # aws s3 cp $line "s3://$BUCKET/${BASH_REMATCH[1]}"
        echo "Uploading from $line to s3://$BUCKET/${BASH_REMATCH[1]}/"
        aws s3api put-object --bucket "$BUCKET" --body $line --key "${BASH_REMATCH[1]}" --content-type text/html > /dev/null
        aws s3api put-object --bucket "$BUCKET" --body $line --key "${BASH_REMATCH[1]}/" --content-type text/html > /dev/null
    fi;
done
cd ../..
