# dokku-webhooks

dokku-webhooks is a plugin for [dokku](https://github.com/progrium/dokku) that
triggers external [webhooks](https://en.wikipedia.org/wiki/Webhook) in response
to build/deployment stages.

## Installation


```shell
# dokku 0.4.x+
sudo dokku plugin:install https://github.com/nickstenning/dokku-webhooks.git

# dokku 0.3
git clone https://github.com/nickstenning/dokku-webhooks.git /var/lib/dokku/plugins/webhooks
git reset --hard c5ade98a8e188ccd9f1f544e3ffc8c1d5d0ea4e0
```

Next, move the `receive-app` hook out of the way:

```shell
mv /var/lib/dokku/plugins/git/receive-app /var/lib/dokku/plugins/git/receive-app.bak
```

The second step is necessary because this plugin replaces the default
`receive-app` hook. If you don't use the default git `receive-app` hook then you
will need to modify the last lines of `receive-app` in this plugin accordingly.

## Configuration

Add a webhook:

    dokku webhooks:add https://example.com/my/webhook

Remove a webhook:

    dokku webhooks:remove https://example.com/my/webhook

List all installed webhooks:

    dokku webhooks

## Hooks

Each webhook endpoint is sent an HTTP POST request with a standard
`application/x-www-form-urlencoded` POST payload, the contents of which depend
on which stage of deployment has been reached.

All hook requests contain the following POST params:

Param            | Example value        | Description
---------------- | -------------------- | ------------------------------
`action`         | `receive-app`        | The deployment stage.
`hostname`       | `dokku.example.com`  | The FQDN of the dokku host.
`app`            | `mywebapp`           | The dokku app being deployed.

Other hook requests contain additional data, as detailed below.

### `receive-app`

This hook is triggered at the very start of a deployment, when dokku starts
receiving data pushed to git.

Param            | Example value                              | Description
---------------- | ------------------------------------------ | ----------------------------------------------------------------------------
`git_rev`        | `ade8218956d4a744ca42f872700384124edf015b` | The git revision being deployed.
`git_rev_before` | `0000000000000000000000000000000000000000` | The git revision currently deployed, or `0{40}` if this is the first deploy.

### `post-deploy`

This hook is triggered at the very end of a successful deployment.

Param            | Example value                         | Description
---------------- | ------------------------------------- | ------------------------------------------------
`internal_ip`    | `127.0.0.1`                           | The internal IP on which the app is listening.
`internal_port`  | `49152`                               | The internal port on which the app is listening.
`url`            | `https://mywebapp.dokku.example.com`  | The public URL of the deployed app.

## License

This free software is released under the MIT license, a copy of which can be
found in `LICENSE`.
