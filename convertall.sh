#!/bin/bash

PNGDIR="pngs"
BRDDIR="brds"
SCRIPT="sh brd2png.sh"

mkdir -p $PNGDIR
for brd in $BRDDIR/MagicShifter*.brd 
do
	$SCRIPT $brd $PNGDIR/$(basename ${brd%.brd}.png)
done
