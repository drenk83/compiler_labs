#!/bin/bash
if true; then echo x; fi
if grep -q x "$file"; then
  echo found
fi
if echo a | grep a; then echo ok; fi
if true && false; then echo ok; fi
if [ "$1" = a ]
then echo x
fi
if true; then echo a; elif false; then echo b; else echo c; fi
while true; do echo x; done
until true; do echo x; done
if { echo x; }; then echo ok; fi
