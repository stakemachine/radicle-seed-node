# radicle-seed-node
Dockerfile for Radicle Seed Node

# How to run
Image available at ghcr.io/stakemachine/radicle-seed-node
Example:
```
docker run -d -v /path/to/local/folder:/home/radicle -e name=seedling -e public_addr=0.0.0.0:12345 --name radicle -p 12345:12345/udp -p 80:8080 ghcr.io/stakemachine/radicle-seed-node
```
Support ENV variables:
* name
* description
* public_addr
* http_listen