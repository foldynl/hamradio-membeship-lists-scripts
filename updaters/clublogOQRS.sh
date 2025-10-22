#!/usr/bin/env bash

source lib/generic.sh

### CONFIG
memberFilename="clublogOQRS.csv"
URL="https://cdn.clublog.org/clublog-users.json.zip"
shortDesc="ClubLogOQRS"
longDesc="Club Log OQRS Members"
### END OF CONFIG

downloadfile="${memberFilename}.raw.zip"
jsonfile="clublog_users.json"

# Download ZIP file
downloadRet=$(downloadFile "${URL}" "${downloadfile}")
if [ $downloadRet != 0 ]; then
    echo "Cannot download a source file from ${URL}"
    exit 1
fi

# Extract JSON file
unzip -o "${LISTS_DIR}/${downloadfile}" -d "${LISTS_DIR}/" >/dev/null 2>&1
if [ ! -f "${LISTS_DIR}/${jsonfile}" ]; then
    echo "JSON file not found after unzip."
    exit 1
fi

# Normalize date for header
lastUpdateNormalized=$(date +"%Y%m%d")

# Write header
memberListHeader "${lastUpdateNormalized}" > "${LISTS_DIR}/${memberFilename}"

jq -r 'to_entries[] | select(.value.oqrs == true) | "\(.key | ascii_upcase),,,"' ${LISTS_DIR}/${jsonfile} >> "${LISTS_DIR}/${memberFilename}"

# Count lines
numberRecord=$(wc -l < "${LISTS_DIR}/${memberFilename}")

# Cleanup
rm -f "${LISTS_DIR}/${downloadfile}" "${LISTS_DIR}/${jsonfile}"

# Write metadata
writeContentData "${shortDesc}" "${longDesc}" "${memberFilename}" "${lastUpdateNormalized}" "${numberRecord}"

