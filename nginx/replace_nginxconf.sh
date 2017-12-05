#!/bin/bash
# set up env
set -e
set -x
CONF="/etc/nginx/nginx.conf"
CONFDATA="$(cat $CONF)"
SED_DATA=$CONFDATA
KEY="awk -f /usr/local/bin/key.awk"
VALUE="awk -f /usr/local/bin/value.awk"

# get all the nginxvars
NGINXENV="$(env | grep NGINX)"

# for each nginxvar, replace them in the file
for i in $NGINXENV; do
  SED_DATA="$( echo $SED_DATA | sed s/$(echo $i | $KEY )/$( echo $i | $VALUE )/g)"
done

# write it to file
echo "$SED_DATA" > "$CONF"

#clear out all comments and write to file
#sed /^#.*$/d "$CONFDATA" > "$CONF"


cat "$CONF"
