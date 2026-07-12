#!/bin/bash
# scripts/auto-stop.sh - Shutdown VM after 2 hours of inactivity

# CONFIGURATION
IDLE_LIMIT_SECONDS=7200  # 2 hours
CPU_THRESHOLD=0.10       # 10% load average
TIMESTAMP_FILE="/tmp/last_active_timestamp"

# Initialize timestamp if it doesn't exist
if [ ! -f "$TIMESTAMP_FILE" ]; then
    date +%s > "$TIMESTAMP_FILE"
fi

# 1. Check for active SSH sessions
SESSION_COUNT=$(who | wc -l)

# 2. Check CPU Load (1-minute average)
CPU_LOAD=$(uptime | awk -F'load average:' '{ print $2 }' | cut -d',' -f1 | tr -d ' ')

# Logic: If someone is logged in OR CPU is busy, update the "last active" timer
# We use 'bc' for floating point comparison of the CPU load
IS_BUSY=$(echo "$CPU_LOAD > $CPU_THRESHOLD" | bc -l)

if [ "$SESSION_COUNT" -gt 0 ] || [ "$IS_BUSY" -eq 1 ]; then
    # System is active, reset the idle timer
    date +%s > "$TIMESTAMP_FILE"
    echo "$(date): System active (Sessions: $SESSION_COUNT, Load: $CPU_LOAD). Timer reset."
else
    # System is idle, check how long it's been idle
    LAST_ACTIVE=$(cat "$TIMESTAMP_FILE")
    CURRENT_TIME=$(date +%s)
    IDLE_DURATION=$((CURRENT_TIME - LAST_ACTIVE))
    
    echo "$(date): System idle for $IDLE_DURATION seconds."

    if [ "$IDLE_DURATION" -ge "$IDLE_LIMIT_SECONDS" ]; then
        echo "Idle limit reached ($IDLE_LIMIT_SECONDS s). Shutting down..."
        sudo shutdown -h now
    fi
fi
