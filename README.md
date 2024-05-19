# flying-squirrel-tactix ✈️ 🐿️ 

An Actix API microservice that uses Diesel Postgresql and rustls for TLS.

See the non-tls version "squirrel-tactix" here: https://github.com/jpegleg/squirrel-tactix

This version with rustls has rustls implemented much like morpho-web: https://github.com/jpegleg/morpho-web

This software is designed as a backend for morpho-web, but can also can be used independently. 

In order to implement rustls, the flying-squirrel-tactix uses actix-web instead of actix-rt, adds the loading
of the `privkey.pem` and `cert.pem` and a rustls bind to a fixed port of 443.

The `.env` file can be used or environment variables inserted directly. This version uses two less variables
than the non-tls squirrel-tactix as the host and port are fixed as `0.0.0.0:443`.

## different ways of compiling

This style uses a separate pre-compile step instead of compiling during the image build.
It works just as well to use a build stage in the docker file itself.

```
cross build --target x86_64-unknown-linux-musl --release 
docker build -t "localhost:5000/flying-squirrel-tactix" .
```

Or without "cross":

```
docker run -v $PWD:/volume --rm -t clux/muslrust:stable cargo build --release
docker build -t "localhost:5000/flying-squirrel-tactix" .
```

The default Dockerfile uses `distroless` instead of `scratch` as the OCI image base.

```
FROM scratch
COPY target/x86_64-unknown-linux-musl/release/flying-squirrel-tactix /fsql
RUN mkdir -p /app/data/
EXPOSE 443
CMD ["/fsql"]
```


## adding Authentication, middleware, and mTLS

Actix has middleware for auth, or auth can be impelemented directly etc.

Instead of auth and mTLS in the current default flying-squirrel-tactix microservice (server auth rustls TLS only is provided in flying-squirrel-tactix, enough to ensure the data is encrypted in transit), using network rules or sidecar auth systems to authenticate clients
may be used to augment the access controls more effectively. Kubernetes Network Policy may be used to limit
access, enforced with controllers such as those from a CNI plugin like Calico etc.

#### TLDR: "bring your own auth or use Actix middleware techniques".

Example auth: `actix-web-middleware-keycloak-auth = "0.4.0"`

The goal is to have front end services use the inserted auth/middlware against the flying-squirrel-tactix,
and the only place with real database credentials and direct database connections is the flying-squirrel-tactix statically compiled shelless OCI image.
The URI context is a layer of control, change the routes to include matching special values.

Squirrel-tactix is itself a layer of abstraction and isolation around the database already,
hard coding the only available functions to a spcific scope of JSON requests. It enables access to the appropriate application internals, and does any backend tasks we need to
do, including being able to make calls to other services (add `reqwest` functions or `curl` functions could be added for example).

## Put the db on the loopback only

Flying-squirrel-tactix supports remote databases, but running "in front" of a postgresql instance bound to the loopback device
is a great style with performance benefits.

Set the database listener address to `127.0.0.1` and run flying-squirrel-tactix in the same Pod or on the same host,
and only allow the database to be accessed externally then through the flying-squirrel-tactix JSON API.


## Dependencies

The build (compile) will fail without the needed system dependencies (example: postgresql-all librust-openssl-dev gcc)
See https://github.com/jpegleg/squirrel-tactix/tree/main for more help info on setup.
