---
title: "Hello World!"
slug: "hello-world"
# thumbnail: "images/tn.png"
description: "Hello World!"
date: 2018-09-16T00:00:00+00:00
---

Hi, and welcome to the launch of my personal site.

{{<figure src="/img/hello-world/rocket_launch.gif" width="50%">}}

I’ve decided to create this site for a few different reasons:

As a fun technical project to occupy myself on Sundays.
Because recently I’ve been frustrated with Facebook and other social media sites, but would still like some way of sharing content with my friends.
To have my own little piece of cyberspace.
So, maybe you’re wondering how I created this site?

I’m going to elaborate on this a little bit, in case you were curious, or interested in creating one also.

## Luke’s Website: The making of

{{<figure src="/img/hello-world/rpi.gif" width="50%">}}

That’s right! My site is self hosted on my own hardware – a Raspberry Pi model 1. It’s just sitting in my living room, connected directly to the router via ethernet. I have the router set up to always give the raspberry pi the same IP address when the pi retrieves its IP via DHCP, and I have port forwarding set up so that the pi can service web requests from the public internet.

These features are available on most routers so you should be able to do this yourself. If anyone wants a look at how I set this up, I’ve scripted some of the setup. You can find it on my Github page here:

https://github.com/lukeplausin/raspberry-pi-scripts

My Raspberry Pi is running standard Raspbian (Debian), with a wordpress site served on PHP via Apache web server. There is an onboard MySQL database all running on the same hardware. I used letsencrypt for the SSL certificates and let the certbot do the SSL setup and configuration for me.

Since I take security seriously, SSL is required to view the site. I also have some security modifications enabled, such as fail2ban and the ModSecurity web application firewall.

Not bad for a 2011 model with 256 MB of RAM! Any techy people reading this blog will know that its not a high powered set up and can’t take that much load, but I don’t expect there will be that many visitors to the site. If it goes down due to overload or trollery then I’ll take a look at putting it into the cloud instead.

If you enjoyed reading this blog then let me know about it! Write a comment! And don’t be shy about asking questions!
