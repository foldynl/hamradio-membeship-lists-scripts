LISTS_DIR=../../lists
CONTENT_FILE=../../lists/content.csv

function memberListHeader()
{
    echo "# $1"
    echo "callsign,member_id,valid_from,valid_to"
}

function downloadFile()
{ 
    curl -L -A "user-agent-name QLog" -s "$1" --output ${LISTS_DIR}/${2}
    echo $? 
}

function writeContentData()
{
    shortDesc="$1"
    longDesc="$2"
    filename="$3"
    lastUpdate="$4"
    numberRecords=$(("$5"-2))

    #insert or update
    [ -f ${CONTENT_FILE} ] && grep -q "^${shortDesc},${longDesc}" ${CONTENT_FILE} && sed -i "s/^${shortDesc},${longDesc}.*/${shortDesc},${longDesc},${filename},${lastUpdate},${numberRecords}/" ${CONTENT_FILE} || echo "${shortDesc},${longDesc},${filename},${lastUpdate},${numberRecords}" >> ${CONTENT_FILE}
    tmpfile=$(mktemp)
    sort ${CONTENT_FILE} > ${tmpfile}
    mv ${tmpfile} ${CONTENT_FILE}
}

