# Rose Web Service - Project Skeleton

This repository contains a sample project to use as skeleton to build web services with Rose and its internal extension Wind. Install using composer:

```sh
composer create-project rsthn/rose-webservice <target-directory>
```

After installation edit your `composer.json` file to reflect your own project details.

<br/>

## Quick Test

Let's assume you installed the project in a folder named `test`, open your browser and navigate to `http://localhost/test/`, if everything is fine you should see the JSON result, as follows:

```json
{
	"response": 200,
	"message": "@messages.service_operational"
}
```

There is also another API function named `now`, if you navigate to `http://localhost/test/?f=now` the result should be:

```json
{
	"response": 200,
	"message": "Current date and time is: 2021-02-03 08:39:29"
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

And with that, your pretty URLs will be supported.

<br/>

# Configuration

Ensure you have a `rose-env` file on the root of this project with the name of the appropriate configuration environment to use (i.e. `dev`, `prod`, etc). Rose will load the `dev.conf`, `prod.conf` or whichever file you specify (along with `system.conf` by default) from the `rcore` folder. Additionally, edit the `rcore/*.conf` files to reflect the configuration of your system.

_Note that the `rose-env` file should not be commited to ensure it is never overwritten in destination servers._

<br/>

# API Interaction

## Requests

Requests can be sent with either HTTP method (GET or POST) to the API end-point (where you installed this project), with the `Content-Type` header set to `application/x-www-form-urlencoded` or `multipart/form-data` (if files are uploaded to the service).

- The root folder for all API functions (`.fn` files) is `rcore/wind` because Wind is the Rose service that will take care of the web-service interaction.
- The `f` request parameter indicates the name of the function to execute, this parameter can have only the characters `[#A-Za-z0-9.,_-]`, any other character will be removed.
- The dot `.` character is used as path separator, therefore invoking `sys.users.add` will cause Wind to load the `rcore/wind/sys/users/add.fn` file.

&nbsp;
## Responses

Firstly, responses are always a JSON object (unless otherwise explicitly specified) with a mandatory integer field named `response` which indicates the response code. Wind describes several standard response codes as follows:

|Response Code|Short Name|Details|
|-------------|----------|-----------|
|200|R_OK|Everything was completed without errors.
|400|R_FUNCTION_NOT_FOUND|The respective file for the function name in parameter `f` was not found.
|403|R_PRIVILEGE_REQUIRED|Function requires the invoker to have certain privilege (i.e. `admin`).
|404|R_NOT_FOUND|A requested resource could not be found.
|407|R_VALIDATION_ERROR|One or more request fields did not pass validation checks. A field named `fields` will be found in the response, this is an object with the offending request parameter name(s) and their respective error message.
|408|R_NOT_AUTHENTICATED|Function requires the invoker to be an authenticated user.
|409|R_CUSTOM_ERROR|A field named `error` in the response will have the complete error message.

&nbsp;
## Multi-Request Mode

This mode can be used to run multiple requests (up to 16) in a single web-request. To use this feature use the `rpkg` parameter which is a list of semi-colon separated `id,data` pairs, where `id` is the name you want the response to have when returned, and `data` is the Base64 encoded request parameters.

For example, consider the following value for `rpkg`:

```
r0,Zj11c2Vycy5jb3VudA==;r1,Zj11c2Vycy5saXN0;
```

- It describes two requests, `r0` and `r1`.
- The first request (r0) has parameters `f=users.count` (obtained by Base64 decoding the data),
- And the second one (r1) has parameters `f=users.list`.

This effectively causes Wind to execute functions `users.count` and `users.list` (let's assume the first returns count=1 and the second returns an array with one user).

The response will be returned as follows:

```json
{
  "response": 200,
  "r0": {
    "response": 200,
    "count": 1
  },
  "r1": {
    "response": 200,
    "data": [
      {"id": "1", "username": "admin", "name": "Administrator"} 
    ]
  }
}
```

Note that the result object contains the results of both calls identified respectively by their `id` (as specified manually by the invoker in the `rpkg` field). This can use useful to batch certain API calls together and reduce server round-trip times.

<br/>

# Dependencies

The following extensions are installed with this project:

- [rsthn/rose-ext-sentinel](https://github.com/rsthn/rose-ext-sentinel)
- [rsthn/rose-ext-shield](https://github.com/rsthn/rose-ext-shield/)
