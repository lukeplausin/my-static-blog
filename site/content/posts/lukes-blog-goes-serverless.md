---
title: Luke's blog goes serverless!
description: 'My experiments with Hugo, Netlify and static site websites'
slug: blog-goes-serverless
date: 2019-10-14T00:06:47.504Z
thumbnail: /assets/img/me-lol.jpg
---
Ever since I first started learning about serverless computing I have been excited about the possibilities that it might bring. High performance, low maintenance sites powered by static CDNs are one such promise, however that promise is yet to be realised in the case of most users. Practically anyone who runs a site is still using some kind of CMS, probably based on one the usual suspects, Wordpress, drupal etc.

## Content Generation with Hugo

Recently I've been experimenting with [Hugo](https://gohugo.io/), an engine for generating static websites. I first came across Hugo when I was tasked with setting up an internal help site for my client. I thought that I was going to need to put my web developer hat on for a few weeks, but a colleague pointed out this software to me. It's an absolutely fantastic way of generating complex, professional looking static sites with only rudimentary knowledge of web development. However you still need to set up the site yourself, as well as use the command line and author markdown files.

I've spent a couple of weeks experimenting with different themes, and working out what I need to do in order to reproduce my wordpress blog in Hugo. There seems to be a lot of inconsistency between the way the different themes work, however I did eventually find one which works well for me. [I am using the Ezhil theme](https://github.com/vividvilla/ezhil).
