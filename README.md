# flying-squirrel-tactix ✈️ 🐿️ 

An Actix API microservice that uses Diesel Postgresql and rustls for TLS.

See the non-tls version "squirrel-tactix" here: https://github.com/jpegleg/squirrel-tactix

This version with rustls has rustls implemented much like morpho-web: https://github.com/jpegleg/morpho-web

In order to implement rustls, the flying-squirrel-tactix uses actix-web instead of actix-rt, adds the loading
of the `privkey.pem` and `cert.pem` and a rustls bind to a fixed port of 443.

The `.env` file can be used or environment variables inserted directly. This version uses two less variables
than the non-tls squirrel-tactix as the host and port are fixed as `0.0.0.0:443`.


