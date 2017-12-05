#!/bin/bash
# set up env
set -e
set -x
CONF="/etc/nginx/nginx.conf"
CONFDATA="$(cat $CONF)"
KEY="awk -f /usr/local/bin/key.awk"
VALUE="awk -f /usr/local/bin/value.awk"

# get all the nginxvars
NGINXENV="$(env | grep NGINX)"

# for each nginxvar, replace them in the file
for i in $NGINXENV; do
  echo $i
  EDITED_DATA="$( echo $CONFDATA | \
               sed s/$(echo $i | $KEY)/$( echo $i | $VALUE )/g)"
done

# write it to file
echo "$EDITED_DATA" > "$CONF"

#clear out all comments and write to file
#sed /^#.*$/d "$CONFDATA" > "$CONF"


cat "$CONF"
