# Snort3 Parser

Collect the Snort v3 alert log and send it to Mata Elang Defense Center through MQTT

## Docker Hub Repository

https://hub.docker.com/r/mataelang/snort3-parser

## Requirements
 - [Golang 1.18 or more](https://go.dev/dl)
 - [make](https://www.gnu.org/software/make) (optional)
 - [Docker](https://docs.docker.com/engine) (optional)

## Build with Makefile
 - Show the make help: `make help`
 - Build the binary: `make build`.
    The binary will be available in the `out/bin/` directory.
 - Build docker image: `make build-docker`
