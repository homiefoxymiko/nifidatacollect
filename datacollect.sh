#!/bin/bash
HOOK=$WEBURL
for X in $(curl -s --insecure -u "$LOGIN:$PASS" https://$URL/nifi-app/nifi-api/process-groups/root/process-groups | jq '.processGroups[].status.id' --raw-output); do echo $X >> tempid; done
describeid=`cat tempid`
rm tempid
idlines=`echo $describeid`
for idline in $idlines
do
  output=$(curl -s --insecure -u "$LOGIN:$PASS" https://$URL/nifi-app/nifi-api/flow/process-groups/$idline/status)
  message=$(echo '   Processes Group Info:' && echo $output | jq '.processGroupStatus.aggregateSnapshot.processGroupStatusSnapshots[].processGroupStatusSnapshot | .name + " - " + .queued' --raw-output | while read -r line; do echo "   $line"; done)
  header=$(echo $output | jq --raw-output '.processGroupStatus.aggregateSnapshot.name + " (total items in queue): " + .processGroupStatus.aggregateSnapshot.queued')
  PAYLOAD="payload={\"text\": \"NIFI DATA\",\"attachments\":[{\"fallback\":\"t\",\"color\":\"#008000\",\"fields\":[{\"title\":\"$header\",\"value\":\"$message\",\"short\":true}]}]}"

  curl -X POST --data-urlencode "$PAYLOAD" "$HOOK"
done