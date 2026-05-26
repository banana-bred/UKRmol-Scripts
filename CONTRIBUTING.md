Contributing
============

Tests
-----

Currently only MultiSpace.pm has a test suite, although tests should be 
extended to the rest of the scripts in the future.

If changes are made to MultiSpace.pm please run tests before making commits, 
and if new features are added new tests should be added to t/ if possible.

First specify the location of the UKRmol+ inner region test suite.

```
$ export UKRMOLP_TEST_SUITE=/path/to/UKRmol-in/tests/suite
```

Tests can then be run by,

```
$ prove -lv
```

in the repository root directory.