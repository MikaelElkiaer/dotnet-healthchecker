# dotnet-healthchecker

Small .NET application to perform health checks in containers - without `curl`, `wget`, or other dependencies.

## Usage

```Dockerfile
# Add the application (see below for more versions)
ADD https://github.com/mikaelelkiaer/dotnet-healthchecker/releases/download/main/healthchecker-net80-linux-x64 /usr/local/bin/healthchecker
# Make executable for all
RUN chmod +rx /usr/local/bin/healthchecker
# Configure health check using defaults
HEALTHCHECK CMD [ "healthchecker" ]
```

The health check above will default to a relative URI `/healthz` and a base URI:

- `http://localhost:8080` (.NET 8.0)
- `http://localhost:5000` (.NET <8.0)

```Dockerfile
# The health check can be configured using an absolute URI
HEALTHCHECK CMD [ "healthchecker", "http://localhost:5001/healthz" ]
# Or by setting a relative URI and utilizing an ASPNETCORE_ environment variable
ENV ASPNETCORE_HTTP_PORTS=5001
ENV ASPNETCORE_URLS=http://+:5001
HEALTHCHECK CMD [ "healthchecker", "/healthz" ]
```

## Using a specific version (with checksum)

This is the latest version - see releases for more.
Same instructions as above can be used.
The checksum is not explicitly needed, but is an added security precaution.

```Dockerfile
# .NET 8.0 linux-x64
ADD --checksum=sha256:7a9392fc9f1020ef63a84f1048402eb20e57f05690b70bb1e4d560f4ca836788 https://github.com/mikaelelkiaer/dotnet-healthchecker/releases/download/1.3.0/healthchecker-net80-linux-x64 /usr/local/bin/healthchecker
# .NET 8.0 linux-musl-x64 (alpine)
ADD --checksum=sha256:36b4e0e609546129a2bf5b609cc4631dc632e1d65cd948452b1d6634d4fd70ee https://github.com/mikaelelkiaer/dotnet-healthchecker/releases/download/1.3.0/healthchecker-net80-linux-musl-x64 /usr/local/bin/healthchecker
```
