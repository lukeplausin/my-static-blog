---
title: "Moving from Raspberry pi to lightsail"
slug: "rpi-to-lightsail"
# thumbnail: "images/tn.png"
description: "My own cloud migration! Moving from RaspberryPi to Lightsail"
date: 2018-12-23T00:00:00+00:00
tags: tech
comments: true
---

Last month I was lucky enough to move house. In the rush to pack everything into boxes and hire a moving company this blog was one of the last things on my mind. And so, unfortunately my Raspberry Pi has stayed in the cupboard for the best part of a month, and because of this my blog has been offline for about as long. I didn’t really think about it until I met my friend Frosty and he mentioned my post about the band. Someone actually read my blog! Who would have thought? And then I remembered the Pi sitting in my drawer, my blog dead…

As an IT professional, I owe it to myself to have a working personal site. So I’ve decided to take my own advice upgrade to the cloud!

When Amazon launched their Lightsail service about a couple of years ago, I didn’t take much notice of it. It’s not really aimed at the enterprise customers who I normally deal with, and you can normally get the same functionality out of marketplace AMIs with EC2. However, for my own project, the pricing is rather good. AWS offer you a basic VPS (virtual private server) with 20Gb of SSD storage for as little as $3.50 per month. This is about half the price of standard EC2 – the simple monthly calculator comes to $6.44 / mo when using a t3.nano with 20Gb of GP2 storage (I no longer qualify for free tier).

Setting up was fairly easy. When you log into the AWS console and find the lightsail service, you get redirected to a much simplified console. AWS are clearly targeting Lightsail towards hobbyists, novices and people who don’t want to know the inner workings of EC2.

IP addresses and DNS

Rather than pay extra for a static IP address I chose to continue using DuckDNS in the same way as on my Raspberry Pi. I would run a script on the instance every hour, which would update the DuckDNS record, to which the DNS name of my blog is mapped with a CNAME record. This code snippet shows how you can set up your server to update dynamic DNS records with DuckDNS and cron.

# Setup duck DNS (as root)
DUCK_DOMAIN=( Your DuckDNS.org domain, without .duckdns.org )
DUCK_TOKEN=( Your DuckDNS.org token )
mkdir /var/log/duckdns/
echo '#!/bin/bash' > /usr/local/bin/duckdns
echo "echo url=\"https://www.duckdns.org/update?domains=$DUCK_DOMAIN&token=$DUCK_TOKEN&ip=\" | curl -s -k -o /var/log/duckdns/duck.log -K -" >> /usr/local/bin/duckdns
chmod 755 /usr/local/bin/duckdns
crontab -l > mycron
echo "0 0 * * * /usr/local/bin/duckdns >/dev/null 2>&1" >> mycron
crontab mycron
rm mycron
WordPress Migration
Migrating the data from my old site was fairly easy. I used a plugin called UpdraftPlus to take backups of my old site, all I had to do was import the backups and restore the site. All my plugins, posts, images, everything was transported over.

One of the things which used to annoy me when running WordPress on my Raspberry Pi was that it didn’t have enough RAM to run all the plugins I wanted to (if I went over the limit, MySQL would fail rather gracelessly bringing the site down). This isn’t a problem now as I have 500 Mb to use on my VPS.

Making it homely
One of the things I really liked about my PI was the personalised splash screen when I log in. I set this up using the MOTD module as well as some custom scripts and packages. Since Lightsail wordpress runs on Ubuntu, this was very easy to replicate.


I use a module called neofetch to display some basic system stats when I log in, a module called TOILET to print my name in big shiny letters, and the GNU fortune module so that any shell session starts out with a bit of silliness.

# Setup MOTD
apt-get install fortune cowsay toilet -y

add-apt-repository ppa:dawidd0811/neofetch && apt-get update -y && apt-get install neofetch

cat <<EOF > config/update-motd.d/10-hello
#! /bin/bash

toilet --metal -f pagga "PLAUSIN"
neofetch
/usr/games/fortune

EOF
chmod 755 /etc/update-motd.d/*
echo "" > /etc/motd
rm /etc/update-motd.d/10-uname
So that about wraps it up! Now that my blog is (hopefully) more up than down, hopefully you can expect a few more posts from me.
