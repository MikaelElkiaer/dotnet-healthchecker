# dotnet-healthchecker

Small dotnet program to perform health checks in container images without curl or wget.

## Usage

Add the following to a Dockerfile:

```Dockerfile
ADD --checksum=sha256:6ff339d8e5cd140cf96d229b0145e1ce946d592edae1ff21fc59df1fe56d9bf5 https://github.com/mikaelelkiaer/dotnet-healthchecker/releases/download/1.0.1/healthchecker.dll .
ADD --checksum=sha256:2264b15f4313dcedc50d325463216559f82ae0c894f8d0eab98f484223aaee46 https://github.com/mikaelelkiaer/dotnet-healthchecker/releases/download/1.0.1/healthchecker.deps.json .
HEALTHCHECK CMD [ "dotnet", "healthchecker.dll", "--", "http://localhost:8080/healthz" ]
```
