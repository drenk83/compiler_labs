#!/bin/bash
[ -n "$1" ]
[ -f "$1" ] > /tmp/f
[ -f "$1" ] 2> "$err"
if [ -f "$1" ] > /tmp/f; then
  echo ok
fi
while [ -n "$1" ] 2>&1; do
  echo x
done
until [ -n "$1" ] >> /tmp/f; do
  echo x
done
