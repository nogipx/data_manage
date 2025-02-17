fvm flutter test --coverage --coverage-path coverage/lcov.temp.info

lcov --remove ./coverage/lcov.temp.info -o ./coverage/lcov.info \
    'lib/core/routes/*' \
    'packages/*' \
    'scripts/*' \

genhtml ./coverage/lcov.info --output=coverage/html

rm coverage/lcov.temp.info

open ./coverage/html/index.html
