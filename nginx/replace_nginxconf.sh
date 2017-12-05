#!/bin/bash
# set up env
set -e
set -x
CONF="/etc/nginx/nginx.conf"
CONFDATA="$(cat $CONF)"
EXECPATH="/usr/local/bin"

# get all the nginxvars
NGINXENV="$(set | grep NGINX)"


# for each nginxvar, replace them in the file
for i in $NGINXENV; do
  CONFDATA=$( "${CONFDATA}"//"$(echo "$i" | awk -f $EXECPATH/key.awk)"/"$(echo "$i" | awk -f $EXECPATH/value.awk)"/ ) 
done

# write it to file
echo "$CONFDATA" > "$CONF"

#clear out all comments and write to file
#sed /^#.*$/d "$CONFDATA" > "$CONF"


cat "$CONF"
