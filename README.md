Calyptia Fluentd Docker Image
=============================

## What is Fluentd?

Fluentd is an open source data collector, which lets you unify the data
collection and consumption for a better use and understanding of data.

> [www.fluentd.org](https://www.fluentd.org/)

![Fluentd Logo](https://www.fluentd.org/assets/img/miscellany/fluentd-logo.png)

## Supported tags and respective `Dockerfile` links

See also GitHub container repository page: https://github.com/calyptia/calyptia-fluentd-docker-image/pkgs/container/fluentd


### Debian

##### Multi-Arch images
- `1.0`
  - `docker pull ghcr.io/calyptia/fluentd:v1.15.2-debian-1.0`
  - `docker pull ghcr.io/calyptia/fluentd:v1.15-debian-1`
  - `docker pull ghcr.io/calyptia/fluentd:edge-debian`

##### x86_64 images
- `1.0` [Dockerfile](v1.15/debian/Dockerfile)
  - `docker pull ghcr.io/calyptia/fluentd:v1.15.2-debian-1.0`
  - `docker pull ghcr.io/calyptia/fluentd:v1.15-debian-1`
  - `docker pull ghcr.io/calyptia/fluentd:edge-debian`

##### arm64 images
- `1.0` [Dockerfile](v1.15/debian/Dockerfile)
  - `docker pull ghcr.io/calyptia/fluentd:v1.15.2-debian-1.0`
  - `docker pull ghcr.io/calyptia/fluentd:v1.15-debian-1`
  - `docker pull ghcr.io/calyptia/fluentd:edge-debian`

## Settings for Calyptia Cloud

This docker image is working well with [cmetrics Fluentd extension for metrics plugin](https://github.com/calyptia/fluent-plugin-metrics-cmetrics).

And enabling RPC and configDump endpoint is required if sending Fluentd configuration for now:

### Example settings for Calyptia Cloud

Specify `CALYPTIA_API_KEY` environment variable to inject Calyptia Cloud API Key.

#### Customize Settings for Calyptia Cloud

```aconf
<system>
# If users want to use multi workers feature which corresponds to logical number of CPUs, please comment out this line.
#  workers "#{require 'etc'; Etc.nprocessors}"
  enable_input_metrics true
  # This record size measuring settings might impact for performance.
  # Please be careful for high loaded environment to turn on.
  enable_size_metrics true
  <metrics>
    @type cmetrics
  </metrics>
  rpc_endpoint 127.0.0.1:24444
  enable_get_dump true
</system>
# And other configurations....

## Fill YOUR_API_KEY with your Calyptia API KEY
<source>
  @type calyptia_monitoring
  @id input_caplyptia_moniroting
  <cloud_monitoring>
    # endpoint http://development-environment-or-production.fqdn:5000
    api_key YOUR_API_KEY
    rate 30
    pending_metrics_size 100 # Specify capacity for pending metrics
  </cloud_monitoring>
  <storage>
    @type local
    path /fluentd/log/agent_states
  </storage>
</source>
```

### Generate Calyptia Cloud Monitoring settings via calyptia-config-generator

```bash
$ docker run  --rm ghcr.io/calyptia/fluentd:v1.14-debian-1 /usr/local/bundle/bin/calyptia-config-generator YOUR_API_KEY --enable-size-metrics --storage-agent-token-dir /fluentd/log --endpoint http://localhost:5000
```

Then, got in stdin:

```aconf
<system>
  <metrics>
    @type cmetrics
  </metrics>
  enable_input_metrics true
  enable_size_metrics true
  rpc_endpoint 127.0.0.1:24444
  enable_get_dump true
<system>
<source>
  @type calyptia_monitoring
  @id input_caplyptia_monitoring
  <cloud_monitoring>
    endpoint http://localhost:5000
    api_key YOUR_API_KEY
  </cloud_monitoring>
  <storage>
    @type local
    path /fluentd/log/agent_state
  </storage>
</source>
```

## Docker

Current images use fluentd v1 series and pushed into GitHub Container Registry(ghcr):

[Calyptia Fluentd | GHCR ](https://github.com/calyptia/calyptia-fluentd-docker-image/pkgs/container/fluentd)

## How to use this image

To create endpoint that collects logs on your host just run:

```bash
docker run -d -p 24224:24224 -p 24224:24224/udp -e CALYPTIA_API_KEY=YOUR_API_KEY [-e CALYPTIA_ENDPOINT=http://localhost:5000] ghcr.io/calyptia/fluentd:v1.14-debian-1
```

Default configurations are to:

- listen port `24224` for Fluentd forward protocol
- store logs with tag `docker.**` into `/fluentd/log/docker.*.log`
  (and symlink `docker.log`)
  - store all other logs into `/fluentd/log/data.*.log` (and symlink `data.log`)

### Providing your own configuration file and additional options

`fluentd` can be process to be appended command line arguments in the `docker run` line

For example, to provide a config, then:

```console
$ docker run -it --rm -p 24224:24224 -p 24224:24224/udp -v /path/to/dir:/fluentd/etc -v /path/to/store/api_response:/fluentd/state/calyptia-fluentd/agent_states ghcr.io/calyptia/fluentd:v1.14-debian-1 -c /fluentd/etc/<conf>
```

The first `-v` tells Docker to share '/path/to/dir' as a volume and mount it at `/fluentd/etc`.
The second `-v` tells Docker to persist '/path/to/anotherdir` as a volume and mount it at `/fluentd/log/agent_state`.

### Build with BuildKit

Docker supports multiarch image with BuildKit. This build procedure is enabled by:

```console
$ docker buildx create --name cibuilder --driver docker-container --use
$ docker buildx use cibuilder
$ docker buildx inspect --bootstrap
```

Now, spin up for building multiarch docker image.

### References

[Docker Logging | fluentd.org][docker-logging-recipe]

[Fluentd logging driver - Docker Docs][docker-engine-docs]

## Issues

If you have any problems with or questions about this image, please contact us
through a [GitHub issue](https://github.com/calyptia/calyptia-fluentd-docker-image/issues).

[docker-logging-recipe]: https://www.fluentd.org/guides/recipes/docker-logging
[docker-engine-docs]: https://docs.docker.com/engine/reference/logging/fluentd
