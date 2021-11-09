#!/bin/sh -l

DIR="/anonymize/database"

#if [[ "${START}" == "true" ]]; then
  /bin/masquerade run --platform=$PLATFORM --database=$DATABASE --username=$USERNAME --password=$PASSWORD --host=$DB_HOST --port=$PORT
#fi

