#!/usr/bin/env bash

function build() {
  docker compose build
}

function test() {
	export VAR_ARG="$1"
	export VAR_ENV="$2"
	docker compose run --rm test

  if [ $? != 0 ]; then
    echo "[FAIL] ARG '$1' ENV '$2'"
  fi
}

build
test "http://localhost:8080/healthz" ""
test "/healthz" ""
test "/healthz" "http://+:80"
test "/healthz" "http://+:8080;http://+:80"
test "/healthz" "http://%:8080"
