# homelab-nextcloud-config

Configuration of nextcloud for running on my homelab.

## Init docker swarm

First run this command to init a docker swarm.

```console
$ docket swarm init
```

## Setup docker secrets

Then setup docker secrets by run this command.

```console
$ ./setup_secrets.sh
```

Follow the instructions and setup all secrets, you'll see those output finally.

```console
Docker secrets are ready to use.
ID                          NAME                       DRIVER              CREATED                  UPDATED
dsddbllte4jwz1iomre2ey56q   nextcloud_admin_password                       24 seconds ago           24 seconds ago
x0r961ohflxmsqxuogolxug5q   nextcloud_admin_user                           39 seconds ago           39 seconds ago
g5kz83yv5tuq8rm2l04q8evd4   postgres_db                                    15 seconds ago           15 seconds ago
n6yeo15rq4unz7osz13efdf2a   postgres_password                              Less than a second ago   Less than a second ago
5fz2hsxrhaebjfbw074zqm9nx   postgres_user                                  7 seconds ago            7 seconds ago
```

**Reset docker secrets**

For reset docker secrets, run the rm command first, and re-run the setup command.

```console
$ ./setup_secrets.sh rm
...

$ ./setup_secrets.sh
```
