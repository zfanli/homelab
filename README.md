# homelab-nextcloud-config

Configuration of nextcloud for running on my homelab.

## Setup docker secrets

Then setup docker secrets by run this command.

```console
$ ./setup_secrets.sh
```

Follow the instructions and setup all secrets, you'll see those output finally.

```console
-rw-r--r--. 1 root root  6 Jul 17 00:18 nextcloud_admin_password.txt
-rw-r--r--. 1 root root  8 Jul 17 00:18 nextcloud_admin_user.txt
-rw-r--r--. 1 root root 10 Jul 17 00:18 postgres_db.txt
-rw-r--r--. 1 root root  9 Jul 17 00:18 postgres_password.txt
-rw-r--r--. 1 root root  7 Jul 17 00:18 postgres_user.txt
```

**Reset docker secrets**

For reset docker secrets, run the rm command first, and re-run the setup command.

```console
$ ./setup_secrets.sh rm
...

$ ./setup_secrets.sh
```

## Build docker compose

Use these commands to run the app.

```console
$ docker-compose build
$ docker-compose up -d
```

## Add your hostname to nextcloud's config

Modify `./nextcloud/config/config.php`, add your hostname to `trusted_domains`.

```php
  'trusted_domains' =>
  array (
    0 => 'localhost',
    1 => '10.0.0.11', // local ip addr
    2 => 'hostname', // other hostname
  ),
```
