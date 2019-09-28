---
title: "CORS test"
slug: "cors-test"
# thumbnail: "images/tn.png"
description: "Testing CORS with Amazon S3"
date: 2018-09-25T00:00:00+00:00
---
# The CORS test

I have a lot of photographs and saved in the cloud which I would like to share with the internet! The problem is that I want to do it on the cheap. At the moment all my travel pics and so on are stored in a few different places. I have a NAS drive at home and some stuff stored on Amazon's S3 service. I used to use Google Drive, but now I've moved everything off of there and onto S3.

{{<figure src="https://s3-eu-west-1.amazonaws.com/luke.plaus.in/img/the-cloud.jpg" width="50%">}}

## Google Drive
It was the most convenient service to use when I was on the move in 2014. Unfortunately there aren’t easy options for sharing. I can share all of my pictures one by one, but the total space is limited to 100GB (I won’t pay for a Terabyte!) and I have to share them one by one.

## Amazon S3
This is a fantastic storage service offered by Amazon, you can store unlimited amounts of data in a bucket manage sharing permissions centrally using a bucket policy, and I can even host them directly out of S3 using the web hosting feature.
The image above is shared directly from my AWS account over a secure SSL connection using S3. By offloading the static assets of my website to S3 I am reducing the amount of traffic (and therefore the load) that my Raspberry Pi has to service!

To stop other people from linking to my S3 images (I would have to pay for the traffic) I used a CORS configuration in my S3 bucket to allow only my own WordPress site.

(I will install the code snippet WP plugin when I have time!)

```xml
<CORSConfiguration>
 <CORSRule>
 <AllowedOrigin>https://wp.luke.plaus.in</AllowedOrigin>
 <AllowedMethod>GET</AllowedMethod>
 <AllowedHeader>*</AllowedHeader>
 </CORSRule>
</CORSConfiguration>
```