# dotnet-healthchecker

Small dotnet program to perform health checks in container images without curl or wget.

## Usage

Add the following to a Dockerfile:

```Dockerfile
# This is the latest release for .NET 6.0
ADD --checksum=sha256:f028f7c116a24fea0dbe2671567c4dd421bcbdc856ca560cd8727fe7097d1d8d https://github.com/mikaelelkiaer/dotnet-healthchecker/releases/download/1.1.0/healthchecker /

# The health check can be configured using an absolute URI
HEALTHCHECK CMD [ "/healthchecker", "--", "http://localhost:8080/healthz" ]
# Or by combining a relative URI with the URL environment variable
ENV ASPNETCORE_URLS=http://+:8080
HEALTHCHECK CMD [ "/healthchecker", "--", "/healthz" ]
```
