#!/bin/bash

# Build and run the container using podman
podman build -t tutorial .
podman run -it --rm tutorial