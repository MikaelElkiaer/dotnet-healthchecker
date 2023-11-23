ARG RUNTIME=linux-musl-x64
ARG RUNTIME_IMAGE_SUFFIX=-alpine
ARG TARGET_FRAMEWORK=8.0

FROM mcr.microsoft.com/dotnet/sdk:8.0-alpine AS build
ARG RUNTIME
ARG TARGET_FRAMEWORK
WORKDIR /src
COPY src/*.csproj .
RUN dotnet restore -p:RuntimeIdentifier=${RUNTIME}
COPY src .
RUN dotnet publish --configuration Release --framework net${TARGET_FRAMEWORK} --no-restore --output /out --runtime ${RUNTIME}

FROM scratch AS output
COPY --from=build /out /

FROM mcr.microsoft.com/dotnet/sdk:8.0-alpine AS test-app-build
ARG TARGET_FRAMEWORK
WORKDIR /src
COPY test/aspnet-app/*.csproj .
RUN dotnet restore
COPY test/aspnet-app .
RUN dotnet publish --configuration Release --framework net${TARGET_FRAMEWORK} --no-restore --output /out

FROM mcr.microsoft.com/dotnet/aspnet:${TARGET_FRAMEWORK}${RUNTIME_IMAGE_SUFFIX} AS test-app
RUN (which apk &> /dev/null && apk add curl wget) \
    || (which apt-get &> /dev/null && apt-get update && apt-get install --yes curl wget) \
    || true
WORKDIR /app
COPY --from=build /out/healthchecker /usr/local/bin/healthchecker
COPY --from=test-app-build /out .

ENTRYPOINT ["dotnet", "aspnet-app.dll"]
