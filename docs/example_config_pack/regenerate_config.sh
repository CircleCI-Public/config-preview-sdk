#! /bin/bash

set -e

circleci config pack .circleci/template > .circleci/config.yml
