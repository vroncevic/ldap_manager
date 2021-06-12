ldap_manager
-------------

**ldap_manager** is shell tool for control/operating ldap server.

Developed in `bash <https://en.wikipedia.org/wiki/Bash_(Unix_shell)>`_ code: **100%**.

|GitHub shell checker|

.. |GitHub shell checker| image:: https://github.com/vroncevic/ldap_manager/workflows/ldap_manager%20shell%20checker/badge.svg
   :target: https://github.com/vroncevic/ldap_manager/actions?query=workflow%3A%22ldap_manager+shell+checker%22

The README is used to introduce the tool and provide instructions on
how to install the tool, any machine dependencies it may have and any
other information that should be provided before the tool is installed.

|GitHub issues| |Documentation Status| |GitHub contributors|

.. |GitHub issues| image:: https://img.shields.io/github/issues/vroncevic/ldap_manager.svg
   :target: https://github.com/vroncevic/ldap_manager/issues

.. |GitHub contributors| image:: https://img.shields.io/github/contributors/vroncevic/ldap_manager.svg
   :target: https://github.com/vroncevic/ldap_manager/graphs/contributors

.. |Documentation Status| image:: https://readthedocs.org/projects/ldap_manager/badge/?version=latest
   :target: https://ldap_manager.readthedocs.io/projects/ldap_manager/en/latest/?badge=latest

.. toctree::
    :hidden:

    self

Installation
-------------

Navigate to release `page`_ download and extract release archive.

.. _page: https://github.com/vroncevic/ldap_manager/releases

To install **ldap_manager** type the following:

.. code-block:: bash

   tar xvzf ldap_manager-x.y.tar.gz
   cd ldap_manager-x.y
   cp -R ~/sh_tool/bin/   /root/scripts/ldap_manager/ver.x.y/
   cp -R ~/sh_tool/conf/  /root/scripts/ldap_manager/ver.x.y/
   cp -R ~/sh_tool/log/   /root/scripts/ldap_manager/ver.x.y/

Or You can use Docker to create image/container.

|GitHub docker checker|

.. |GitHub docker checker| image:: https://github.com/vroncevic/ldap_manager/workflows/ldap_manager%20docker%20checker/badge.svg
   :target: https://github.com/vroncevic/ldap_manager/actions?query=workflow%3A%22ldap_manager+docker+checker%22

Dependencies
-------------

**ldap_manager** requires next modules and libraries:

* sh_util `https://github.com/vroncevic/sh_util <https://github.com/vroncevic/sh_util>`_

Shell tool structure
---------------------

**ldap_manager** is based on MOP.

Code structure:

.. code-block:: bash

   sh_tool/
   ├── bin/
   │   ├── ldap_manager.sh
   │   ├── openldap_operation.sh
   │   └── openldap_version.sh
   ├── conf/
   │   ├── ldap_manager.cfg
   │   └── ldap_manager_util.cfg
   └── log/
       └── ldap_manager.log

Copyright and licence
----------------------

|License: GPL v3| |License: Apache 2.0|

.. |License: GPL v3| image:: https://img.shields.io/badge/License-GPLv3-blue.svg
   :target: https://www.gnu.org/licenses/gpl-3.0

.. |License: Apache 2.0| image:: https://img.shields.io/badge/License-Apache%202.0-blue.svg
   :target: https://opensource.org/licenses/Apache-2.0

Copyright (C) 2016 by `vroncevic.github.io/ldap_manager <https://vroncevic.github.io/ldap_manager>`_

**ldap_manager** is free software; you can redistribute it and/or modify it
under the same terms as Bash itself, either Bash version 4.2.47 or,
at your option, any later version of Bash 4 you may have available.

Lets help and support FSF.

|Free Software Foundation|

.. |Free Software Foundation| image:: https://raw.githubusercontent.com/vroncevic/ldap_manager/dev/docs/fsf-logo_1.png
   :target: https://my.fsf.org/

|Donate|

.. |Donate| image:: https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif
   :target: https://my.fsf.org/donate/

Indices and tables
------------------

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`
