#FROM clux/muslrust:stable AS build
#WORKDIR /app
#COPY --chown=rust:rust . .
#RUN cargo install --path .
# COPY --from=build /app/target/x86_64-unknown-linux-musl/release/lying-squirrel-tactix /fsql
# using single stage build because the binary artifact is also being used separately
# small shelless base that also mitigates kube exec, like scratch but with passwd, public certs, /tmp, and tzdata:
#FROM gcr.io/distroless/static-debian11
# use the smallest "empty" instance to save a few MB of disk space compared to distroless
FROM scratch
COPY target/x86_64-unknown-linux-musl/release/flying-squirrel-tactix /fsql
WORKDIR /app/
EXPOSE 443
CMD ["/fsql"]
