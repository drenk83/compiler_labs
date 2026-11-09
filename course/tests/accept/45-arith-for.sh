#!/bin/bash
for ((i = 0; i < 3; i++)); do
  echo $i
done
for ((i=0; i<10; i++)); do
  echo x
done
for ((;;)); do
  echo y
done
for ((i=0; i>0; i++)) do
  echo z
done
