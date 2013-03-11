# knife-dishwasher

A Chef::Knife plugin which helps you find unused roles and cookbooks in your
Chef server..

# Installation

## SCRIPT INSTALL

Copy dishwasher.rb script from lib/chef/knife to your ~/.chef/plugins/knife directory.

Dishwasher Roles
----------------

This function returns a list of roles which exist in your Chef server which
have no nodes associated with them.

#### Usage
```bash
knife dishwasher roles
```

Dishwasher Cookbooks
--------------------

This function returns a list of cookbooks from which no nodes use any recipes.

#### Usage
```bash
knife dishwasher cookbooks
```

## Bugs
It's really, really slow.
