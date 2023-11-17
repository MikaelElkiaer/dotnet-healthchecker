ARG TARGET_FRAMEWORK=6.0
FROM mcr.microsoft.com/dotnet/sdk:${TARGET_FRAMEWORK}-alpine AS build
ARG TARGET_FRAMEWORK
WORKDIR /src
COPY src/*.csproj .
RUN dotnet restore -p:TargetFramework=net${TARGET_FRAMEWORK}
COPY src .
RUN dotnet publish --configuration Release --no-restore --output /out -p:TargetFramework=net${TARGET_FRAMEWORK}

FROM scratch AS output
COPY --from=build /out /

FROM mcr.microsoft.com/dotnet/sdk:${TARGET_FRAMEWORK}-alpine AS test-app-build
ARG TARGET_FRAMEWORK
WORKDIR /src
COPY test/aspnet-app/*.csproj .
RUN dotnet restore -p:TargetFramework=net${TARGET_FRAMEWORK}
COPY test/aspnet-app .
RUN dotnet publish --configuration Release --no-restore --output /out /p:TargetFramework=net${TARGET_FRAMEWORK}

FROM mcr.microsoft.com/dotnet/sdk:${TARGET_FRAMEWORK}-alpine AS test-app
WORKDIR /app
COPY --from=build /out/healthchecker /
COPY --from=test-app-build /out .

ENTRYPOINT ["dotnet", "aspnet-app.dll"]
