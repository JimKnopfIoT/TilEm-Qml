#!/bin/bash
git clone -b cmake https://github.com/labsin/TilEm.git tilem-core || (cd tilem-core && git checkout cmake && git pull)
git clone -b master https://github.com/labsin/QmlUtilsPlugin.git backend/modules/Utils || (cd backend/modules/Utils && git checkout master && git pull)
