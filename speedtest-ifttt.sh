#!/bin/bash
##############################################################################
# Written by: Tyler Harris, 2018
# Run speedtest-cli within docker and append to Google Sheet through IFTTT
#   - Docker Image: https://hub.docker.com/r/tianon/speedtest/
#   - IFTTT Webhooks: https://ifttt.com/maker_webhooks
#   - https://ifttt.com/applets/379108p-log-speedtest-results-to-spreadsheet
#   - Sheet columns: "Date,Ping,Download (Mbps),Upload (Mbps)"
# License: GPL >=v3 [http://www.gnu.org/licenses/quick-guide-gplv3.html]
##############################################################################

# Character for separating values
# (commas are not safe, because some servers return speeds with commas)
delimiter=";"

# Temporary file holding speedtest-cli output
log=/tmp/speedtest-csv.log

# Prepare
start=`date +"%Y-%m-%d %H:%M:%S"`
mkdir -p `dirname $log`

if test -f "$log"; then
  # Reuse existing results (debugging)
  1>&2 echo "** Reusing existing results: $log"

else
  # Run Speedtest
  docker run --rm --net=host tianon/speedtest --secure --csv --csv-delimiter ";" --share > $log

fi

# Parse
IFS="$delimiter" read -ra results <<< `cat $log`
server_id=${results[0]}
sponsor=${results[1]}
server_name=${results[2]}
timestamp=${results[3]}
distance=${results[4]}
server_ping=${results[5]}
download=${results[6]}
upload=${results[7]}

# Convert from bits to Mbps
download=`bc <<< "scale=2; $download / 1000 / 1000" `
upload=`bc <<< "scale=2; $upload / 1000 / 1000" `

# Send to IFTTT
secret_key="<secret-key>"
curl https://maker.ifttt.com/trigger/speedtest/with/key/${secret_key} \
  -X POST \
  -H "Content-Type: application/json" \
  -d @<(cat <<EOF
{
  "value1":"${server_ping} Mbps",
  "value2":"${download} Mbps",
  "value3":"${upload}"
}
EOF
)

if [[ $? -ne 0 ]]; then
  echo "Problem sending to IFTTT !" >> "$log"
else
  echo
  rm -v "$log"
fi
