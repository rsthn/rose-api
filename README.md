# Rose API Project Skeleton

This repository contains a sample project to use as skeleton to build APIs with Rose to be fully compliant with [Wind](https://github.com/rsthn/rose-core/blob/master/Wind.md). Install using composer:

```sh
composer create-project rsthn/rose-api <target-directory>
```

After installation edit your `composer.json` file to reflect your own project details.

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

And with that, your pretty URLs will be supported.

<br/>

# Configuration

Ensure you have a `rose-env` file on the root of this project with the name of the appropriate configuration environment to use (i.e. `dev`, `prod`, etc). Rose will load the `dev.conf`, `prod.conf` or whichever file you specify (along with `system.conf` by default) from the `conf` folder. Edit the conf files to reflect the configuration of your system.

_Note that the `rose-env` file should not be commited to ensure it is never overwritten in destination servers._

<br/>

# API Interaction

The service provided by this project is compliant with Wind, more information about it can be found in the [Wind](https://github.com/rsthn/rose-core/blob/master/Wind.md) API behavior documentation.

- The root folder for all API functions (`.fn` files) is `fn` because Wind is the Rose service that will take care of the API interaction.
- The `f` request parameter indicates the name of the function to execute, this parameter can have only the characters `[#A-Za-z0-9.,_-]`, any other character will be removed.
- The dot `.` character is used as path separator, therefore invoking `sys.users.add` will cause Wind to load the `fn/sys/users/add.fn` file.

<br/>

# Dependencies

The following extensions are installed with this project:

- [rsthn/rose-ext-sentinel](https://github.com/rsthn/rose-ext-sentinel)
- [rsthn/rose-ext-shield](https://github.com/rsthn/rose-ext-shield/)
