#!/bin/bash
name="World"
count=0
if [ $# -lt 1 ]; then echo usage; fi
echo $name | wc -l > /tmp/out
greet() {
  local name="$1"
  echo ${name}
}
for item in a b; do greet $item; done
case $item in
a|b) echo ok ;;
*) echo other ;;
esac
