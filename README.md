
TilEm-Qml
=========


Cloning
-------

    git clone https://github.com/labsin/TilEm-Qml.git --recursive

Build Dependencies
------------

Are listed as packages on Ubuntu.

*   libglib2.0-dev
*   libticonv-dev
*   libticalcs-dev
*   libgdk-pixbuf2.0-dev

Build instructions
------------------

    mkdir build
    cd build
    cmake ../build
    make

To build a click package or:

*   CLI:
    *   mkdir build
    *   cd build
    *   cmake -DCLICK_MODE:bool=true ../build
    *   make DESTDIR=./click
    *   click build ./click
*   Ubuntu SDK:
    *   Open project
    *   Run cmake with "-DCLICK_MODE:bool=true" as cmake arguments
    *   Do everything you would normally do in the SDK

To run inside build dir:

    make run

TODO
----

...
