#!/usr/bin/env bash

# linux-torrent.sh
# Inspired by this script:
#  https://github.com/ppaskowsky/Bash/blob/master/auto-linux-downloader.sh
# Copyright (C) 2016 by skwerlman
#

#============================== CONFIGURATION ===============================#

# torrent_location:
#   where to save the downloaded .torrent files
#   you should configure your torrent client to 'watch' this directory
#   if you want it to download the ISOs automatically
#torrent_location='/media/torrent-files'
torrent_location='/mnt/code/linux-torrents/temp'

# cleanup_old:
#   whether to delete old .torrent files or not
#   use caution, since this does not care where the old .torrents are from
cleanup_old=false

# allow_output:
#   whether to allow echoing of status messages
allow_output=true

#  ------------------------------- DISTROS --------------------------------  #

# friendly names for distros
# <distro>='Distro Name'

# pattern to exclude specific .torrent files
# <distro>_exclude='pattern'

# pattern to identify wanted .torrent files
# <distro>_match='pattern'

# urls of folders containing .torrent files
# <distro>_url='iterable.directory.of/torrent/files'

antergos='Antergos'
antergos_match='*.torrent'
antergos_url='http://mirror.umd.edu/antergos/iso/release/'

# !! Arch is a special case !!
arch='Arch'
arch_url='ftp://mirror.rackspace.com/archlinux/iso/'

# !! CentOS is a special case !!
centos='CentOS'
centos_match='*DVD*.torrent'
centos_url='ftp://mirror.rackspace.com/CentOS/'

debiancdamd64='Debian (1/4)'
debiancdamd64_exclude='*update*'
debiancdamd64_match='*netinst*'
debiancdamd64_url='ftp://cdimage.debian.org/cdimage/release/current/amd64/bt-cd/'

debiancdi386='Debian (2/4)'
debiancdi386_exclude='*update*'
debiancdi386_match='*netinst*'
debiancdi386_url='ftp://cdimage.debian.org/cdimage/release/current/i386/bt-cd/'

debiandvdamd64='Debian (3/4)'
debiandvdamd64_exclude='*update*'
debiandvdamd64_match='*.torrent'
debiandvdamd64_url='ftp://cdimage.debian.org/cdimage/release/current/amd64/bt-dvd/'

debiandvdi386='Debian (4/4)'
debiandvdi386_exclude='*update*'
debiandvdi386_match='*.torrent'
debiandvdi386_url='ftp://cdimage.debian.org/cdimage/release/current/i386/bt-dvd/'

edubuntu='Edubuntu'
edubuntu_match='*.torrent'
edubuntu_url='ftp://cdimage.ubuntu.com/cdimage/edubuntu/releases/'

fedoraserver='Fedora'
fedoraserver_match='*.torrent'
fedoraserver_url='https://torrent.fedoraproject.org/torrents/'

kali='Kali'
kali_match='*.torrent'
kali_url='http://images.kali.org/'

kubuntu='Kubuntu'
kubuntu_match='*.torrent'
kubuntu_url='ftp://cdimage.ubuntu.com/cdimage/kubuntu/releases/'

lubuntu='Lubuntu'
lubuntu_match='*.torrent'
lubuntu_url='ftp://cdimage.ubuntu.com/cdimage/lubuntu/releases/'

mageia='Mageia'
mageia_match='*.torrent'
mageia_url='http://distro.ibiblio.org/mageia/iso/cauldron/torrents/'

mythbuntu='Mythbuntu'
mythbuntu_match='*.torrent'
mythbuntu_url='ftp://cdimage.ubuntu.com/cdimage/mythbuntu/releases/'

netbsd='NetBSD'
netbsd_match='*.torrent'
netbsd_url='ftp://mirror.planetunix.net/pub/NetBSD/iso/'

opensuse='OpenSUSE'
opensuse_match='*DVD*.torrent'
opensuse_url='http://download.opensuse.org/distribution/openSUSE-current/iso/'

raspbian='Raspberry Pi'
raspbian_match='*.torrent'
raspbian_url='http://downloads.raspberrypi.org/raspbian/images/'

sabayon='Sabayon'
sabayon_match="*$sabayon_release*.torrent"
sabayon_url='ftp://mirror.cs.vt.edu/pub/SabayonLinux/iso/monthly/'

slackware='Slackware'
slackware_exclude='*source*'
slackware_match='*dvd*'
slackware_url='http://www.slackware.com/torrents/'

stephensonsrocket="Stephenson's Rocket"
stephensonsrocket_match='*.torrent'
stephensonsrocket_url='https://download.stephensonsrocket.horse/release/'

tails='TAILS'
tails_match='*.torrent'
tails_url='https://tails.boum.org/torrents/files/'

