---
title: "Faulty hard disk recovery"
slug: "faulty-hd-recovery"
# thumbnail: "images/tn.png"
description: "How I got all the data back from a broken hard disk"
date: 2018-09-16T00:00:00+00:00
tags: tech
comments: true
---

I managed to rescue all files from a hard disk with a SMART error. This is a blog about how you can learn from my mistakes.

# Background

When I came to visit my parents for Christmas this year, my mum told me that Zach – a family friend – had lost all his data because of a hard drive error. All of his pictures, videos, music, everything was unretrievable. Anyone who’s lost all of their personal data will know that it’s very upsetting. My parents have also lived the same experience, having lost all of our photos and memories when the family PC crashed about a decade ago.

“Catastrophic data loss” is bound to happen when you have no backup strategy in place. Even though your pictures don’t degrade on a digital medium, the underlying hardware can fail at any time. I always urge my family and friends to take regular backups of important data. Most people know that they should, but still they don’t. And often they realise their mistake when it’s already too late.

```
If you take regular backups then you won’t need my advice.

Mistake #1: I didn’t back up my data
```

Last resort – using Photorec
If you lose data due to drive corruption or a hardware failure, there may still be hope. When my parents’ computer crashed I managed to recover some data using a free tool called Photorec. This tool is designed to extract pictures, videos, documents and other file types from a hard disk where the filesystem is no longer functional. It works by reading the entire contents of the disk as a continuous data stream, and analyses the stream for patterns which might indicate the presence of a particular file type.

I ran the job 3 times (multiple passes are recommended) and it took about a week in total to scour the disk. Ultimately Photorec managed to scrape around 70,000 files from the disk, which were relabelled something like ‘f1753123442.jpg’ (as photorec doesn’t use the filesystem the original filenames and directory structure are lost). Most of the files were incomprehensible junk – things left over from browser sessions, pictures of buttons, cached internet ads, frames from my videos saved as stills, and many duplicates and many unreadable files. Using a duplicate image finder and manually scouring the collection I managed to salvage about 25 pictures. It was a really disappointing result, but at least it was something.

If you tried everything already and had no success, then maybe photorec will work for you. This time around, I was older and wiser and wanted to see if I can get a better result. Read on to find out how I managed a full recovery of Zach’s data.

```
Don’t go straight to Photorec – there might be better options.

Mistake #2: I used photorec first
```

# Step 1: Diagnosis

## Connecting the disk

The sick patient
All I got handed to me was this: a regular 3.5 inch hard disk. I had no idea what filesystem was on there, how it was partitioned or used. The label said that it was a 750GB WD brand disk.

These days I am a laptop user and I don’t have any access to a desktop. A couple of years ago I bought an ultra compact ‘net top’ PC for my parents to replace the chunky, ageing tower PC which they’d bought in the early 2000’s. The compact is super quiet and very efficient due to the cooling mechanism – it’s passively cooled by the aluminium case. I remembered that it has IDE power and SATA connections, so I opened up the case and connected the hard disk (always disconnect the power before doing this).

When I booted up the PC and had a look in the device viewer, I couldn’t see drive anywhere. Nor in the system BIOS. It turns out that the IDE power supply in the shiny compact was only rated for a 2.5 inch drive, and could not power the chunky larger type of disk. Doh!

```
Make sure that your machine can support the hard disk.

* Mistake #3: I plugged the hard disk into an under-rated power supply *
```

After asking around I managed to get hold of a tower which had enough power to spin up the disk. The tower had another disk inside with a windows installation on it.

Checking the SMART status
When I booted the PC a message like this appeared on the BIOS screen:

What a SMART error may look like on your BIOS screen
If the disk which failed is the one where your OS is installed then you will not be able to get past this step. Since I had another with windows attached to the machine I was able to skip past the BIOS warning and boot from the other hard disk onto a windows desktop. I managed to get more information about the error using CrystalDiskInfo, a disk analysis tool. CrystalDiskInfo is able to read all of the SMART flags off of the disk’s firmware, which can give more information about the nature of the error. You can download it from their webpage, or if you use a package manager such as chocolatey, then you can install it at the command line:

`choco install crystaldiskinfo.portable -y`

Reading a SMART report and interpreting the results will require some Google-fu. In my case, the SMART error was caused by #5 – the reallocated sector count flag was over the threshold. After reading around a bit I learned that this flag tracks the number of ‘bad sectors’ which have been remapped by the disk. The good news is that this type of error is an indicator of wear and not of total hardware failure. In fact the drive may have crashed because just one sector is missing.


What a SMART report looks like

*Checking the partitions*
The next step was to check for existing filesystems on the disk. Depending on your situation the disk management feature in Windows may be good enough for this. You can start the disk management feature by going to the control panel, opening up ‘computer management‘ and then clicking the ‘disk management‘ tab on the left hand side panel. If there are problems with the disk partitioning then you will probably see one of two things:


Scenario 1: Windows cannot understand the partition
Scenario 2: Windows cannot read the MBR/GPT

## Scenario 1: Windows cannot read the partition
If there is a partition at all then it means that you have a healthy MBR/GPT. However for whatever reason, windows cannot read the partition, and marks it as ‘RAW’. RAW simply means that windows does not understand the partition. The partition may actually be healthy but in a format which windows does not understand (such as AppleFS or ext3/ext4). It may be possible to recover the partition using a recovery tool, but if you have drive SMART errors then you should move your data onto a new disk and dispose of the current one. Do not format the volume if windows prompts you to so.

