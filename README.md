# simple-centos7

This cookbook contains a recipe to turn on the minimal amount of security for a publicly accessible CentOS 7 machine.

The recipe is derived from a [tutorial](https://www.digitalocean.com/community/tutorial_series/new-centos-7-server-checklist)
by DigitalOcean.

# Requirements

This project requires the [chef-dk](https://downloads.chef.io/chef-dk/) to test the recipe locally.

# Testing

Out of the box, this repository can be tested via `kitchen converge`.

# Creating own username and password

Default values are placed in [developer.json](data_bags/users/developer.json) for a username and password.  These
can be changed for your own needs.

## Password

To create the [password shadow hash](https://docs.chef.io/resources.html#password-shadow-hash), you will want to

* generate a [random salt](http://stackoverflow.com/q/11520126/698839)
* use openssl to [generate the password](http://www.openssl.org/docs/manmaster/apps/passwd.html) shadow hash

For example, using node.js

```
local$ node
node> var crypto = require('crypto')
node> crypto.randomBytes(128).toString('base64').substr(0, 8)
'4iFZ5+AT'
local$ openssl passwd -1 -salt '4iFZ5+AT' 'mypassword'
$1$4iFZ5+AT$LBDbnn0fs2B6ZpwW0o9gj1
```

And place `$1$4iFZ5+AT$LBDbnn0fs2B6ZpwW0o9gj1` as the value for the `password_shadow_hash` key in `developer.json`. 
