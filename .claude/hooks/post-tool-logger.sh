#!/bin/bash
# LOG hook — records every terraform apply to the deploy log

INPUT=$(cat)
CMD=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

if echo "$CMD" | grep -q "terraform apply"; then
  echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] terraform apply executed" >> "${CLAUDE_PROJECT_DIR:-.}/.claude/deploy.log"
fi
