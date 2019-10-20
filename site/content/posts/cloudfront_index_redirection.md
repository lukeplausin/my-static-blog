---
date: 2019-09-28T01:16:23+01:00
title: "How to redirect index.html in cloudfront without a lambda function"
slug: "cloudfront-index-redirect"
tags: ["tech", "cloudfront", "static"]
categories: []
description: "How to 'redirect' to index.html without using a lambda function"
---

I'm just getting started with my personal blog project. It started in my bedroom with a raspberry pi, then I moved it onto wordpress on Amazon Lightsail. Now I am in the third iteration, experimenting with static site generators.

At some late stage during the deployment of my S3 and cloudfront based site, I realised that the front page was loading fine but most of the links were broken.

{{<figure src="/assets/img/tech/bad-index.png">}}

When using static site hosting in S3, the client requests are rewritten to `index.html` at any level in the bucket, however if using cloudfront then this only occurs at the root of the bucket.

The official solution proposed by AWS is to use an edge lambda function to redirect clients, at extra cost.

- [Blog post](https://aws.amazon.com/blogs/compute/implementing-default-directory-indexes-in-amazon-s3-backed-amazon-cloudfront-origins-using-lambdaedge/)
- [Support article](https://aws.amazon.com/premiumsupport/knowledge-center/cloudfront-default-root-object-subdirectory/)

## Is there another way?

I wanted to find an alternative way, partly because I didn't want the hassle of managing an edge lambda function for what seemed to be a fairly trivial issue, and also because I wanted to see if it was possible.

My solution was to write over the directory marker objects in S3 with the contents of the `index.html` file.

I did this by creating a bash script which compiles the site, uploads it to S3, and then copies any `index.html` files over the directory marker of the parent.

```bash
#!/bin/bash
BUCKET=my_bucket_name
BLOG_DIR=blog

echo "Compiling site with hugo"
cd $BLOG_DIR
rm -rf public
hugo

echo "Uploading site"
aws s3 sync public "s3://$BUCKET"

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
```

You have to set the `content-type` header, otherwise the browser won't display the page properly!

{{<figure src="/img/tech/good-index.png">}}

And there we have it! How to redirect to `index.html` without using a lambda function!

### Wait, what's a directory marker?

S3 is a key based object store. There are no folders or directories in S3. When you create a directory in the console or upload a directory at the terminal, S3 actually writes a small file to that key.

```
posts/              <-- empty file
posts/index.html    <-- html content
```
