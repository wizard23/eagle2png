#!/bin/bash

DPI=400

EAGLEPATH="/home/wizard23/software/eagle-6.4.0/bin"

EAGLE="$EAGLEPATH/eagle"
GERBV="gerbv"
CONVERT="convert"

BRDFILE=$1
PNGFILE=$2

#BRDFILE="MagicShifter_490.brd"
#PNGFILE="${BRDFILE%.brd}.png"

TEMPDIR="tmp"

VIEWPORT="-O-10x1 -O-1x2 -O-1x1 -O-1x0 -T1,2 -W3x6"

VIEWPORT="-O-2x-1 -W3x6"
VIEWPORT="-O-2x-0.5 -W3x5"

mkdir -p $TEMPDIR

if true; then
	echo; echo "Exporting gerber and excellon files from eagle board file.."
	yes | $EAGLE -X -dgerber_rs274x -c- -r -o "$TEMPDIR/layers_back.gerber" "$BRDFILE" 16 17 18
	yes | $EAGLE -X -dgerber_rs274x -c- -r -o "$TEMPDIR/layers_front.gerber" "$BRDFILE" 1 17 18
	yes | $EAGLE -X -dgerber_rs274x -c- -r -o "$TEMPDIR/layers_dimen.gerber" "$BRDFILE" 20
	yes | $EAGLE -X -dexcellon -c- -r -o "$TEMPDIR/layers_drill.excellon" "$BRDFILE" 44 45

	yes | $EAGLE -X -dgerber_rs274x -c- -r -o "$TEMPDIR/layers_pads.gerber" "$BRDFILE" 17 18
	yes | $EAGLE -X -dgerber_rs274x -c- -r -o "$TEMPDIR/layers_silk_front.gerber" "$BRDFILE" 21 25
	yes | $EAGLE -X -dgerber_rs274x -c- -r -o "$TEMPDIR/layers_silk_back.gerber" "$BRDFILE" 22 26
fi

echo; echo "Creating bitmap file using gerbv and convert.."
cat > "$TEMPDIR/gerber.gvp" <<- EOT
	(gerbv-file-version! "2.0A")
		(define-layer! 10 (cons 'filename "layers_drill.excellon")(cons 'visible #t)(cons 'color #(0 0 0)))
		(define-layer! 20 (cons 'filename "layers_dimen.gerber")(cons 'visible #t)(cons 'color #(65535 65535 65535)))
		(define-layer! 30 (cons 'filename "layers_front.gerber")(cons 'visible #t)(cons 'color #(65535 0 0)))
		(define-layer! 40 (cons 'filename "layers_back.gerber")(cons 'visible #t)(cons 'color #(0 0 65535)))

		(define-layer! 11 (cons 'filename "layers_pads.gerber")(cons 'visible #t)(cons 'color #(0 65535 0)))
		(define-layer! 12 (cons 'filename "layers_silk_front.gerber")(cons 'visible #t)(cons 'color #(65535 65535 65535)))
	(set-render-type! 0)
EOT
$GERBV --dpi=$DPI --export=png $VIEWPORT -o "$TEMPDIR/layers.png" -p "$TEMPDIR/gerber.gvp"
$CONVERT -rotate 90 "$TEMPDIR/layers.png" "$PNGFILE"

