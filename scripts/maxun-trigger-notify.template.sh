#!/bin/ash
# Expect 1 parameter which is the Maxun webhook JSON payload
if [ -z "$1" ]; then
    echo "Usage: $0 <payload>" >&2
    exit 1
fi

RUN_ID=$(echo "$1" | grep -o '"run_id":"[^"]*"' | sed 's/"run_id":"//;s/"//')

if [ -z "$RUN_ID" ] || [ "$RUN_ID" = "null" ]; then
    echo "Error: could not extract run_id from payload" >&2
    exit 1
fi

HTTP_STATUS=$(curl -s -w "%{http_code}" -o /tmp/gh_response.txt -X POST \
     -H "Authorization: Bearer {{AFRICAN_SKIMMER_GITHUB_TOKEN}}" \
     -H "Accept: application/vnd.github+json" \
     -d "{\"ref\":\"main\",\"inputs\":{\"run_id\":\"$RUN_ID\"}}" \
     "https://api.github.com/repos/{{AFRICAN_SKIMMER_GITHUB_REPO}}/actions/workflows/notify.yml/dispatches")

echo "GitHub API response: $HTTP_STATUS - $(cat /tmp/gh_response.txt)"

if [ "$HTTP_STATUS" = "204" ]; then
    echo "Successfully triggered notify workflow for run_id: $RUN_ID"
else
    echo "Error triggering notify workflow for run_id: $RUN_ID" >&2
    exit 1
fi

exit 0
