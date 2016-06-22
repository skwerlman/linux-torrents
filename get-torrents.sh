#!/usr/bin/env bash

# linux-torrent.sh
# Inspired by this script:
#  https://github.com/ppaskowsky/Bash/blob/master/auto-linux-downloader.sh
# Copyright (C) 2015 by skwerlman
# 

#============================== CONFIGURATION ===============================#

# torrent_location:
#   where to save the downloaded .torrent files
#   you should configure your torrent client to 'watch' this directory
#   if you want it to download the ISOs automatically
torrent_location='/media/torrent-files'

# cleanup_old:
#   whether to delete old .torrent files or not
#   use caution, since this does not care where the old .torrents are from
cleanup_old=false

# allow_output:
#   whether to allow echoing of status messages
allow_output=true

#============================================================================#



mkdir -p "$torrent_location/"

echo2 () {
	if [ $allow_output = true ] ; then
		echo $1
	fi
}

count () {
	numfiles=($torrent_location/*)
	numfiles=${#numfiles[@]}
	echo2 "$numfiles"
}

starting_filenum=`count`
start_time="$SECONDS"

if [ $cleanup_old = true ] ; then
	rm -r $torrent_location/*
fi

# friendly names for distros
archnetinstdual='Arch'
centos='CentOS'
debiancdamd64='Debian (1/4)'
debiancdi386='Debian (2/4)'
debiandvdamd64='Debian (3/4)'
debiandvdi386='Debian (4/4)'
edubuntu='Edubuntu'
fedoraserver='Fedora (1/2)'
fedoraworkstation='Fedora (2/2)'
kali='Kali'
kubuntu='Kubuntu'
lubuntu='Lubuntu'
mageia='Mageia'
mythbuntu='Mythbuntu'
netbsd='NetBSD'
opensuse='OpenSUSE'
raspbian='Raspberry Pi'
sabayon='Sabayon'
slackware='Slackware'
spikepentesting='Spike Pentesting'
stephensonsrocket="Stephenson's Rocket"
tails='TAILS'
ubuntu='Ubuntu'
ubuntugnome='Ubuntu GNOME'
ubuntukylin='Ubuntu Kylin'
ubuntumate='Ubuntu MATE'
ubuntustudio='Ubuntu Studio'
xubuntu='Xubuntu'

# urls of folders containing .torrent files
archnetinstdual_url='ftp://mirror.rackspace.com/archlinux/iso/'
centos_url='ftp://mirror.rackspace.com/CentOS/'
debiancdamd64_url='ftp://cdimage.debian.org/cdimage/release/current/amd64/bt-cd/'
debiancdi386_url='ftp://cdimage.debian.org/cdimage/release/current/i386/bt-cd/'
debiandvdamd64_url='ftp://cdimage.debian.org/cdimage/release/current/amd64/bt-dvd/'
debiandvdi386_url='ftp://cdimage.debian.org/cdimage/release/current/i386/bt-dvd/'
edubuntu_url='ftp://cdimage.ubuntu.com/cdimage/edubuntu/releases/'
fedoraserver_url='https://torrent.fedoraproject.org/torrents/'
fedoraworkstation_url='https://torrent.fedoraproject.org/torrents/'
kali_url='http://ftp.cc.uoc.gr/mirrors/linux/kali/kali-images/kali-latest/amd64/'
kubuntu_url='ftp://cdimage.ubuntu.com/cdimage/kubuntu/releases/'
lubuntu_url='ftp://cdimage.ubuntu.com/cdimage/lubuntu/releases/'
mageia_url='http://distro.ibiblio.org/mageia/iso/cauldron/torrents/'
mythbuntu_url='ftp://cdimage.ubuntu.com/cdimage/mythbuntu/releases/'
netbsd_url='ftp://mirror.planetunix.net/pub/NetBSD/iso/'
opensuse_url='ftp://www.gtlib.gatech.edu/pub/opensuse/distribution/openSUSE-stable/iso/'
raspbian_url='http://downloads.raspberrypi.org/raspbian/images/'
sabayon_url='ftp://mirror.cs.vt.edu/pub/SabayonLinux/iso/monthly/'
slackware_url='http://www.slackware.com/torrents/'
spikepentesting_url='https://mirror.spike-pentesting.org/mirrors/spike/isos/torrents/'
stephensonsrocket_url='https://download.stephensonsrocket.horse/release/'
tails_url='https://tails.boum.org/torrents/files/'
ubuntu_url='ftp://releases.ubuntu.com/releases/'
ubuntugnome_url='ftp://cdimage.ubuntu.com/cdimage/ubuntu-gnome/releases/'
ubuntukylin_url='ftp://cdimage.ubuntu.com/cdimage/ubuntukylin/releases/'
ubuntumate_url='ftp://cdimage.ubuntu.com/cdimage/ubuntu-mate/releases/'
ubuntustudio_url='ftp://cdimage.ubuntu.com/cdimage/ubuntustudio/releases/'
xubuntu_url='ftp://cdimage.ubuntu.com/cdimage/xubuntu/releases/'

# pattern to identify wanted .torrent files
centos_match='*DVD*.torrent'
debiancdamd64_match='*netinst*'
debiancdi386_match='*netinst*'
debiandvdamd64_match='*.torrent'
debiandvdi386_match='*.torrent'
edubuntu_match='*.torrent'
fedoraserver_match='*Server*'
fedoraworkstation_match='*Workstation*'
kali_match='*.torrent'
kubuntu_match='*.torrent'
lubuntu_match='*.torrent'
mageia_match='*.torrent'
mythbuntu_match='*.torrent'
netbsd_match='*.torrent'
opensuse_match='*DVD*.torrent'
raspbian_match='*.torrent'
sabayon_match="*$sabayon_release*.torrent"
slackware_match='*dvd*'
spikepentesting_match='*.torrent'
stephensonsrocket_match='*.torrent'
tails_match='*.torrent'
ubuntu_match='*.torrent'
ubuntugnome_match='*.torrent'
ubuntukylin_match='*.torrent'
ubuntumate_match='*.torrent'
ubuntustudio_match='*.torrent'
xubuntu_match='*.torrent'

# pattern to exclude specific .torrent files
debiancdamd64_exclude='*update*'
debiancdi386_exclude='*update*'
debiandvdamd64_exclude='*update*'
debiandvdi386_exclude='*update*'
fedoraserver_exclude='*Alpha*'
fedoraworkstation_exclude='*Alpha*'
slackware_exclude='*source*'

#============================================================================#
# Get version info for distros that need it

for os in archnetinstdual centos edubuntu kubuntu lubuntu mythbuntu netbsd ubuntu ubuntugnome ubuntukylin ubuntumate ubuntustudio xubuntu ; do
	# oh man there is so much indirection here i might cry
	echo2 "Getting version info for: `eval echo \\\$\$os`"
	eval "$os"_release=`curl -s --disable-epsv -l \`eval echo \\\$\\\`eval echo $os\\\`_url\` | sort -n -r | awk NR==1`
done

echo2 "Getting version info for: Raspbian"
raspbian_release=`curl -s --disable-epsv -l 'http://downloads.raspberrypi.org/raspbian/images/' | sort -n -r | grep -o -E 'href=\".*?\"' | cut -d'"' -f2 | awk NR==1`

echo2 "Getting version info for: Sabayon"
sabayon_release=`curl -s --disable-epsv $sabayon/LATEST_IS`

#=== TYPE 1 =================================================================#
# Version info
# No exclusion pattern

for os in edubuntu kubuntu lubuntu mythbuntu netbsd raspbian ubuntu ubuntugnome ubuntukylin ubuntumate ubuntustudio xubuntu ; do
	echo2 "Downloading torrent files for: `eval echo \\\$\$os`"
	wget -q -nc -nv -r -nH --cut-dirs=6 --no-parent -A `eval echo \$\`eval echo $os\`_match` `eval echo \$\`eval echo $os\`_url``eval echo \$\`eval echo $os\`_release`/ -P "$torrent_location/"
done

#=== TYPE 2 =================================================================#
# Exclusion pattern
# No version info

for os in debiancdamd64 debiancdi386 debiandvdamd64 debiandvdi386 fedoraserver fedoraworkstation slackware ; do
	echo2 "Downloading torrent files for: `eval echo \\\$\$os`"
	wget -q -nc -nv -r -nH --cut-dirs=5 --no-parent -A `eval echo \$\`eval echo $os\`_match` -R `eval echo \$\`eval echo $os\`_exclude` `eval echo \$\`eval echo $os\`_url`/ -P "$torrent_location/"
done

#=== TYPE 3 =================================================================#
# No exclusion pattern or version info

for os in kali mageia opensuse sabayon spikepentesting stephensonsrocket tails ; do
	echo2 "Downloading torrent files for: `eval echo \\\$\$os`"
	wget -q -nc -nv -r -nH --cut-dirs=6 --no-parent -A `eval echo \$\`eval echo $os\`_match` `eval echo \$\`eval echo $os\`_url`/ -P "$torrent_location/"
done

#=== TYPE 4 =================================================================#
# Special cases

echo2 "Downloading torrent files for: Arch"
wget -q -nc -nv $archnetinstdual_url$archnetinstdual_release/*dual.iso.torrent -P "$torrent_location/"

echo2 "Downloading torrent files for: CentOS"
wget -q -nc -nv -r -nH --cut-dirs=5 --no-parent -A $centos_match $centos_url$centos_release/isos/x86_64/ -P "$torrent_location/"

#============================================================================#

# delete all folders that were somehow downloaded
for folder in $torrent_location/* ; do
	if [ -d "$folder" ] ; then
		mv $folder/*.torrent $torrent_location/ 2>/dev/null
		rm -rv $folder | while read line; do echo "Deleting $line"; done
	fi
done

# delete all files not ending in .torrent
GLOBIGNORE="*.torrent*"
rm -v $torrent_location/* | while read line; do echo "Deleting $line"; done 2>/dev/null
GLOBIGNORE=""

ending_filenum=`count`
end_time="$SECONDS"

dld_files=`expr $ending_filenum - $starting_filenum`
run_time=`expr $end_time - $start_time`

echo2 "Downloaded $dld_files new files in $run_time seconds ($ending_filenum total)"
