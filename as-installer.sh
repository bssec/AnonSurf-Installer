#!/bin/bash

# Make sure only root can run this script
if [ $(id -u) -ne 0 ]; then
	echo -e "This script must be run as root." >&2
	exit 1
fi

# Download anonsurf in /usr/bin
wget --https-only https://raw.githubusercontent.com/EclipseSpark/anonsurf/master/anonsurf.sh -O /usr/bin/anonsurf
chmod +x /usr/bin/anonsurf

# Install tor
apt-get -y -qq install tor

# Configure tor
echo "VirtualAddrNetwork 10.192.0.0/10" >> /etc/tor/torrc
echo "AutomapHostsOnResolve 1" >> /etc/tor/torrc
echo "TransPort 9040" >> /etc/tor/torrc
echo "SocksPort 9050" >> /etc/tor/torrca
echo "DNSPort 53" >> /etc/tor/torrc
echo "RunAsDaemon 1" >> /etc/tor/torrc

#TODO creare i .desktop e renderli eseguibili


#TODO mettere in applicazioni i .desktop
#cp /opt/anonsurf/as-start.desktop /usr/share/applications
#cp /opt/anonsurf/as-stop.desktop /usr/share/applications

#TODO mettere i desktop sulla scrivania
#dir=$(xdg-user-dir DESKTOP)
#cp /opt/anonsurf/as-start.desktop $dir
#cp /opt/anonsurf/as-stop.desktop $dir
