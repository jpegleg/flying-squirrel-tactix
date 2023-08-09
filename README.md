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

The default Dockerfile uses `distroless` instead of `scratch` as the OCI image base.

```
# small shelless base that also mitigates kube exec
FROM gcr.io/distroless/static-debian11
#FROM scratch
COPY target/x86_64-unknown-linux-musl/release/flying-squirrel-tactix /fsql
WORKDIR /app/
EXPOSE 443
CMD ["/fsql"]
```
#### why not ekidd here too?

11/27/22 - ekidd builder has a timing issue with zstd compiling these dependencies (rustls +), many projects that don't use rustls are not encountering the same timing issue, although several other timing scenarios have been identified in ekidd

## adding Authentication, middleware, and mTLS

Actix has middleware for auth, or auth can be impelemented directly etc.
mTLS version of flying-squirrel-tactix is doable and being tested, however rustls mTLS client auth
is so far either far too lax or failing to authenticate correctly. I may release that
code in a separate project template.

Instead of auth and mTLS in the microservice (server auth rustls TLS only is provided in flying-squirrel-tactix, enough to ensure the data is encrypted in transit), using network rules or sidecare auth systems to authenticate clients
may be used to augment the access controls more effectively. Kubernetes Network Policy may be used to limit
access, enforced with controllers such as those from a CNI plugin like Calico etc.

#### TLDR: "bring your own auth or use Actix middleware techniques".

Example auth: `actix-web-middleware-keycloak-auth = "0.4.0"`

The goal is to have front end services use the inserted auth/middlware against the flying-squirrel-tactix,
and the only place with real database credentials and direct database connections is the flying-squirrel-tactix statically compiled sheless OCI image.
