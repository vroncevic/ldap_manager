<img align="right" src="https://raw.githubusercontent.com/vroncevic/ldap_manager/dev/docs/ldap_manager_logo.png" width="25%">

# Shell script for openLDAP management

**ldap_manager** is shell tool for control/operating ldap server.

Developed in **[bash](https://en.wikipedia.org/wiki/Bash_(Unix_shell))** code: **100%**.

[![ldap_manager shell checker](https://github.com/vroncevic/ldap_manager/workflows/ldap_manager%20shell%20checker/badge.svg)](https://github.com/vroncevic/ldap_manager/actions?query=workflow%3A%22ldap_manager+shell+checker%22)

The README is used to introduce the modules and provide instructions on
how to install the modules, any machine dependencies it may have and any
other information that should be provided before the modules are installed.

[![GitHub issues open](https://img.shields.io/github/issues/vroncevic/ldap_manager.svg)](https://github.com/vroncevic/ldap_manager/issues) [![GitHub contributors](https://img.shields.io/github/contributors/vroncevic/ldap_manager.svg)](https://github.com/vroncevic/ldap_manager/graphs/contributors)

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**

- [Installation](#installation)
- [Usage](#usage)
- [Dependencies](#dependencies)
- [Shell tool structure](#shell-tool-structure)
- [Docs](#docs)
- [Copyright and licence](#copyright-and-licence)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

### Installation

![Debian Linux OS](https://raw.githubusercontent.com/vroncevic/ldap_manager/dev/docs/debtux.png)

Navigate to release **[page](https://github.com/vroncevic/ldap_manager/releases)** download and extract release archive.

To install **ldap_manager** type the following

```
tar xvzf ldap_manager-x.y.tar.gz
cd ldap_manager-x.y
cp -R ~/sh_tool/bin/   /root/scripts/ldap_manager/ver.x.y/
cp -R ~/sh_tool/conf/  /root/scripts/ldap_manager/ver.x.y/
cp -R ~/sh_tool/log/   /root/scripts/ldap_manager/ver.x.y/
```

Self generated setup script and execution
```
./ldap_manager_setup.sh

[setup] installing App/Tool/Script ldap_manager
	Tue 30 Nov 2021 08:46:52 PM CET
[setup] clean up App/Tool/Script structure
[setup] copy App/Tool/Script structure
[setup] remove github editor configuration files
[setup] set App/Tool/Script permission
[setup] create symbolic link of App/Tool/Script
[setup] done

/root/scripts/ldap_manager/ver.2.0/
├── bin/
│   ├── center.sh
│   ├── display_logo.sh
│   ├── ldap_manager.sh
│   ├── openldap_operation.sh
│   └── openldap_version.sh
├── conf/
│   ├── ldap_manager.cfg
│   ├── ldap_manager.logo
│   └── ldap_manager_util.cfg
└── log/
    └── ldap_manager.log

3 directories, 9 files
lrwxrwxrwx 1 root root 54 Nov 30 20:46 /root/bin/ldap_manager -> /root/scripts/ldap_manager/ver.2.0/bin/ldap_manager.sh
```

Or You can use docker to create image/container.

[![ldap_manager docker checker](https://github.com/vroncevic/ldap_manager/workflows/ldap_manager%20docker%20checker/badge.svg)](https://github.com/vroncevic/ldap_manager/actions?query=workflow%3A%22ldap_manager+docker+checker%22)

### Usage

```
# Create symlink for shell tool
ln -s /root/scripts/ldap_manager/ver.x.y/bin/ldap_manager.sh /root/bin/ldap_manager

# Setting PATH
export PATH=${PATH}:/root/bin/

# Control/operating ldap server
ldap_manager

ldap_manager ver.2.0
Tue 30 Nov 2021 08:48:16 PM CET

[check_root] Check permission for current session? [ok]
[check_root] Done

	                                                                   
	 _     _                                                           
	| | __| | __ _ _ __    _ __ ___   __ _ _ __   __ _  __ _  ___ _ __ 
	| |/ _` |/ _` | '_ \  | '_ ` _ \ / _` | '_ \ / _` |/ _` |/ _ \ '__|
	| | (_| | (_| | |_) | | | | | | | (_| | | | | (_| | (_| |  __/ |   
	|_|\__,_|\__,_| .__/  |_| |_| |_|\__,_|_| |_|\__,_|\__, |\___|_|   
	              |_|                                  |___/           
	                                                                   
		Info   github.io/ldap_manager ver.2.0 
		Issue  github.io/issue
		Author vroncevic.github.io

  [USAGE] ldap_manager [OPTIONS]
  [OPTIONS]
  [OPERATION] start | stop | restart | status | version
  # Restart openLDAP Server
  ldap_manager restart
  [help | h] print this option
```

### Dependencies

**ldap_manager** requires next modules and libraries
* sh_util [https://github.com/vroncevic/sh_util](https://github.com/vroncevic/sh_util)

### Shell tool structure

**ldap_manager** is based on MOP.

Shell tool structure
```
sh_tool/
├── bin/
│   ├── center.sh
│   ├── display_logo.sh
│   ├── ldap_manager.sh
│   ├── openldap_operation.sh
│   └── openldap_version.sh
├── conf/
│   ├── ldap_manager.cfg
│   ├── ldap_manager.logo
│   └── ldap_manager_util.cfg
└── log/
    └── ldap_manager.log
```

### Docs

[![Documentation Status](https://readthedocs.org/projects/ldap_manager/badge/?version=latest)](https://ldap_manager.readthedocs.io/projects/ldap_manager/en/latest/?badge=latest)

More documentation and info at
* [https://ldap_manager.readthedocs.io/en/latest/](https://ldap_manager.readthedocs.io/en/latest/)
* [https://www.gnu.org/software/bash/manual/](https://www.gnu.org/software/bash/manual/)

### Copyright and licence

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0) [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

Copyright (C) 2016 by [vroncevic.github.io/ldap_manager](https://vroncevic.github.io/ldap_manager)

**ldap_manager** is free software; you can redistribute it and/or modify
it under the same terms as Bash itself, either Bash version 4.2.47 or,
at your option, any later version of Bash 4 you may have available.

Lets help and support FSF.

[![Free Software Foundation](https://raw.githubusercontent.com/vroncevic/ldap_manager/dev/docs/fsf-logo_1.png)](https://my.fsf.org/)

[![Donate](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://my.fsf.org/donate/)
