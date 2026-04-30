# Rose API Project Skeleton

This repository contains a sample project to use as skeleton to build APIs with Rose to be fully compliant with [Wind](https://github.com/rsthn/rose-core/blob/master/Wind.md). Install using composer:

For more information about Rose itself, see the [rose-core documentation](https://github.com/rsthn/rose-core/blob/master/docs/README.md) and the [configuration reference](https://github.com/rsthn/rose-core/blob/master/docs/CONFIG.md).

```sh
composer create-project rsthn/rose-api <target-directory>
```

After installation edit your `composer.json` file to reflect your own project details.

<br/>

## Requirements

This project targets **PHP 8.0+**. The following PHP extensions are used by Rose itself — refer to the [rose-core README](https://github.com/rsthn/rose-core/blob/master/README.md) for the authoritative list.

### Required (always)

| Extension | Used for |
|---|---|
| `mbstring` | Unicode-aware string operations |
| `json` | Parsing and response serialization |
| `curl` | HTTP client (`request:*`) |
| `openssl` | Crypto, certificate/PKI handling |
| `hash` | Hashing and HMAC digests |
| `zlib` | Gzip/deflate compression |
| `gd` | Image operations |
| `simplexml` | XML parsing |

### Optional — database drivers

Only required if you actually use a database driver via the `[Database]` section of `system.conf`:

| Driver value | PHP extension |
|---|---|
| `mysql` / `mysqli` | `mysqli` |
| `postgres` | `pgsql` |
| `sqlserver` | `sqlsrv` |
| `odbc` | `odbc` |

<br/>

## Quick Test

Let's assume you installed the project in a folder named `test`, open your browser and navigate to `http://localhost/test/`, if everything is fine you should see the JSON result, as follows:

```json
{
	"response": 200,
	"framework": "rsthn/rose-core",
    "version": "5.0.0"
}
```

There is also another API function named `now`, if you navigate to `http://localhost/test/?f=now` the result should be:

```json
{
	"response": 200,
	"server_time": "2024-04-08 07:20:12",
    "database_time": "2024-04-08 07:20:12"
}
```

Now, for simplicity if you don't like to use the `f` parameter (_which is fine, by the way_) but rather a URL path (such as `http://localhost/test/now`), you can configure your web server to rewrite the URL. When using Apache-compatible use the following in your `.htaccess` file:

```
RewriteEngine On
RewriteBase /test/

RewriteCond %{SCRIPT_FILENAME} !-f
RewriteCond %{SCRIPT_FILENAME} !-d
RewriteRule ^(.*)$ index.php/$1 [L,QSA]
```

For **nginx**, add an equivalent rule inside the relevant `server` (or `location`) block:

```nginx
location /test/ {
    try_files $uri $uri/ /test/index.php?$query_string;
}

location ~ \.php$ {
    fastcgi_pass   unix:/var/run/php/php-fpm.sock;
    fastcgi_index  index.php;
    fastcgi_param  SCRIPT_FILENAME $document_root$fastcgi_script_name;
    include        fastcgi_params;
}
```

And with that, your pretty URLs will be supported.

<br/>

# Configuration

Ensure you have a `rose-env` file on the root of this project with the name of the appropriate configuration environment to use (i.e. `dev`, `prod`, etc). Rose will load the `dev.conf`, `prod.conf` or whichever file you specify (along with `system.conf` by default) from the `conf` folder. Edit the conf files to reflect the configuration of your system.

_Note that the `rose-env` file should not be commited to ensure it is never overwritten in destination servers._

### Database

The database is configured by setting the appropriate values in the `[Database]` section of `system.conf` (or your environment-specific override). For the full list of accepted fields and driver-specific options, see the [Configuration Reference](https://github.com/rsthn/rose-core/blob/master/docs/CONFIG.md) in rose-core.

<br/>

# API Interaction

The service provided by this project is compliant with Wind, more information about it can be found in the [Wind](https://github.com/rsthn/rose-core/blob/master/Wind.md) API behavior documentation.

- The root folder for all API functions (`.fn` files) is `fn` because Wind is the Rose service that will take care of the API interaction.
- The `f` request parameter indicates the name of the function to execute, this parameter can have only the characters `[#A-Za-z0-9.,_-]`, any other character will be removed.
- The dot `.` character is used as path separator, therefore invoking `sys.users.add` will cause Wind to load the `fn/sys/users/add.fn` file.

### Placing your `.fn` files

You can place `.fn` files anywhere inside the `fn` folder. For example, a file at `fn/a/b/action.fn` can be invoked as either:

- **Query-based:** `?f=a.b.action`
- **Path-based:** `/a/b/action` (requires the rewrite rule shown above)

The HTTP verb (`GET`, `POST`, `PUT`, `DELETE`, etc.) does not affect routing — every verb arrives at the same `.fn` file, and you decide inside the file whether to filter or branch on it. The current verb is available via `gateway.method` (see the rose-core [docs/README.md](https://github.com/rsthn/rose-core/blob/master/docs/README.md) for details).

If you need explicit per-verb routing (e.g. only `POST` may hit a function), use the `[endpoints]` configuration section instead. Each entry maps an HTTP verb and path pattern to a handler:

```ini
[endpoints]
GET  \users          = api\users:list
GET  \users\{id}     = api\users:get
POST \users          = api\users:create
*    /health         = lib/health
```

`{id}` captures a path segment and exposes it to the handler, and `*` matches any verb. Multiple space-separated handlers can be chained so earlier ones act as middleware (auth, validation) and the last one's response is returned to the client. See the [Configuration Reference](https://github.com/rsthn/rose-core/blob/master/docs/CONFIG.md) in rose-core for the full syntax.

### Wind responses

Every Wind response is JSON and includes a mandatory integer `response` field. The standard codes are:

| Code | Name | Meaning |
|------|------|---------|
| 200 | OK | Request completed without errors. |
| 400 | BAD_REQUEST | The function name in `f` could not be resolved. |
| 401 | UNAUTHORIZED | Function requires an authenticated user. |
| 403 | FORBIDDEN | Caller is missing a required permission. |
| 404 | NOT_FOUND | Requested resource not found. |
| 405 | METHOD_NOT_ALLOWED | HTTP verb not allowed by the function. |
| 422 | VALIDATION_ERROR | One or more parameters failed validation; offending fields are listed under `fields`. |
| 409 | CUSTOM_ERROR | Custom error; the message is returned in `error`. |

Wind also supports a **multi-request mode** via the `rpkg` parameter, which lets you batch several calls into one HTTP round-trip. See [Wind.md](https://github.com/rsthn/rose-core/blob/master/Wind.md) for the full specification, including data-source conventions (`add` / `update` / `count` / `list` / `get` / `delete` / `enum`).

<br/>

# Writing Your First Function

A `.fn` file is a [Violet](https://github.com/rsthn/rose-core/blob/master/docs/README.md) expression. The value of the last expression evaluated in the file becomes the response body — Wind automatically wraps it with `"response": 200` unless you set one explicitly.

Create a new file at `fn/hello.fn`:

```lisp
{
    message "Hello, world!"
    server_time (datetime:now)
}
```

Invoke it via either of the two routes:

- Query-based: `http://localhost/test/?f=hello`
- Path-based: `http://localhost/test/hello` (with the rewrite rule from *Quick Test*)

The response will be:

```json
{
    "response": 200,
    "message": "Hello, world!",
    "server_time": "2026-04-29 10:00:00"
}
```

### Reading request input

Use [shield](https://github.com/rsthn/rose-ext-shield/blob/master/README.md) to require a verb and validate parameters. Save this as `fn/echo.fn`:

```lisp
(shield:method-required "POST")
(shield:body-required)

(shield:validate-data input (gateway.body) (object
    name (rules
        required true
        expected string
        max-length 64
    )
))

{
    greeting (concat "Hello, " (input.name) "!")
}
```

Anything other than `POST` (or a missing/invalid `name`) is rejected automatically with a `405` or `422` Wind response.

<br/>

# Authentication

Sentinel provides login and permission checks. Once configured (see the [Sentinel README](https://github.com/rsthn/rose-ext-sentinel/blob/master/README.md) for the required tables and the `[Sentinel]` config section), protect any function by adding a single line at the top:

```lisp
; Require an authenticated user — fails with 401 otherwise.
(sentinel:auth-required)

; Or require a specific permission set — fails with 401 / 403.
(sentinel:permission-required "admin | editor")

{
    secret "only logged-in users see this"
}
```

A typical login flow uses `sentinel:login` (username + password) or `sentinel:authorize` (bearer token, requires `auth_bearer = true` in the Sentinel config). The skeleton already ships with working examples under `fn/auth/` (`login.fn`, `logout.fn`, etc.) — read those for a complete reference.

<br/>

# Dependencies

The following extensions are installed with this project:

- [rsthn/rose-ext-sentinel](https://github.com/rsthn/rose-ext-sentinel/blob/master/README.md)
- [rsthn/rose-ext-shield](https://github.com/rsthn/rose-ext-shield/blob/master/README.md)
