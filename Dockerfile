FROM scratch
COPY target/x86_64-unknown-linux-musl/release/flying-squirrel-tactix /fsql
WORKDIR /app/
EXPOSE 443
CMD ["/fsql"]
