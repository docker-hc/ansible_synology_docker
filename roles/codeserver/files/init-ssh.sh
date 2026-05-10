#!/bin/bash
# Install dropbear if not present
if ! command -v dropbear &> /dev/null; then
    apt-get update -qq
    apt-get install -y --no-install-recommends dropbear
fi

# Install python venv if not present
if [ ! -f /workspace/.venv/bin/activate ]; then
    apt-get install -y python3.12-venv -qq
    python3 -m venv /workspace/.venv
    /workspace/.venv/bin/pip install ansible-lint -q
fi

# Install python and venv if not present
if [ ! -f /workspace/.venv/bin/ansible-lint ]; then
    apt-get install -y python3 python3.12-venv -qq
    python3 -m venv /workspace/.venv
    /workspace/.venv/bin/pip install ansible-lint -q
fi
# Activate venv for root
echo 'source /workspace/.venv/bin/activate' >> /root/.bashrc

# Activate venv
source /workspace/.venv/bin/activate

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
fi

# Add Ubuntu VM to known hosts
mkdir -p /config/.ssh
echo '192.168.2.15 ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINMFUrQ5yV0NXdT6am+QUK+zncFtnR4fRyV0Eb64fRLn' >> /config/.ssh/known_hosts
chown -R abc:abc /config/.ssh
chmod 700 /config/.ssh
chmod 600 /config/.ssh/known_hosts

# Persist git config from workspace
ln -sf /workspace/.gitconfig /root/.gitconfig 2>/dev/null || true
ln -sf /workspace/.gitconfig /home/abc/.gitconfig 2>/dev/null || true

# Start dropbear in background (remove -F flag)
mkdir -p /etc/dropbear
dropbear -p 2222 -E -R

