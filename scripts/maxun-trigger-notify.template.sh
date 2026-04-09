#!/bin/ash
# Expect 1 parameter which is the Maxun webhook JSON payload
if [ -z "$1" ]; then
    echo "Usage: $0 <payload>" >&2
    exit 1
fi

RUN_ID=$(echo "$1" | jq -r '.data.run_id')

if [ -z "$RUN_ID" ] || [ "$RUN_ID" = "null" ]; then
    echo "Error: could not extract run_id from payload" >&2
    exit 1
fi

curl -s -o /dev/null -w "%{http_code}" -X POST \
     -H "Authorization: Bearer {{AFRICAN_SKIMMER_GITHUB_TOKEN}}" \
     -H "Accept: application/vnd.github+json" \
     -d "{\"ref\":\"main\",\"inputs\":{\"run_id\":\"$RUN_ID\"}}" \
     "https://api.github.com/repos/{{AFRICAN_SKIMMER_GITHUB_REPO}}/actions/workflows/notify.yml/dispatches" | grep -q "^204$"

if [ $? -eq 0 ]; then
    echo "Successfully triggered notify workflow for run_id: $RUN_ID"
else
    echo "Error triggering notify workflow for run_id: $RUN_ID" >&2
    exit 1
fi

exit 0
