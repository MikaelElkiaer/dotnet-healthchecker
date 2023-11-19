#!/usr/bin/env bats

teardown() {
  docker compose down &> /dev/null
}

@test "Absolute URI and urls port 80" {
  export ARG_PATH="http://localhost:80/healthz"
  export ENV_URLS="http://+:80"
  docker compose up --detach app &> /dev/null
  docker compose run --rm test
}

@test "Absolute URI and urls port 8080" {
  export ARG_PATH="http://localhost:8080/healthz"
  export ENV_URLS="http://+:8080"
  docker compose up --detach app &> /dev/null
  docker compose run --rm test
}

@test "Absolute URI and port 80" {
  export ARG_PATH="http://localhost:80/healthz"
  export ENV_PORTS="80"
  docker compose up --detach app &> /dev/null
  docker compose run --rm test
}

@test "Absolute URI and port 8080" {
  export ARG_PATH="http://localhost:8080/healthz"
  export ENV_PORTS="8080"
  docker compose up --detach app &> /dev/null
  docker compose run --rm test
}

@test "Relative URI and urls port 80" {
  export ARG_PATH="/healthz"
  export ENV_URLS="http://+:80"
  docker compose up --detach app &> /dev/null
  docker compose run --rm test
}

@test "Relative URI and urls port 8080" {
  export ARG_PATH="/healthz"
  export ENV_URLS="http://+:8080"
  docker compose up --detach app &> /dev/null
  docker compose run --rm test
}

@test "Relative URI and urls ports 8080 and 80" {
  export ARG_PATH="/healthz"
  export ENV_URLS="http://+:8080;http://+:80"
  docker compose up --detach app &> /dev/null
  docker compose run --rm test
}

@test "Relative URI and urls ports 80 and 8080" {
  export ARG_PATH="/healthz"
  export ENV_URLS="http://+:80;http://+:8080"
  docker compose up --detach app &> /dev/null
  docker compose run --rm test
}

@test "Default URI and urls port 8080" {
  export ENV_URLS="http://+:8080"
  docker compose up --detach app &> /dev/null
  docker compose run --rm test
}

@test "Default URI and urls port 80" {
  export ENV_URLS="http://+:80"
  docker compose up --detach app &> /dev/null
  docker compose run --rm test
}

@test "Relative URI and default urls" {
  export ARG_PATH="/healthz"
  docker compose up --detach app &> /dev/null
  docker compose run --rm test
}

@test "Default URI and default urls" {
  docker compose up --detach app &> /dev/null
  docker compose run --rm test
}

@test "Default URI and port 80" {
  export ENV_PORTS="80"
  docker compose up --detach app &> /dev/null
  docker compose run --rm test
}

@test "Default URI and port 8080" {
  export ENV_PORTS="8080"
  docker compose up --detach app &> /dev/null
  docker compose run --rm test
}

@test "Default URI and ports 80 and 8080" {
  export ENV_PORTS="80;8080"
  docker compose up --detach app &> /dev/null
  docker compose run --rm test
}

@test "Default URI and ports 8080 and 80" {
  export ENV_PORTS="8080;80"
  docker compose up --detach app &> /dev/null
  docker compose run --rm test
}
