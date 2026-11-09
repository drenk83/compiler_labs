#!/bin/bash
arr=(a b c)
arr+=(d)
arr+=x
arr[i]=value
arr[0]=value
declare -a arr=(1 2 3)
a=1 arr=(b c)
arr=(x) b=2
arr=(a b) echo x
arr=()
f() {
  local -a lines=()
  local arr=(a b)
}
