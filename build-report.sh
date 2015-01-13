#!/bin/sh

OUTDIR=build

mkdir -p $OUTDIR

OUTFILE=report.html
PANDOC_OUTFILE=report.pdf
TEXT_OUTFILE=report.rst

#cat head.html > $OUTDIR/$OUTFILE
cat > $OUTDIR/$OUTFILE << EOF
<html>
<head>
<title>Vaclav Petras</title>
</head>
<body>
EOF
echo "<!-- This is a generated file. Do not edit. -->" >> $OUTDIR/$OUTFILE
for FILE in "publications.html projects.html research.html"
do
    ./clean-html-for-report.py $FILE >> $OUTDIR/$OUTFILE
done
#cat foot.html >> $OUTDIR/$OUTFILE
cat >> $OUTDIR/$OUTFILE << EOF
</body>
</html>
EOF

pandoc -V geometry:margin=0.5in --from=html -o $OUTDIR/$PANDOC_OUTFILE < $OUTDIR/$OUTFILE
pandoc --from=html -o $OUTDIR/$TEXT_OUTFILE < $OUTDIR/$OUTFILE
