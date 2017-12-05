#!/bin/bash
# set up env
set -e
set -x
CONF="/etc/nginx/nginx.conf"
CONFDATA="$(cat $CONF)"
KEYAWK="awk -f /usr/local/bin/key.awk"
VALUEAWK="awk -f /usr/local/bin/value.awk"

# get all the nginxvars
NGINXENV="$(env | grep NGINX)"
# for each nginxvar, replace them in the file
for i in $NGINXENV; do
  KEYSED="sed s/$(echo $i | $KEYAWK)/$(echo $i | $VALUEAWK)"
  CONFDATA="$( echo $CONFDATA | $KEYSED )"
done

# write it to file
echo "$CONFDATA" > "$CONF"

#clear out all comments and write to file
#sed /^#.*$/d "$CONFDATA" > "$CONF"


cat "$CONF"
