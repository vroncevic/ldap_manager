# Shell script for openLDAP management.

**ldap_manager** is shell tool for control/operating ldap server.

Developed in [bash](https://en.wikipedia.org/wiki/Bash_(Unix_shell)) code: **100%**.

The README is used to introduce the modules and provide instructions on
how to install the modules, any machine dependencies it may have and any
other information that should be provided before the modules are installed.

[![GitHub issues open](https://img.shields.io/github/issues/vroncevic/ldap_manager.svg)](https://github.com/vroncevic/ldap_manager/issues)
 [![GitHub contributors](https://img.shields.io/github/contributors/vroncevic/ldap_manager.svg)](https://github.com/vroncevic/ldap_manager/graphs/contributors)

<!-- START doctoc -->
**Table of Contents**

- [Installation](#installation)
- [Usage](#usage)
- [Dependencies](#dependencies)
- [Shell tool structure](#shell-tool-structure)
- [Docs](#docs)
- [Copyright and Licence](#copyright-and-licence)
<!-- END doctoc -->

### INSTALLATION

Navigate to release [page](https://github.com/vroncevic/ldap_manager/releases) download and extract release archive.

To install **ldap_manager** type the following:

```
tar xvzf ldap_manager-x.y.z.tar.gz
cd ldap_manager-x.y.z
cp -R ~/sh_tool/bin/   /root/scripts/ldap_manager/ver.1.0/
cp -R ~/sh_tool/conf/  /root/scripts/ldap_manager/ver.1.0/
cp -R ~/sh_tool/log/   /root/scripts/ldap_manager/ver.1.0/
```

![alt tag](https://raw.githubusercontent.com/vroncevic/ldap_manager/dev/docs/setup_tree.png)
Or You can use docker to create image/container.

### USAGE

```
# Create symlink for shell tool
ln -s /root/scripts/ldap_manager/ver.1.0/bin/ldap_manager.sh /root/bin/ldap_manager

# Setting PATH
export PATH=${PATH}:/root/bin/

# Control/operating ldap server
ldap_manager version
```

### DEPENDENCIES

**ldap_manager** requires next modules and libraries:
* sh_util [https://github.com/vroncevic/sh_util](https://github.com/vroncevic/sh_util)

### SHELL TOOL STRUCTURE

**ldap_manager** is based on MOP.

Code structure:
```
.
├── bin/
│   ├── ldap_manager.sh
│   ├── openldap_operation.sh
│   └── openldap_version.sh
├── conf/
│   ├── ldap_manager.cfg
│   └── ldap_manager_util.cfg
└── log/
    └── ldap_manager.log
```

### DOCS

[![Documentation Status](https://readthedocs.org/projects/ldap_manager/badge/?version=latest)](https://ldap_manager.readthedocs.io/projects/ldap_manager/en/latest/?badge=latest)

More documentation and info at:
* [https://ldap_manager.readthedocs.io/en/latest/](https://ldap_manager.readthedocs.io/en/latest/)
* [https://www.gnu.org/software/bash/manual/](https://www.gnu.org/software/bash/manual/)

### COPYRIGHT AND LICENCE

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0) [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

Copyright (C) 2015 by [vroncevic.github.io/ldap_manager](https://vroncevic.github.io/ldap_manager)

This tool is free software; you can redistribute it and/or modify
it under the same terms as Bash itself, either Bash version 4.2.47 or,
at your option, any later version of Bash 4 you may have available.

