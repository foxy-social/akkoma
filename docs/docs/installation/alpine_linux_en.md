# Installing on Alpine Linux

{! installation/otp_vs_from_source_source.include !}

## Installation

This guide is a step-by-step installation guide for Alpine Linux. The instructions were verified against Alpine v3.16 standard image. You might miss additional dependencies if you use `netboot` instead.

As of Alpine Linux v3.16, `doas` is the preferred way of running privileged commands, which is what this guide will use.
If you are running an earlier version, replace `doas` with `sudo` (and use `sudo -Hu akkoma` instead of `doas -u akkoma`).
If you want to run this guide with root, ignore the `doas` at the beginning of the lines, unless it calls a user like `doas -u akkoma`; in this case, use `su -l <username> -s $SHELL -c 'command'` instead.

{! installation/generic_dependencies.include !}

### Prepare the system

* The community repository must be enabled in `/etc/apk/repositories`. Depending on which version and mirror you use this looks like `https://dl-5.alpinelinux.org/alpine/v3.16/community`. If you autogenerated the mirror during installation:

```shell
awk 'NR==2' /etc/apk/repositories | sed 's/main/community/' | tee -a /etc/apk/repositories
```

* Then update the system, if not already done:

```shell
doas apk update
doas apk upgrade
```

* Install some tools, which are needed later:

```shell
doas apk add git build-base cmake file-dev
```

### Install Elixir and Erlang

* Install Erlang and Elixir:

```shell
doas apk add erlang elixir
```

* Install `erlang-eldap` if you want to enable ldap authenticator

```shell
doas apk add erlang-eldap
```

### Install PostgreSQL

* Install Postgresql server:

```shell
doas apk add postgresql postgresql-contrib
```

* Initialize database:

```shell
doas rc-service postgresql start
```

* Enable and start postgresql server:

```shell
doas rc-update add postgresql
```

### Install media / graphics packages (optional, see [`docs/installation/optional/media_graphics_packages.md`](../installation/optional/media_graphics_packages.md))

```shell
doas apk add ffmpeg imagemagick exiftool
```

### Install AkkomaBE

* Add a new system user for the Akkoma service:

```shell
doas addgroup akkoma
doas adduser -S -s /bin/false -h /opt/akkoma -H -G akkoma akkoma
```

**Note**: To execute a single command as the Akkoma system user, use `doas -u akkoma command`. You can also switch to a shell by using `doas -su akkoma`. If you don’t have and want `doas` on your system, you can use `su` as root user (UID 0) for a single command by using `su -l akkoma -s $SHELL -c 'command'` and `su -l akkoma -s $SHELL` for starting a shell.

* Git clone the AkkomaBE repository from stable-branch and make the Akkoma user the owner of the directory:

```shell
doas mkdir -p /opt/akkoma
doas chown -R akkoma:akkoma /opt/akkoma
doas -u akkoma git clone https://akkoma.dev/AkkomaGang/akkoma.git -b stable /opt/akkoma
```

* Change to the new directory:

```shell
cd /opt/akkoma
```

* Install the dependencies for Akkoma and answer with `yes` if it asks you to install `Hex`:

```shell
doas -u akkoma mix deps.get
```

* Generate the configuration: `doas -u akkoma env MIX_ENV=prod mix pleroma.instance gen`
  * Answer with `yes` if it asks you to install `rebar3`.
  * This may take some time, because parts of akkoma get compiled first.
  * After that it will ask you a few questions about your instance and generates a configuration file in `config/generated_config.exs`.

* Check the configuration and if all looks right, rename it, so Akkoma will load it (`prod.secret.exs` for productive instances):

```shell
doas -u akkoma mv config/{generated_config.exs,prod.secret.exs}
```

* The previous command creates also the file `config/setup_db.psql`, with which you can create the database:

```shell
doas -u postgres psql -f config/setup_db.psql
```

* Now run the database migration:

```shell
doas -u akkoma env MIX_ENV=prod mix ecto.migrate
```

* Now you can start Akkoma already

```shell
doas -u akkoma env MIX_ENV=prod mix phx.server
```

### Finalize installation

If you want to open your newly installed instance to the world, you should run nginx or some other webserver/proxy in front of Akkoma and you should consider to create an OpenRC service file for Akkoma.

#### Nginx

* Install nginx, if not already done:

```shell
doas apk add nginx
```

* Copy the example nginx configuration to the nginx folder

```shell
doas cp /opt/akkoma/installation/nginx/akkoma.nginx /etc/nginx/conf.d/akkoma.conf
```

* Before starting nginx edit the configuration and change it to your needs. You must change change `server_name`. You can use `nano` (install with `apk add nano` if missing).
* Enable and start nginx:

```shell
doas rc-update add nginx
doas rc-service nginx start
```

* Setup your SSL cert, using your method of choice or certbot. If using certbot, first install it:

```shell
doas apk add certbot certbot-nginx
```

and then set it up:

```shell
doas mkdir -p /var/lib/letsencrypt/
doas certbot --email <your@emailaddress> -d <yourdomain> -d <media_domain> --nginx
```

If that doesn't work the first time, add `--dry-run` to further attempts to avoid being ratelimited as you identify the issue, and do not remove it until the dry run succeeds. A common source of problems are nginx config syntax errors; this can be checked for by running `nginx -t`.

To automatically renew, set up a cron job like so:

```shell
# Enable the crond service
doas rc-update add crond
doas rc-service crond start

# Test that renewals work
doas certbot renew --cert-name yourinstance.tld --nginx --dry-run

# Add the renewal task to cron
echo '#!/bin/sh
certbot renew --cert-name yourinstance.tld --nginx
' | doas tee /etc/periodic/daily/renew-akkoma-cert
doas chmod +x /etc/periodic/daily/renew-akkoma-cert

```

#### OpenRC service

* Copy example service file:

```shell
doas cp /opt/akkoma/installation/init.d/akkoma /etc/init.d/akkoma
```

* Make sure to start it during the boot

```shell
doas rc-update add akkoma
```

#### Create your first user

If your instance is up and running, you can create your first user with administrative rights with the following task:

```shell
doas -u akkoma env MIX_ENV=prod mix pleroma.user new <username> <your@emailaddress> --admin
```

{! installation/frontends.include !}

#### Further reading

{! installation/further_reading.include !}

{! support.include !}
