#!/usr/bin/env bash

echo "== MOUNT PROJECT DATA =="
read -r -d '' json_string << EOF
{
  "files" : [],
  "directories" : [
     {
      "proj_id" : "$DX_PROJECT_CONTEXT_ID",
      "folder" : "/",
      "dirname" : "/project"
     }
EOF

json_string="${json_string}]}"

echo "== FINAL DXFUSE JSON =="
echo ${json_string}
echo "======================="

echo ${json_string} > .dxfuse_manifest.json

MOUNTDIR=/mnt
mkdir -p $MOUNTDIR

chmod a+x /home/dnanexus/dxfuse
echo "dxfuse version: $(/home/dnanexus/dxfuse -version)"
/home/dnanexus/dxfuse -readOnly $MOUNTDIR .dxfuse_manifest.json
dxfuse_rval=$?
if [[ $dxfuse_rval -eq 0 ]]; then
    echo "Mounted $DX_PROJECT_CONTEXT_ID in $MOUNTDIR/project"
else
    echo "Error mounting $DX_PROJECT_CONTEXT_ID in $MOUNTDIR/project"
    tail /root/.dxfuse/dxfuse.log
    exit $dxfuse_rval
fi
