# Hardening your instance
Here are some suggestions which improve the security of parts of your Akkoma instance.

## Configuration file

These changes should go into `prod.secret.exs` or `dev.secret.exs`, depending on your `MIX_ENV` value.

### `http`

> Recommended value: `[ip: {127, 0, 0, 1}]`

This sets the Akkoma application server to only listen to the localhost interface. This way, you can only reach your server over the Internet by going through the reverse proxy. By default, Akkoma listens on all interfaces.

### `secure_cookie_flag`

> Recommended value: `true`

This sets the `secure` flag on Akkoma’s session cookie. This makes sure, that the cookie is only accepted over encrypted HTTPs connections. This implicitly renames the cookie from `pleroma_key` to `__Host-pleroma-key` which enforces some restrictions. (see [cookie prefixes](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Set-Cookie#Cookie_prefixes))

### `Pleroma.Upload, :uploader, :base_url`

> Recommended value: *anything on a different domain than the instance endpoint; e.g. https://media.myinstance.net/*

Uploads are user controlled and (unless you’re running a true single-user
instance) should therefore not be considered trusted. But the domain is used
as a pivilege boundary e.g. by HTTP content security policy and ActivityPub.
Having uploads on the same domain enabled several past vulnerabilities
able to be exploited by malicious users.

### `:http_security`

> Recommended value: `true`

This will send additional HTTP security headers to the clients, including:

* `X-XSS-Protection: "0"`
* `X-Permitted-Cross-Domain-Policies: "none"`
* `X-Frame-Options: "DENY"`
* `X-Content-Type-Options: "nosniff"`

A content security policy (CSP) will also be set:

```csp
content-security-policy:
  default-src 'none';
  base-uri 'none';
  frame-ancestors 'none';
  img-src 'self' data: blob: https:;
  media-src 'self' https:;
  style-src 'self' 'unsafe-inline';
  font-src 'self';
  script-src 'self';
  connect-src 'self' wss://example.tld;
  manifest-src 'self';
  upgrade-insecure-requests;
```

#### `sts`

> Recommended value: `true`

An additional “Strict transport security” header will be sent with the configured `sts_max_age` parameter. This tells the browser, that the domain should only be accessed over a secure HTTPs connection.

#### `referrer_policy`

> Recommended value: `same-origin`

If you click on a link, your browser’s request to the other site will include from where it is coming from. The “Referrer policy” header tells the browser how and if it should send this information. (see [Referrer policy](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Referrer-Policy)). `no-referrer` can be used if a referrer is not needed for improved privacy.

## systemd

A systemd unit example is provided at `installation/akkoma.service`.

### PrivateTmp

> Recommended value: `true`

Use private `/tmp` and `/var/tmp` folders inside a new file system namespace, which are discarded after the process stops.

### ProtectHome

> Recommended value: `true`

The `/home`, `/root`, and `/run/user` folders can not be accessed by this service anymore. If your Akkoma user has its home folder in one of the restricted places, or use one of these folders as its working directory, you have to set this to `false`.

### ProtectSystem

> Recommended value: `full`

Mount `/usr`, `/boot`, and `/etc` as read-only for processes invoked by this service.

### PrivateDevices

> Recommended value: `true`

Sets up a new `/dev` mount for the process and only adds API pseudo devices like `/dev/null`, `/dev/zero` or `/dev/random` but not physical devices. This may not work on devices like the Raspberry Pi, where you need to set this to `false`.

### NoNewPrivileges

> Recommended value: `true`

Ensures that the service process and all its children can never gain new privileges through `execve()`.

### CapabilityBoundingSet

> Recommended value: `~CAP_SYS_ADMIN`

Drops the sysadmin capability from the daemon.
