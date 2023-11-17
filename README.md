# dotnet-healthchecker

Small dotnet program to perform health checks in container images without curl or wget.

## Usage

Add the following to a Dockerfile:

```Dockerfile
# .NET 6.0
ADD --checksum=sha256:3e26ec3ad0627f2b57e8e58123fdbd67b516079d8dce8abd12403e3c212ee736 https://github.com/mikaelelkiaer/dotnet-healthchecker/releases/download/1.3.0/healthchecker-net60-linux-x64 /usr/local/bin/healthchecker
# .NET 6.0 (alpine)
ADD --checksum=sha256:6ba6ced8bbbebd5332699c48915c3c6b72157610b4a68b98eafb314c4d878b3b https://github.com/mikaelelkiaer/dotnet-healthchecker/releases/download/1.3.0/healthchecker-net60-linux-musl-x64 /usr/local/bin/healthchecker
# .NET 8.0
ADD --checksum=sha256:7a9392fc9f1020ef63a84f1048402eb20e57f05690b70bb1e4d560f4ca836788 https://github.com/mikaelelkiaer/dotnet-healthchecker/releases/download/1.3.0/healthchecker-net80-linux-x64 /usr/local/bin/healthchecker
# .NET 8.0 (alpine)
ADD --checksum=sha256:36b4e0e609546129a2bf5b609cc4631dc632e1d65cd948452b1d6634d4fd70ee https://github.com/mikaelelkiaer/dotnet-healthchecker/releases/download/1.3.0/healthchecker-net80-linux-musl-x64 /usr/local/bin/healthchecker
# Make executable for all
RUN chmod +rx /usr/local/bin/healthchecker

# The health check can be configured using an absolute URI
HEALTHCHECK CMD [ "healthchecker", "http://localhost:8080/healthz" ]
# Or by combining a relative URI with the URL environment variable
ENV ASPNETCORE_URLS=http://+:8080
HEALTHCHECK CMD [ "healthchecker", "/healthz" ]
```
