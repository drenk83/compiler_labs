#!/bin/bash
# весь язык, принимаемый файл

# пустые строки


# простые команды
echo hello
apt-get --help
chmod +x a.out
echo foo/bar
echo *.txt
echo -lt --help +x 2
echo foo#bar
echo FOO=1

# таб как пробел
echo	a	b

# точка с запятой
echo a;
echo b; echo c;

# строки
echo ""
echo ''
echo "a b"
echo 'a b'
echo "quote \""
echo "back \\ slash"
echo "it's a string"
echo '"quoted"'
echo "Hello, $name!"
echo '$# not expansion'

# присваивания
name="World"
count=0
path=/tmp/a
empty=
s='single'
name=$1
braced=${name}
from_sub=$(date +%Y-%m-%d)
_private=1
A1=x

# подстановки
echo $name
echo $1
echo $12
echo $#
echo $@
echo $*
echo $$
echo $?
echo ${name}
echo $name $1 $# $@ $* $$ $? ${name}

# подстановка команды
current_date=$(date +%Y-%m-%d)
echo $current_date
x=$(echo $(echo a))
empty_sub=$()
y=$(
  ls | cat
)
z=$(
  if [ $# -lt 1 ]; then
    echo none
  fi
)

# команда [
[ ]
[ $# -lt 2 ]
[ -f /tmp/f ]
[ -z "$s" ]
[ "$1" = a ]

# редиректы
echo a > /tmp/f
echo b >> /tmp/f
cat < /tmp/f
ls 2> /tmp/e
ls 2>&1
cat < /tmp/in > /tmp/out 2> /tmp/err
echo mixed > /tmp/out 2>&1
ls 2> /tmp/e | cat
echo $name | wc -l > /tmp/out

# конвейер
ls | sort
echo a | cat | cat
echo a |
cat

# и / или
true && echo ok
false || echo fallback
true && echo a || echo b
true &&
echo ok
false ||
echo fallback

# фон
echo a &
echo b
true && echo c &

# if
if [ $# -lt 2 ]; then
  echo usage
fi

if [ "$1" = a ]
then echo x
fi

if [ "$1" = a ]; then
  echo a
elif [ "$1" = b ]; then
  echo b
else
  echo other
fi

if [ "$1" = a ]; then
  echo a
elif [ "$1" = b ]; then
  echo b
elif [ "$1" = c ]; then
  echo c
else
  echo other
fi

# вложенный if
if [ "$1" = a ]; then
  if [ "$2" = b ]; then
    echo ab
  fi
fi

# while и until
while [ $count -lt 3 ]; do
  echo $count
done

while [ $count -lt 3 ]
do
  echo $count
done

until [ $count -ge 3 ]; do
  echo $count
done

until [ $count -ge 3 ]
do
  echo $count
done

# for
for item in a b c; do
  echo $item
done

for item in a b c
do
  echo $item
done

for item in "$1" *.txt foo/bar; do
  echo $item
done

for item in; do
  echo empty
done

# case
case $item in
a|b)
  echo ab
  ;;
*)
  echo other
  ;;
esac

case "$1" in
a|b|"c"|*.txt) echo matched ;;
'lit') echo lit ;;
*) echo other ;;
esac

case x in
esac

# функции
greet() {
  echo "$1"
}
name() { echo x; }

noop() {
}

greet()
{
  echo x
}

function greet {
  echo hello
}

function greet() {
  echo hello
}

function greet
{
  echo hello
}

# функция внутри функции
wrapper() {
  inner() {
    echo nested
  }
  inner
}

# local
f() {
  local name
  local name="$1"
  local a b=1
  local _x
  local name=$1
}

local top_level

# всё вместе
drive() {
  local acc=0
  while [ $acc -lt 3 ]; do
    for item in a b; do
      if [ "$item" = a ]; then
        echo $item | cat
      elif [ "$item" = b ]; then
        case $item in
        b) echo b ;;
        *) echo other ;;
        esac
      else
        echo miss
      fi
    done
    until [ $acc -ge 3 ]; do
      echo $acc
    done
  done
}

echo ok # комментарий в конце строки
