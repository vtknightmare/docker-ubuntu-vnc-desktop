FROM ubuntu:17.04
MAINTAINER Aras Memisyazici @vtknightmare

ENV DEBIAN_FRONTEND noninteractive

RUN sed -i 's#http://archive.ubuntu.com/#' /etc/apt/sources.list

# built-in packages
RUN apt-get update \
    && apt-get install -y --no-install-recommends software-properties-common curl \
    && apt-get update \
    && apt-get install -y --no-install-recommends --allow-unauthenticated \
        supervisor \
        openssh-server pwgen sudo vim \
        net-tools \
        lxde x11vnc xvfb \
        gtk2-engines-murrine ttf-ubuntu-font-family \
        libreoffice firefox \
        fonts-wqy-microhei \
        language-pack-zh-hant language-pack-gnome-zh-hant firefox-locale-zh-hant \
        nginx \
        python-pip python-dev build-essential \
        mesa-utils libgl1-mesa-dri \
        gnome-themes-standard gtk2-engines-pixbuf gtk2-engines-murrine pinta arc-theme \
        dbus-x11 x11-utils \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

# Install Arc Theme
#https://github.com/horst3180/arc-theme
RUN rm -rf /tmp/arc-theme \
    && sudo apt-get install build-essential autoconf automake pkg-config libgtk-3.0 libgtk-3-dev -y \
    && git clone https://github.com/horst3180/arc-theme --depth 1 /tmp/arc-theme \
    && cd /tmp/arc-theme \
    && sh autogen.sh --prefix=/usr \
    && sudo make install

RUN rm -rf /tmp/arc-theme
# to uninstall:
# sudo rm -rf /usr/share/themes/{Arc,Arc-Darker,Arc-Dark}


# Add Tini
ENV TINI_VERSION v0.16.1
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

ADD image /
RUN pip install setuptools wheel && pip install -r /usr/lib/web/requirements.txt

EXPOSE 80
WORKDIR /root
ENV HOME=/home/ubuntu \
    SHELL=/bin/bash
ENTRYPOINT ["/startup.sh"]
