#!/bin/bash
"echo" hello
'echo' hello
$cmd hello
$(echo echo) hello
# Имя — подстановка. Арифметика здесь не вычисляется.
$((count + 1))
