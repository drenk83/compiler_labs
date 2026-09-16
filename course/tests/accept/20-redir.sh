#!/bin/bash
echo a > /tmp/f
echo b >> /tmp/f
cat < /tmp/f
ls 2> /tmp/e
ls 2>&1
ls 2> /tmp/e | cat
