#!/usr/bin/env bash

# Work out what directory we are in, and resolve any symlinks
MYEXEC="$0"
[[ "${MYEXEC##*/}" = "$MYEXEC" ]] && MYEXEC=$(command -v "$MYEXEC")
[[ -z "$MYEXEC" ]] && MYEXEC="$0"
[[ "${MYEXEC#/}" = "$MYEXEC" ]] && MYEXEC="$PWD/$MYEXEC"
MYEXEC=$(readlink -e "$MYEXEC")
BINDIR="${MYEXEC%/*}"

if [[ ! -f $BINDIR/links.txt ]]; then
    echo "ERROR: Could not find links file $BINDIR/links.txt"
    exit 1
fi

while read file link
do
	# Check the source file exists
	if [[ ! -f "$BINDIR/$file" ]]; then
		echo "[ ERROR ] missing file $BINDIR/$file"
		continue
	fi

	# If there's no target present already then
	# simply link it. Note we prefer relative links
	# here.
	if [[ ! -e "$HOME/$link" ]]; then
		echo "[ LINK ] $file -> $link"
		ln -s "${BINDIR#$HOME/}/$file" "$HOME/$link"
		continue
	fi

	# If there is a link already present, check it
	# connects to this scripts location
	if [[ -h "$HOME/$link" ]]; then
		link_target=$(readlink "$HOME/$link")
		if [[ "${link_target#$HOME/}" = "${BINDIR#$HOME/}/$file" ]]; then
			echo "[ OK ] $link"
		else
			echo "[ ERROR ] wrong link for $link (${link_target#$HOME/} != ${BINDIR#$HOME/}/$file)"
		fi
		continue
	fi

	# Must exist but not be a link
	echo "[ ERROR ] $link exists but is not a link!"

done < "$BINDIR/links.txt"
