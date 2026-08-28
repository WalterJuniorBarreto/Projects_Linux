cat << 'EOF' > dummy.sh
#!/bin/bash

LOG_FILE="/var/log/dummy-service.log"

touch "$LOG_FILE"

while true; do
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    MESSAGE="[$TIMESTAMP] Dummy service is running..."

    echo "$MESSAGE" >> "$LOG_FILE"

    echo "$MESSAGE"

    sleep 10
done
EOF
