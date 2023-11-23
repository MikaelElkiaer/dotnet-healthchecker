# dotnet-healthchecker

Small .NET application to perform health checks in containers - without `curl`, `wget`, or other dependencies.

## Usage

```Dockerfile
# Add the application
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

Under [releases](https://github.com/MikaelElkiaer/dotnet-healthchecker/releases/), specific versions can be found with separate install instructions.
The instructions for specific releases also include a checksum as an added security measure.
