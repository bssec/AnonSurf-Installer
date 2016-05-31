#!/bin/bash
dir=$(xdg-user-dir DESKTOP)

# Make sure only root can run this script
if [ $(id -u) -ne 0 ]; then
	echo -e "This script must be run as root." >&2
	exit 1
fi

# Remove previous installation
rm -rf /opt/anonsurf
mkdir /opt/anonsurf
rm -f /usr/share/applications/as-start.desktop
rm -f /usr/share/applications/as-stop.desktop
rm -f $dir/as-start.desktop
rm -f $dir/as-stop.desktop
rm -f /usr/bin/anonsurf


# Download anonsurf in /usr/bin
wget --https-only https://raw.githubusercontent.com/ParrotSec/anonsurf/master/anonsurf/anonsurf.sh -O /usr/bin/anonsurf
chmod +x /usr/bin/anonsurf

# Install tor
apt-get -y -qq install tor
apt-get -y -qq install gksu
apt-get -y -qq install dnsmasq
apt-get -y -qq install nscd


# Configure tor
f=/etc/tor/torrc
echo "VirtualAddrNetwork 10.192.0.0/10" >> $f
echo "AutomapHostsOnResolve 1" >> $f
echo "TransPort 9040" >> $f
echo "SocksPort 9050" >> $f
echo "DNSPort 53" >> $f
echo "RunAsDaemon 1" >> $f

service tor start
service dnsmasq start
service nscd start

# Create and make executable the shortcuts
wget http://bssec.altervista.org/images/as/anonstart.png -O /opt/anonsurf/anonstart.png
wget http://bssec.altervista.org/images/as/anonstop.png -O /opt/anonsurf/anonstop.png

f=/opt/anonsurf/as-start.desktop
echo [Desktop Entry] >> $f
echo Version=1.6 >> $f
echo Name=AnonStart >> $f
echo Exec=gksu anonsurf start >> $f
echo Icon=/opt/anonsurf/anonstart.png >> $f
echo Terminal=false >> $f
echo Type=Application >> $f
echo Name=AnonStart >> $f
chmod +x $f

f=/opt/anonsurf/as-stop.desktop
echo [Desktop Entry] >> $f
echo Version=1.6 >> $f
echo Name=AnonStop >> $f
echo Exec=gksu anonsurf stop >> $f
echo Icon=/opt/anonsurf/anonstop.png >> $f
echo Terminal=false >> $f
echo Type=Application >> $f
echo Name=AnonStop >> $f
chmod +x $f

service tor restart

# Put .desktop files in the applications directory
cp /opt/anonsurf/as-start.desktop /usr/share/applications
cp /opt/anonsurf/as-stop.desktop /usr/share/applications

# Put .desktop files on the Desktop
cp /opt/anonsurf/as-start.desktop $dir
cp /opt/anonsurf/as-stop.desktop $dir
