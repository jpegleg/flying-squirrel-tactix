# small shelless base that also mitigates kube exec
FROM gcr.io/distroless/static-debian11
#FROM scratch
COPY target/x86_64-unknown-linux-musl/release/flying-squirrel-tactix /fsql
WORKDIR /app/
EXPOSE 443
CMD ["/fsql"]
