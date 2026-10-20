#!/bin/bash
{ echo x; }
{
  echo y
}
{ echo a; echo b; }
{ }
{ echo x; } | cat
