#!/bin/bash
{ echo x; } > /tmp/f
{ echo x; } >> /tmp/f
( echo y ) < /tmp/f
( echo y ) > /tmp/f
if [ -n "$1" ]; then echo x; fi > /tmp/f
while [ -n "$1" ]; do echo x; done > /tmp/f
until [ -n "$1" ]; do echo x; done 2> /tmp/f
for item; do echo $item; done > /tmp/f
for item in a; do echo $item; done > /tmp/f
select item; do echo $item; done 2>&1
case $item in
  a) echo a ;;
esac > /tmp/f