ubuntu='Ubuntu'
ubuntu_match='*.torrent'
ubuntu_url='ftp://releases.ubuntu.com/releases/'

ubuntugnome='Ubuntu GNOME'
ubuntugnome_match='*.torrent'
ubuntugnome_url='ftp://cdimage.ubuntu.com/cdimage/ubuntu-gnome/releases/'

ubuntukylin='Ubuntu Kylin'
ubuntukylin_match='*.torrent'
ubuntukylin_url='ftp://cdimage.ubuntu.com/cdimage/ubuntukylin/releases/'

ubuntumate='Ubuntu MATE'
ubuntumate_match='*.torrent'
ubuntumate_url='ftp://cdimage.ubuntu.com/cdimage/ubuntu-mate/releases/'

ubuntustudio='Ubuntu Studio'
ubuntustudio_match='*.torrent'
ubuntustudio_url='ftp://cdimage.ubuntu.com/cdimage/ubuntustudio/releases/'

xubuntu='Xubuntu'
xubuntu_match='*.torrent'
xubuntu_url='ftp://cdimage.ubuntu.com/cdimage/xubuntu/releases/'

#  ------------------------------------------------------------------------  #

needs_version_info='arch centos edubuntu kubuntu lubuntu mythbuntu netbsd ubuntu ubuntugnome ubuntukylin ubuntumate ubuntustudio xubuntu'

no_exclusions='edubuntu kubuntu lubuntu mythbuntu netbsd raspbian ubuntu ubuntugnome ubuntukylin ubuntumate ubuntustudio xubuntu'

exclusions_no_version_info='debiancdamd64 debiancdi386 debiandvdamd64 debiandvdi386 slackware'

no_exclusions_no_version_info='antergos fedoraserver mageia opensuse sabayon stephensonsrocket tails'

#============================================================================#

# # # # # # # # # # # # # # # # #
# IGNORE EVERYTHING  BELOW HERE #
# IT WILL MAKE  YOUR EYES BLEED #
# # # # # # # # # # # # # # # # #

# You've been warned...

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

rm_non_torrents() {
	GLOBIGNORE="*.torrent*"
	rm -v $torrent_location/* 2>/dev/null | cut -d' ' -f2 | while read line; do echo "Deleting $line"; done
	GLOBIGNORE=""
}

#============================================================================#
# Get version info for distros that need it

for os in $needs_version_info ; do
	# OH GOD THE INDIRECTION
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

for os in $no_exclusions ; do
	echo2 "Downloading torrent files for: `eval echo \\\$\$os`"
	wget -q -nc -nv -r -nH --cut-dirs=6 --no-parent -A `eval echo \$\`eval echo $os\`_match` `eval echo \$\`eval echo $os\`_url``eval echo \$\`eval echo $os\`_release`/ -P "$torrent_location/"
	rm_non_torrents
done

#=== TYPE 2 =================================================================#
# Exclusion pattern
# No version info

for os in $exclusions_no_version_info ; do
	echo2 "Downloading torrent files for: `eval echo \\\$\$os`"
	wget -q -nc -nv -r -nH --cut-dirs=6 --no-parent -A `eval echo \$\`eval echo $os\`_match` -R `eval echo \$\`eval echo $os\`_exclude` `eval echo \$\`eval echo $os\`_url` -P "$torrent_location/"
	rm_non_torrents
done

#=== TYPE 3 =================================================================#
# No exclusion pattern or version info

for os in $no_exclusions_no_version_info ; do
	echo2 "Downloading torrent files for: `eval echo \\\$\$os`"
	wget -q -nc -nv -r -nH --cut-dirs=6 --no-parent -A `eval echo \$\`eval echo $os\`_match` `eval echo \$\`eval echo $os\`_url` -P "$torrent_location/"
	rm_non_torrents
done

#=== TYPE 4 =================================================================#
# Special cases

echo2 "Downloading torrent files for: Arch"
wget -q -nc -nv $arch_url$arch_release/*dual.iso.torrent -P "$torrent_location/"

echo2 "Downloading torrent files for: CentOS"
wget -q -nc -nv -r -nH --cut-dirs=6 --no-parent -A $centos_match $centos_url$centos_release/isos/x86_64/ -P "$torrent_location/"

rm_non_torrents

#============================================================================#

# delete all folders that were somehow downloaded
for folder in $torrent_location/* ; do
	if [ -d "$folder" ] ; then
		mv $folder/*.torrent $torrent_location/ 2>/dev/null
		rm -rv $folder | while read line; do echo "Deleting $line"; done
	fi
done

ending_filenum=`count`
end_time="$SECONDS"

dld_files=`expr $ending_filenum - $starting_filenum`
run_time=`expr $end_time - $start_time`

echo2 "Downloaded $dld_files new files in $run_time seconds ($ending_filenum total)"
