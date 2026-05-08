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

# Copy outgoing key to abc home for use as abc user
if [ -f /root/.ssh/id_dropbear ]; then
    mkdir -p /home/abc/.ssh
    cp /root/.ssh/id_dropbear /home/abc/.ssh/id_dropbear
    chown -R abc:abc /home/abc/.ssh
    chmod 700 /home/abc/.ssh
    chmod 600 /home/abc/.ssh/id_dropbear

# Start dropbear in background (remove -F flag)
mkdir -p /etc/dropbear
dropbear -p 2222 -E -R
