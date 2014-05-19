#!/bin/sh

dd if=/dev/urandom of=test.plain count=1 bs=128
openssl enc -aes-128-cbc -nosalt -nopad -engine cryptodev -in test.plain -out test.cipher -k key

echo "=========="

diff test.plain test.cipher &> /dev/null

if [ $? -eq 0 ]
then
  echo -e "\e[0;32mOK\e[0m"
else
  echo -e "\e[0;31mFail\e[0m"
  exit 1
fi

