#!/usr/bin/env bats


@test "post_push hook is up-to-date" {
  run sh -c "cat Makefile | grep $DOCKERFILE: \
                          | cut -d ':' -f 2 \
                          | cut -d '\\' -f 1 \
                          | tr -d ' '"
  [ "$status" -eq 0 ]
  [ "$output" != '' ]
  expected="$output"

  run sh -c "cat '$DOCKERFILE/hooks/post_push' \
               | grep 'for tag in' \
               | cut -d '{' -f 2 \
               | cut -d '}' -f 1"
  [ "$status" -eq 0 ]
  [ "$output" != '' ]
  actual="$output"

  [ "$actual" == "$expected" ]
}


@test "ruby version is 3.0(debian)" {
  run docker run --rm $IMAGE sh -c "ruby --version | cut -d ' ' -f 2"
  [ "$status" -eq 0 ]

  major=$(echo "$output" | cut -d '.' -f 1)
  minor=$(echo "$output" | cut -d '.' -f 2)
  [ "$major" -eq "3" ]
  [[ "$minor" =~ [0] ]]
}


@test "fluentd is installed" {
  run docker run --rm $IMAGE which fluentd
  [ "$status" -eq 0 ]
}

@test "fluentd runs ok" {
  run docker run --rm $IMAGE fluentd --help
  [ "$status" -eq 0 ]
}

@test "fluentd has correct version" {
  run docker run --rm $IMAGE fluentd --version
  [ "$status" -eq 0 ]
  actual=$(echo "$output" | cut -d ' ' -f 2 | tr -d " \n")

  run sh -c "cat Makefile | grep $DOCKERFILE: | cut -d ':' -f 2 \
                                              | cut -d ',' -f 1 \
                                              | cut -d '-' -f 1 \
                                              | tr -d ' v'"
  [ "$status" -eq 0 ]
  [ "$output" != '' ]
  expected="$output"

  [ "$actual" == "$expected" ]
}


@test "gem 'oj' is installed " {
  run docker run --rm $IMAGE sh -c "gem list --local oj | grep -e '^oj '"
  [ "$status" -eq 0 ]
}

@test "gem 'json' is installed " {
  run docker run --rm $IMAGE sh -c "gem list --local json | grep -e '^json '"
  [ "$status" -eq 0 ]
}

@test "gem 'cmetrics' is installed " {
  run docker run --rm $IMAGE sh -c "gem list --local cmetrics | grep -e '^cmetrics '"
  [ "$status" -eq 0 ]
}

@test "gem 'fluent-plugin-metrics-cmetrics' is installed " {
  run docker run --rm $IMAGE sh -c "gem list --local fluent-plugin-metrics-cmetrics | grep -e '^fluent-plugin-metrics-cmetrics '"
  [ "$status" -eq 0 ]
}

@test "gem 'fluent-plugin-calyptia-monitoring' is installed " {
  run docker run --rm $IMAGE sh -c "gem list --local fluent-plugin-calyptia-monitoring | grep -e '^fluent-plugin-calyptia-monitoring '"
  [ "$status" -eq 0 ]
}