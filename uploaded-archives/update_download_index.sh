#!/bin/bash

SNAPS=${SNAPS:-/var/www/modula3.elegosoft.com/cm3/uploaded-archives}
FNPAT1=${FNPAT1:-"cm3-{min,std,all,core,base,doc}-{POSIX,WIN32,WIN,WIN64}-"}
FNPATSUF=${FNPATSUF:-.{tar.gz,tar.bz,tar.bz2,tgz,tbz,zip}}
FNPATLS=${FNPAT:-${FNPAT1}'*-*'${FNPATSUF}}
INDEX=${INDEX:-index.html}
cd $SNAPS || exit 1

TARGETS=`eval ls -1 ${FNPATLS} 2>/dev/null |
  awk -F- '{ print $4 }' |
  sort -u`

if [ -f "${INDEX}" ]; then
  mv ${INDEX} ${INDEX}.old
fi
cat > ${INDEX} << EOF
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>CM3 Uploaded Archives</title>
    <META HTTP-EQUIV="Content-Type" CONTENT="text/html">
    <META HTTP-EQUIV="Content-Style-Type" CONTENT="text/css">
    <META HTTP-EQUIV="Resource-type" CONTENT="document"> 
    <META HTTP-EQUIV="Reply-to" CONTENT="m3-support@elego.de"> 
    <LINK HREF="../normal.css" REL="stylesheet" TYPE="text/css">
    <META NAME="robots" content="noindex">
  </head>

  <body>
    <h2>CM3 Uploaded Archives</h2>

    <p>
      This directory contains archives contributed by members of the
      CM3 project. They may be of various quality as they are not
      tested before placed here. Use at your own risk.
    </p>

EOF

# echo $TARGETS
for t in ${TARGETS}; do
  all=`eval ls -1t ${FNPAT1}${t}-*${FNPATSUF} 2>/dev/null`
  echo "<h3>Target Platform ${t}</h3>"
  echo "<table border=\"3\" cellspacing=\"2\" cellpadding=\"4\" width=\"95%\"><tbody>"
  for f in ${all}; do
    echo "<tr>"
    ls -hl "$f" | awk ' {
      printf "<td width=\"15%%\" align=\"right\">\n"
      printf "%s", $6
      printf "</td><td width=\"6%%\" align=\"left\">\n"
      printf "%s", $7
      printf "</td><td width=\"6%%\" align=\"right\">\n"
      printf "%s", $5
    }'
    echo "</td><td width=\"63%\" align=\"left\">"
    echo "<a href=\"$f\">$f</a>"
    echo "</td><td width=\"10%\" align=\"center\">"
    if [ -r "$f.README" ]; then
      echo "<a href=\"$f.README\">README</a>"
    elif [ -r "$f.html" ]; then
      echo "<a href=\"$f.html\">Notes</a>"
    elif [ -r "$f.txt" ]; then
      echo "<a href=\"$f.txt\">Notes</a>"
    else
      echo "-"
    fi
    echo "</td></tr>"
  done
  echo "</tbody></table>"
done >> ${INDEX}

cat >> ${INDEX} <<EOF
    <hr>
    <address><a href="mailto:m3-support{at}elego.de">m3-support{at}elego.de</a></address>
<!-- Created: `date` -->
  </body>
</html>
EOF

rm -f ${INDEX}.old