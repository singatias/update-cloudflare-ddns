#!/bin/sh

sh /app/update_dns.sh
crond -b

tail -f /dev/null
