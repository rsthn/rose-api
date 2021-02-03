# Rose Web Service Project Skeleton

This repository contains a sample project to use as skeleton to quickly build webservices with Rose. Install using:

```sh
composer create-project rsthn/rose-webservice <target-directory>
```

# Configuration

Ensure you have a `rose-env` file on the root of this project with the name of the appropriate configuration environment to use (i.e. `dev`, `prod`, etc). Rose will load the `dev.conf`, `prod.conf` or whichever file you specify (along with `system.conf` by default) from the `rcore` folder. Additionally, edit the `rcore/*.conf` files to reflect the configuration of your system.

_Note that the `rose-env` file should not be commited to ensure it is never overwritten in destination servers._
