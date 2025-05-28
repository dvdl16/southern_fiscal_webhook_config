#!/bin/ash

# Call the Home Assistant API to turn the switch on
curl -X POST \
     -H "Authorization: Bearer {{HA_ACCESS_TOKEN_TRIGGER_GATE}}" \
     -H "Content-Type: application/json" \
     -d "{\"entity_id\": \"{{HA_ENTITY_ID_TRIGGER_GATE}}\"}" \
     "http://{{HA_INSTANCE_HOST}}:{{HA_INSTANCE_PORT}}/api/services/switch/turn_on"

# Optional: Add a check for success (curl exit code 0 usually means success, but API might return error details)
if [ $? -eq 0 ]; then
  echo "Successfully sent turn_on command for ${ENTITY_ID}"
else
  echo "Error sending command for ${ENTITY_ID}" >&2
  exit 1
fi

exit 0