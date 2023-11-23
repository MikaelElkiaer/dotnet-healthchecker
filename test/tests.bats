#!/usr/bin/env bats

teardown() {
  docker compose down &> /dev/null
}

@test "Absolute URI and urls port 81" {
  export ARG_PATH="http://localhost:81/healthz"
  export ENV_URLS="ASPNETCORE_URLS=http://+:81"
  docker compose up --detach app &> /dev/null
  docker compose run --rm test
}

@test "Absolute URI and urls port 8081" {
  export ARG_PATH="http://localhost:8081/healthz"
  export ENV_URLS="ASPNETCORE_URLS=http://+:8081"
  docker compose up --detach app &> /dev/null
  docker compose run --rm test
}

@test "Relative URI and urls port 81" {
  export ARG_PATH="/healthz"
  export ENV_URLS="ASPNETCORE_URLS=http://+:81"
  docker compose up --detach app &> /dev/null
  docker compose run --rm test
}

@test "Relative URI and urls port 8081" {
  export ARG_PATH="/healthz"
  export ENV_URLS="ASPNETCORE_URLS=http://+:8081"
  docker compose up --detach app &> /dev/null
  docker compose run --rm test
}

@test "Relative URI and urls ports 8081 and 81" {
  export ARG_PATH="/healthz"
  export ENV_URLS="ASPNETCORE_URLS=http://+:8081;http://+:81"
  docker compose up --detach app &> /dev/null
  docker compose run --rm test
}

@test "Relative URI and urls ports 81 and 8081" {
  export ARG_PATH="/healthz"
  export ENV_URLS="ASPNETCORE_URLS=http://+:81;http://+:8081"
  docker compose up --detach app &> /dev/null
  docker compose run --rm test
}

@test "Default URI and urls port 8081" {
  export ENV_URLS="ASPNETCORE_URLS=http://+:8081"
  docker compose up --detach app &> /dev/null
  docker compose run --rm test
}

@test "Default URI and urls port 81" {
  export ENV_URLS="ASPNETCORE_URLS=http://+:81"
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

@test "Default URI and port 81" {
  export ENV_PORTS="ASPNETCORE_HTTP_PORTS=81"
  docker compose up --detach app &> /dev/null
  docker compose run --rm test
}

@test "Default URI and port 8081" {
  export ENV_PORTS="ASPNETCORE_HTTP_PORTS=8081"
  docker compose up --detach app &> /dev/null
  docker compose run --rm test
}

@test "Default URI and ports 81 and 8081" {
  export ENV_PORTS="ASPNETCORE_HTTP_PORTS=81;8081"
  docker compose up --detach app &> /dev/null
  docker compose run --rm test
}

@test "Default URI and ports 8081 and 81" {
  export ENV_PORTS="ASPNETCORE_HTTP_PORTS=8081;81"
  docker compose up --detach app &> /dev/null
  docker compose run --rm test
}

# bats test_tags=net80
@test "Absolute URI and port 81" {
  export ARG_PATH="http://localhost:81/healthz"
  export ENV_PORTS="ASPNETCORE_HTTP_PORTS=81"
  docker compose up --detach app &> /dev/null
  docker compose run --rm test
}

# bats test_tags=net80
@test "Absolute URI and port 8081" {
  export ARG_PATH="http://localhost:8081/healthz"
  export ENV_PORTS="ASPNETCORE_HTTP_PORTS=8081"
  docker compose up --detach app &> /dev/null
  docker compose run --rm test
}

# bats test_tags=net60
@test "Absolute URI and port 81 - defaults to 80" {
  export ARG_PATH="http://localhost:80/healthz"
  export ENV_PORTS="ASPNETCORE_HTTP_PORTS=81"
  docker compose up --detach app &> /dev/null
  docker compose run --rm test
}

# bats test_tags=net60
@test "Absolute URI and port 8081 - defaults to 80" {
  export ARG_PATH="http://localhost:80/healthz"
  export ENV_PORTS="ASPNETCORE_HTTP_PORTS=8081"
  docker compose up --detach app &> /dev/null
  docker compose run --rm test
}
