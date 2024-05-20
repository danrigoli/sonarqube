#!/bin/bash
set -e

DEFAULT_CMD=('/opt/java/openjdk/bin/java' '-jar' 'lib/sonarqube.jar' '-Dsonar.log.console=true')

# Wait for PostgreSQL to be ready
until pg_isready -h db -p 5432 -U sonar; do
  >&2 echo "PostgreSQL is unavailable - sleeping"
  sleep 1
done

>&2 echo "PostgreSQL is up - executing command"

# this if will check if the first argument is a flag
# but only works if all arguments require a hyphenated flag
# -v; -SL; -f arg; etc will work, but not arg1 arg2
if [ "$#" -eq 0 ] || [ "${1#-}" != "$1" ]; then
    set -- "${DEFAULT_CMD[@]}" "$@"
fi

exec "$@"
