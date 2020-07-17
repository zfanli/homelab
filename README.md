# homelab-nextcloud-config

Configuration of nextcloud for running on my homelab. Use postgres sql as data backend.

## Setup .env file

Run this script to initialize a .env file.

```console
$ ./setup_env.sh
```

You'll be prompted to input some environment variables.

`NEXTCLOUD_ADMIN_USER`

The admin username of nextcloud.

`NEXTCLOUD_ADMIN_PASSWORD`

The password of admin user.

`POSTGRES_HOST`

The hostname of postgres sql. Recommend to specify the container's name.

`POSTGRES_USER`

The username of postgres.

`POSTGRES_PASSWORD`

The password of postgres user.

`POSTGRES_DB`

The name of database.

`TRUSTED_PROXIES`

Only set if you're using reverse proxy. Specify the trusted proxies to permit traffic bypass. Use space to separate each proxy.

`NEXTCLOUD_TRUSTED_DOMAINS`

Specify the trusted domain to host nextcloud. Use space to separate each domain.

`OVERWRITEHOST`

Reverse proxy config. The hostname of the proxy. You can also specify a port.

`OVERWRITEPROTOCOL`

The protocol of the proxy. You can choose between the two options http and https.

`OVERWRITEWEBROOT`

The absolute web path of the proxy to the Nextcloud folder.

**Reference link**

- https://hub.docker.com/_/nextcloud/
- https://docs.nextcloud.com/server/latest/admin_manual/configuration_server/reverse_proxy_configuration.html
