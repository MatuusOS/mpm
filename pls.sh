#!/bin/bash

set -e

DEVMODE=""
echo "$@" | grep -q -- --devmode && DEVMODE="--devmode"

CLASSIC=""
echo "$@" | grep -q -- --devmode && DEVMODE="--devmode"

[ "$EUID" -eq 0 ] || { echo 'Please run as root. Exiting.' && exit; }

mkdir -p /etc/lol
touch /etc/lol/sources.list
if [ ! -s /etc/lol/sources.list ]; then
    echo '# Add the URLs above this line' > /etc/lol/sources.list
    echo 'github.com/' >> /etc/lol/sources.list
fi

json_val() {
    python3 -c "import sys, json; print(json.load(sys.stdin)$1)"
}

install_mpkg() {
    install_core
    { cat /etc/lol/sources.list; echo; } | while read -r URL; do
        version=$(curl "$URL/snap/v1/$2/$2.json" -f -s | json_val "['version']" 2>/dev/null || true)
        if [ "$version" != "" ]; then
            arch=$(curl "$URL/snap/v1/$2/$2.json" -f -s | json_val "['arch']" 2>/dev/null || true)
            snap_url="$URL/snap/v1/${2}/${2}_${version}_${arch}.snap"
            mkdir -p /MatuusOS/tmp/installscripts
            rm -f /MatuusOS/tmp/installscripts${2}*
            curl -f -# -o "/tmp/snaps/${2}.snap" "${snap_url}"
            md5sum=$(curl "$URL/snap/v1/$2/$2.json" -s | json_val "['md5sum']")
            md5sum --status -c <(echo "${md5sum} /tmp/snaps/${2}.snap") && echo 'Verified the downloaded snap.' || (echo 'Failed verification.' && exit 1)
            if [ "${2}" == "lol" ]; then CLASSIC='--classic'; fi
            ( file "/tmp/snaps/${2}.snap" | grep -q Squashfs ) && snap install --dangerous "/tmp/snaps/${2}.snap" \
                $DEVMODE $CLASSIC || echo 'Not a snap or an error occured.'
            break
        fi
    done || true
}

if [ "$1" == "install" ] && [ "$2" != "" ]; then
	install_snap "$1" "$2";
elif [ "$1" == "url" ] || [ "$1" == "repo" ]; then
	echo "Add all the repo URLs to the beginning of /etc/pls/sources.list for them to be used by pls." \
        "The order matters, so the repos at the top of the file will have highest priority."
elif [ "$1" == "refresh" ] && [ "$2" != "" ]; then
	install_snap "$1" "$2";;
else
    snap $@ | sed 's/snap/lol/g' | sed 's/lols/snaps/g' | sed 's/lold/snapd/g'
fi
