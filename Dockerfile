FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    wget \
    qemu-system-x86 \
    qemu-utils \
    xfce4 \
    tightvncserver \
    novnc \
    websockify \
    supervisor \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /root

RUN mkdir -p /root/.vnc && \
    echo "android" | vncpasswd -f > /root/.vnc/passwd && \
    chmod 600 /root/.vnc/passwd && \
    echo '#!/bin/bash' > /root/.vnc/xstartup && \
    echo 'startxfce4 &' >> /root/.vnc/xstartup && \
    chmod +x /root/.vnc/xstartup

RUN mkdir /root/android && \
    cd /root/android && \
    qemu-img create -f qcow2 android.qcow2 10G

COPY start.sh /root/start.sh
RUN chmod +x /root/start.sh

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 6080

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
