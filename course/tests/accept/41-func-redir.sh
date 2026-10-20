#!/bin/bash
greet() { echo hi; } > /tmp/out
function greet { echo hi; } >> /tmp/out
function greet() { echo hi; } 2> /tmp/out
greet() { echo hi; }
