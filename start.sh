#!/bin/bash

vncserver :1 -geometry 1280x720 -depth 24

websockify --web=/usr/share/novnc/ 6080 localhost:5901 &

sleep 3

cd /root/android

wget -O android.iso "https://sourceforge.net/projects/android-x86/files/Release%209.0/android-x86_64-9.0-r2.iso/download"

qemu-system-x86_64 \
    -m 2048 \
    -smp 2 \
    -hda android.qcow2 \
    -cdrom android.iso \
    -boot d \
    -vnc :2

tail -f /dev/null