## Scenario 2: Windows cannot read the MBR/GPT
Windows will mark the drive as ‘Unknown‘, ‘Uninitialised‘, ‘Offline‘ or ‘Read Only‘, and no partitions will appear on the diagram, which is labeled ‘Unallocated‘. This is a good indicator that there is damage to the MBR (master boot record) or GPT (GUID partition table), as the case may be. This is the scenario which I faced.

Doctor’s Diagnosis
Soft SMART error
Damaged MBR
Partitions unknown

# Step 2: Triage

Having read about TestDisk previously, I thought this would be a good approach to take. TestDisk is a disk and partition recovery tool which is maintained by the same group who maintain PhotoRec. You can run it natively from windows, and use it to detect and repair partitions.

Analysis with TestDisk
I ran TestDisk in ‘Analyze’ mode, choosing ‘Intel’ as the partitioning type (I was fairly sure the disk wasn’t pulled from a Mac, and Intel is used by most Windows and Linux systems).



The analysis didn’t find any partitions in the partition map. On partition list screen you have the option of running a full scan of the disk to locate partitions. I tried this, but TestDisk came up with nothing, and errors flashed up on the screen ‘Read error at **/254/1‘ right from the very beginning. After 3 hours of analysis, TestDisk could not find any partitions on the disk, not a good sign. I had a feeling that the “Read error” warnings indicated some issue with the disk rather than the state of the data on it.


The **/254/1 part of the error message is a CHS address – a description of the low level physical address on the disk. I thought that an unreadable physical address backs my theory that the drive was unreadable. When I did a bit of digging on that error message, I came across a thread on Stack Overflow. The bottom line message was that TestDisk was the wrong tool for the job and that I should try ddrecover. This turned out to be good advice.

Never try to repair a file system on a drive with I/O errors; you will probably lose even more data. Instead try to salvage the data with ddrescue.

#4: I tried to use TestDisk on a disk with underlying hardware issues.
Using ddrecover/gddrecover to copy data off of a damaged disk
ddrescue (or gddrescue) is a GNU licensed utility to copy data from a disk which may be faulty or damaged. It works by scanning in a particular direction (forwards or backwards) and reading as much data off the disk as possible. If it encounters an error, then it will mark this on the run log and try to get the data in the opposite direction. You can run as many passes as needed, and save the output as an image file or as a new partition on another disk.

To run ddrescue you need to have a linux environment. I opted to use a ubuntu live USB. Live CDs (or USBs) are a way of running linux without installing it onto your machine. When you boot from a live medium, the OS is loaded from the medium into memory, but nothing is changed on the hard disk, giving you the option to try Linux before committing, or as in my case allowing you to just run some stuff without making permanent changes. When Ubuntu first boots, you will need to open up the terminal and run some bash commands to install ddrescue:

```bash
# Elevates permissions
sudo su
# Add the APT repository so that you have access to ddrecover (this is not added by default on live installations)
add-apt-repository universe
# Update the local mirror cache
apt update -y
# Install ddrescue and testdisk
apt-get install gddrescue testdisk -y
```

Initially I tried again to recover the partition with TestDisk, thinking that it might behave differently in Linux. Instead I just got the same error. And so onto ddrescue.

The goal is to use ddrescue is to copy as much data from the old damaged hard disk as possible onto a shiny new USB hard disk. Once the data is on the new disk, I can use standard recovery tools to extract what I can without fear of damaging the disk further and making recovery impossible. This is the command I issued:

`sudo ddrescue -d /dev/sdb /dev/sdc $HOME/ddrescue.log --force -R`

Important: In this case `/dev/sdb` was the old broken disk and `/dev/sdc` was the shiny new one. DO NOT mix these up or you will overwrite your data. They will be named differently in your system, so use a tool to find out which is which. The disk utility in Ubuntu does the job nicely.

The first time I ran ddrescue it seemed to just hang. The data rate dropped to zero, and nothing happened. Some more Google searches suggested that failed commands can clog up the drive’s command queue. I rebooted the live disk, repeated the setup steps and issued the command again, instead with the reverse option this time (‘-R’). This time it worked! The copy finished after several hours, the log seemed to show that most data was recovered, except just a few sectors towards the start of the disk.


ddrescue when it works
Do not try to mount the disk or use other tools before using ddrescue. If ddrescue fails the first time, then try rebooting the system and running again with the ‘R’ flag.

#5 I tried to mount the disk

# Step 3: Recovery
With the data stored on another volume, I tried using TestDisk again. The partition map was still broken so I tried a partition scan. Unlike the first few tries on the old disk, it found an NTFS partition almost immediately. Then it was just a case of rewriting the master boot record.


Once the MBR is written, I shut down and booted back to Windows. The filesystem was automatically mounted, and the files were visible and all there. A quick run of checkdisk fixed a few filesystem errors and verified that everything was in order. It seems that I managed to get everything back! All the pictures and photos, and not in such a messy format either. All in all a much better result than the first time around!

Anyway thats it for now. If this guide helped you, then please write something in the comments section! Or if you’re having trouble write something and maybe I can help. Good luck!
