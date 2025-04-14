# southern_fiscal_webhook_config
Config Files for Webhook


### Update/Deploy

```shell
# Get latest changes
git pull

# Load env vars
set -a  # or set -o allexport
source .env
set +a  # or set +o allexport

# Substitue env vars
envsubst < webhook.template.json > webhook.json
envsubst < scripts/ha-trigger-gate.template.sh > scripts/ha-trigger-gate.sh
envsubst < scripts/ha-trigger-gate-pedestrian.template.sh > scripts/ha-trigger-gate-pedestrian.sh

# Make executable
chmod +x scripts/ha-trigger-gate.sh
chmod +x scripts/ha-trigger-gate-pedestrian.sh
```

And optionally:
```shell
docker restart webhook
```