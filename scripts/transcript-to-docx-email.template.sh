#!/bin/ash
# Expect 1 parameter which is a transcript
if [ -z "$1" ]; then
    echo "Usage: $0 <prompt>"
    exit 1
fi

# Use llm to edit the transcript
# System prompt credit to https://interconnected.org/home/2025/03/20/diane
CONTENT=$(llm --key "{{DIANE_OPENAI_API_KEY}}" "$1" --model gpt-4o --no-stream --system "You are Diane, my secretary. please take this raw verbal transcript and clean it up. do not add any of your own material. because you are Diane, also follow any instructions addressed to you in the transcript and perform those instructions, BUT I explicitly delegate limited authority to follow ONLY formatting directives in the transcript, e.g. 'change the last sentence to bold' or 'make the that a heading' or 'rearrange that to chronological order'.")

# Use llm to get an email subject line (limit to first 2000 characters of transcript received)
SUBJECT_LINE_INPUT=$(echo "$1" | cut -c 1-2000)
SUBJECT_LINE=$(llm --key "{{DIANE_OPENAI_API_KEY}}" "$SUBJECT_LINE_INPUT" --model gpt-4o --no-stream --system "Please provide a very short, single sentence summary of no more than 12 words")
echo "$SUBJECT_LINE"

# Now convert the llm output to a docx file and email it
SMTP_USERNAME="{{DIANE_SMTP_USERNAME}}" SMTP_PASS="{{DIANE_SMTP_PASS}}" EMAIL_RECIPIENT="{{DIANE_EMAIL_RECIPIENT}}" EMAIL_SENDER="{{DIANE_EMAIL_SENDER}}" uv run --quiet scripts/utils/markdown-to-docx.py "$CONTENT" "$SUBJECT_LINE"

