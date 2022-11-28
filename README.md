# flying-squirrel-tactix ✈️ 🐿️ 

An Actix API microservice that uses Diesel Postgresql and rustls for TLS.

See the non-tls version "squirrel-tactix" here: https://github.com/jpegleg/squirrel-tactix

This version with rustls has rustls implemented much like morpho-web: https://github.com/jpegleg/morpho-web

This software is designed as a backend for morpho-web, but can also can be used independently. 

In order to implement rustls, the flying-squirrel-tactix uses actix-web instead of actix-rt, adds the loading
of the `privkey.pem` and `cert.pem` and a rustls bind to a fixed port of 443.

The `.env` file can be used or environment variables inserted directly. This version uses two less variables
than the non-tls squirrel-tactix as the host and port are fixed as `0.0.0.0:443`.

## statically linked build without ekidd builder

This style uses a separate pre-compile step instead of compiling during the image build.
It works just as well to use a build stage in the docker file itself.

```
docker run -v $PWD:/volume --rm -t clux/muslrust:stable cargo build --release
docker build -t "localhost:5000/flying-squirrel-tactix" .
```

#### why not ekidd here too?

11/27/22 - ekidd builder has a timing issue with zstd compiling these dependencies (rustls +), many projects that don't use rustls are not encountering the same timing issue, although several other timing scenarios have been identified in ekidd
