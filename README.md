# homelab-nextcloud-config

Configure nextcloud to my homelab. Use postgres as data backend.

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

> If you're using reverse proxy to bypass traffic to nextcloud that deployed in the internal network, you should set it to meet the protocol of the public domain. For example if you access your cloud by `https://your.domain.xyz`, set `OVERWRITEPROTOCOL` to `https` to let nextcloud know which protocol it should use, otherwise nextcloud will always to set protocol to `http`.

`OVERWRITEWEBROOT`

The absolute web path of the proxy to the Nextcloud folder.

**Reference link**

- https://hub.docker.com/_/nextcloud/
- https://docs.nextcloud.com/server/latest/admin_manual/configuration_server/reverse_proxy_configuration.html

## Setup network for postgres and nextcloud

Create a new network for postgres and nextcloud to communicate with each other.

```console
$ docker network create --driver bridge \
  -o "com.docker.network.bridge.name"="docker-lab-net" lab-net
```

You can use `docker network connect` command to connect an existing container to specified network.

For example, the command below connect the nginx container to `lab-net` network.

```console
$ docker network connect lab-net nginx
```

> To permit containers communicate with each other in the user-defined network, you may have to configure your firewall to trust this network by this command. Reboot after run this command is recommended. (Notice that the bridge name defined above is used here)
>
> ```console
> $ firewall-cmd --permanent --zone=trusted --add-interface=docker-lab-net
> $ firewall-cmd --reload
> ```

## Make a postgres container first

Initialization of nextcloud needs postgres to be ready, so we should first create the postgres container and make sure it's ready to be used.

Before running postgres container, make sure the mount directory exists. If not, create it.

> This folder is for persist data to somewhere we can manage it locally and manually, for backup use or any other. You should put your .env file into the folder you created `database`.

```console
$ mkdir database
```

Run container.

```console
$ docker run \
  --name postgres --detach=true -it --restart=always \
  --mount type=bind,source="$(pwd)"/database,target=/var/lib/postgresql/data \
  --env-file .env --network lab-net postgres
```

Wait a few seconds and check the log, if you can see this line, it means the postgres is prepared.

```console
$ docker logs postgres
...
2020-07-17 14:52:08.129 UTC [1] LOG:  database system is ready to accept connections
```

## Make nextcloud container

Make sure the mount directory exists. Create one if not.

> This folder will be used to store all data that we daily use. It should have enough size to perform its job. Make sure your .env file is here.

```console
$ mkdir nextcloud
```

Create a container and publish port at 8080. If you use nginx to do reverse proxy, the `--publish` can be omitted by add nginx into the same network.

```console
$ docker run \
  --name nextcloud --detach=true -it --restart=always \
  --publish 8080:80 \
  --mount type=bind,source="$(pwd)"/nextcloud,target=/var/www/html \
  --env-file .env --network lab-net nextcloud

# or omit publish port
$ docker run \
  --name nextcloud --detach=true -it --restart=always \
  --mount type=bind,source="$(pwd)"/nextcloud,target=/var/www/html \
  --env-file .env --network lab-net nextcloud
```

## Max upload limit of nginx

By default, nginx has a limit of 1MB on file uploads. You can configure it by adding this line in **http block**. Restart nginx container to apply the config.

```conf
http {
    ...
    client_max_body_size 100M;
}
```

Nginx also has a limit of 1G on downloading, this is set by `proxy_buffering`, you can either disable `proxy_buffering` or increase `proxy_max_temp_file_size` to overcome the limit. (To me, just disabled `proxy_buffering` because nextcloud server is deployed in the same machine with nginx)

```conf
http {
    ...
    proxy_buffering off;
}
```

## (Optional) Increase timeout settings

> Line number may change because of version update.

Change line 404 in `3rdparty/guzzlehttp/guzzle/src/Handler/CurlFactory.php`, increase 1000 to 10000

In `lib/private/App/AppStore/Fetcher/Fetcher.php`, on line 98 change the timeout from 10 to 30 or 90

In `lib/private/Http/Client.php`,on line 66 change the timeout from 30 to 90
