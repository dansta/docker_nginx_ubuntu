#!/bin/bash
# set up env
set -e
set -x
CONF="/etc/nginx/nginx.conf"
CONFDATA="$(cat $CONF)"
EXECPATH="/usr/local/bin"
KEY="awk -f $EXECPATH/key.awk"
VALUE="awk -f $EXECPATH/value.awk"

# get all the nginxvars
NGINXENV="$(set | grep NGINX)"

# for each nginxvar, replace them in the file
for i in $NGINXENV; do
  CONFDATA="$( echo "$CONFDATA" | sed s/"$(echo "$i" | $KEY)"/"$( echo "$i" | $VALUE )"/g)"
done

# write it to file
echo "$CONFDATA" > "$CONF"

#clear out all comments and write to file
#sed /^#.*$/d "$CONFDATA" > "$CONF"


cat "$CONF"
