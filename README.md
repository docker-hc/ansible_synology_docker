# ansible_synology_docker
Using Ansible to configure Synology Docker Containers
## Nginx Reverse Proxy

Custom security headers are added directly to:
/usr/local/etc/nginx/sites-available/5af5bdd7-2818-4c97-a66b-0043fcbf1e0e.w3conf

Backup stored at: /volume1/docker/nginx-proxy-backup.conf

If DSM overwrites the config, restore from backup:
chattr -i /usr/local/etc/nginx/sites-available/5af5bdd7-2818-4c97-a66b-0043fcbf1e0e.w3conf
cp /volume1/docker/nginx-proxy-backup.conf /usr/local/etc/nginx/sites-available/5af5bdd7-2818-4c97-a66b-0043fcbf1e0e.w3conf
nginx -s reload
chattr +i /usr/local/etc/nginx/sites-available/5af5bdd7-2818-4c97-a66b-0043fcbf1e0e.w3conf
