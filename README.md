# dotnet-healthchecker

Small dotnet program to perform health checks in container images without curl or wget.

## Usage

Add the following to a Dockerfile:

```Dockerfile
# .NET 6.0
ADD --checksum=sha256:f028f7c116a24fea0dbe2671567c4dd421bcbdc856ca560cd8727fe7097d1d8d https://github.com/mikaelelkiaer/dotnet-healthchecker/releases/download/1.2.0/healthchecker_net60 /healthchecker
# .NET 8.0
ADD --checksum=sha256:7dc629d13b02050804902b4d1593d915c805f6aab6095dab5d0734b4b1b74718 https://github.com/mikaelelkiaer/dotnet-healthchecker/releases/download/1.2.0/healthchecker_net80 /healthchecker

# The health check can be configured using an absolute URI
HEALTHCHECK CMD [ "/healthchecker", "--", "http://localhost:8080/healthz" ]
# Or by combining a relative URI with the URL environment variable
ENV ASPNETCORE_URLS=http://+:8080
HEALTHCHECK CMD [ "/healthchecker", "--", "/healthz" ]
```
