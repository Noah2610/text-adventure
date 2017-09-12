#!/bin/bash
wc ./main.rb ./test.rb $(find ./src/ -type f) $(find ./text/ -type f)
