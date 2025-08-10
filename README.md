# southern_fiscal_webhook_config
Config Files for Webhook

### Requirements

```shell
curl -LsSf https://astral.sh/uv/install.sh | sh     # Install uv
uv tool install llm                                 # Install llm
curl -sSL https://raw.githubusercontent.com/tests-always-included/mo/master/mo -o mo && chmod +x mo && sudo mv mo /usr/local/bin/   # Install mo
```

### Update/Deploy

```shell
ssh root@blackkite
cd /var/southern_fiscal_webhook_config

# Get latest changes
git pull

# Load env vars
set -a  # or set -o allexport
source .env
set +a  # or set +o allexport

# Substitue env vars
mo webhook.template.json > webhook.json
mo scripts/ha-trigger-gate.template.sh > scripts/ha-trigger-gate.sh
mo scripts/ha-trigger-gate-pedestrian.template.sh > scripts/ha-trigger-gate-pedestrian.sh
mo scripts/transcript-to-docx-email.template.sh > scripts/transcript-to-docx-email.sh

# Make executable
chmod +x scripts/ha-trigger-gate.sh
chmod +x scripts/ha-trigger-gate-pedestrian.sh
chmod +x scripts/transcript-to-docx-email.sh
```

And optionally:
```shell
docker restart webhook
```