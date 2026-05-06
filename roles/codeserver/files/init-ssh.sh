#!/bin/bash
# Install dropbear if not present
if ! command -v dropbear &> /dev/null; then
    apt-get update -qq
    apt-get install -y --no-install-recommends dropbear
fi

# Fix SSH directory ownership
chown -R root:root /root/.ssh
chmod 700 /root/.ssh
chmod 600 /root/.ssh/authorized_keys 2>/dev/null || true

# Start dropbear
mkdir -p /etc/dropbear
dropbear -p 2222 -F -E -R
