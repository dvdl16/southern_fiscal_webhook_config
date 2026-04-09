# southern_fiscal_webhook_config

Config files for a [webhook](https://github.com/adnanh/webhook) server running in Docker on `blackkite`. Templates use [mo](https://github.com/tests-always-included/mo) (bash mustache) for env var substitution. Secrets live in `.env` and are never committed.

## Webhooks

| ID | Trigger | Action |
|----|---------|--------|
| `webhook-ha-trigger-gate` | `X-Secret` header | Triggers HA switch to open the vehicle gate |
| `webhook-ha-trigger-gate-pedestrian` | `X-Secret` header | Triggers HA switch to open the pedestrian gate |
| `webhook-diane-process-transcript` | Mailgun user ID in payload | Cleans up a voice transcript via GPT-4o and emails it as a .docx |
| `webhook-maxun-trigger-notify` | `?secret=` query param | Receives Maxun run completion and triggers the `african_skimmer_notifications` GitHub Action |

### webhook-maxun-trigger-notify

All Maxun robots should point to:
```
https://southern-fiscal.laarse.co.za/hooks/webhook-maxun-trigger-notify?secret=<MAXUN_WEBHOOK_SECRET>
```

The `run_id` from the payload is passed to the `notify.yml` workflow dispatch in the `african_skimmer_notifications` repo. The GitHub token requires **Actions: Read and write** on that repo.

## Requirements

```shell
curl -LsSf https://astral.sh/uv/install.sh | sh     # Install uv
uv tool install llm                                  # Install llm
curl -sSL https://raw.githubusercontent.com/tests-always-included/mo/master/mo -o mo && chmod +x mo && sudo mv mo /usr/local/bin/   # Install mo
```

## Deploy

```shell
ssh root@blackkite
cd /var/southern_fiscal_webhook_config

# Get latest changes
git pull

# Load env vars
set -a
source .env
set +a

# Substitute env vars
mo webhook.template.json > webhook.json
mo scripts/ha-trigger-gate.template.sh > scripts/ha-trigger-gate.sh
mo scripts/ha-trigger-gate-pedestrian.template.sh > scripts/ha-trigger-gate-pedestrian.sh
mo scripts/transcript-to-docx-email.template.sh > scripts/transcript-to-docx-email.sh
mo scripts/maxun-trigger-notify.template.sh > scripts/maxun-trigger-notify.sh

# Make executable
chmod +x scripts/ha-trigger-gate.sh
chmod +x scripts/ha-trigger-gate-pedestrian.sh
chmod +x scripts/transcript-to-docx-email.sh
chmod +x scripts/maxun-trigger-notify.sh
```

Then restart the container to pick up webhook config changes:
```shell
docker restart webhook
```

> Scripts do not require a restart — they are executed fresh on each request.

## Environment variables

Copy `.env.example` to `.env` and fill in real values. See `.env.example` for all required variables.
