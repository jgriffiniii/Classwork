#!/bin/bash 
export JAVA_HOME=`/usr/libexec/java_home -v 1.7`
here="${0%/*}"
cd "${here}"
cd ../Resources/sqldeveloper/sqldeveloper/bin
bash ./sqldeveloper >>/dev/null
