#!/usr/bin/env bats

teardown() {
  docker compose down &> /dev/null
}

@test "Absolute URI and listen port 80" {
  export VAR_ARG="http://localhost:80/healthz"
	export VAR_ENV="http://+:80"
  docker compose up --detach app &> /dev/null
	docker compose run --rm test
}

@test "Absolute URI and listen port 8080" {
  export VAR_ARG="http://localhost:8080/healthz"
	export VAR_ENV="http://+:8080"
  docker compose up --detach app &> /dev/null
	docker compose run --rm test
}

@test "Relative URI and listen port 80" {
  export VAR_ARG="/healthz"
	export VAR_ENV="http://+:80"
  docker compose up --detach app &> /dev/null
	docker compose run --rm test
}

@test "Relative URI and listen port 8080" {
  export VAR_ARG="/healthz"
	export VAR_ENV="http://+:8080"
  docker compose up --detach app &> /dev/null
	docker compose run --rm test
}

@test "Relative URI and listen ports 8080 and 80" {
  export VAR_ARG="/healthz"
	export VAR_ENV="http://+:8080;http://+:80"
  docker compose up --detach app &> /dev/null
	docker compose run --rm test
}

@test "Relative URI and listen ports 80 and 8080" {
  export VAR_ARG="/healthz"
	export VAR_ENV="http://+:80;http://+:8080"
  docker compose up --detach app &> /dev/null
	docker compose run --rm test
}

@test "Relative URI and default listen" {
  export VAR_ARG="/healthz"
	export VAR_ENV=
  docker compose up --detach app &> /dev/null
	docker compose run --rm test
}

@test "Default URI and default listen" {
  export VAR_ARG=
	export VAR_ENV=
  docker compose up --detach app &> /dev/null
	docker compose run --rm test
}

@test "Default URI and listen port 8080" {
  export VAR_ARG=
	export VAR_ENV="http://+:8080"
  docker compose up --detach app &> /dev/null
	docker compose run --rm test
}

@test "Default URI and listen port 80" {
  export VAR_ARG=
	export VAR_ENV="http://+:80"
  docker compose up --detach app &> /dev/null
	docker compose run --rm test
}
