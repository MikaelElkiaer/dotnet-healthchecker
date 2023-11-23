ARG RUNTIME=linux-musl-x64
ARG RUNTIME_IMAGE_SUFFIX=-alpine
ARG TARGET_FRAMEWORK=8.0

FROM mcr.microsoft.com/dotnet/sdk:8.0-alpine AS build
ARG RUNTIME
ARG TARGET_FRAMEWORK
WORKDIR /src
COPY src/*.csproj .
RUN dotnet restore -p:RuntimeIdentifier=${RUNTIME} -p:TargetFramework=net${TARGET_FRAMEWORK}
COPY src .
RUN dotnet publish --configuration Release --no-restore --output /out -p:RuntimeIdentifier=${RUNTIME} -p:TargetFramework=net${TARGET_FRAMEWORK}

FROM scratch AS output
COPY --from=build /out /

FROM mcr.microsoft.com/dotnet/sdk:8.0-alpine AS test-app-build
ARG TARGET_FRAMEWORK
WORKDIR /src
COPY test/aspnet-app/*.csproj .
RUN dotnet restore -p:TargetFramework=net${TARGET_FRAMEWORK}
COPY test/aspnet-app .
RUN dotnet publish --configuration Release --no-restore --output /out /p:TargetFramework=net${TARGET_FRAMEWORK}

FROM mcr.microsoft.com/dotnet/aspnet:8.0${RUNTIME_IMAGE_SUFFIX} AS test-app
WORKDIR /app
COPY --from=build /out/healthchecker /usr/local/bin/healthchecker
COPY --from=test-app-build /out .

ENTRYPOINT ["dotnet", "aspnet-app.dll"]
