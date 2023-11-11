FROM mcr.microsoft.com/dotnet/sdk:6.0 as build-healthchecker
WORKDIR /src
COPY src/*.csproj .
RUN dotnet restore
COPY src .
RUN dotnet publish --configuration Release --runtime linux-x64 --no-self-contained --output /out

FROM mcr.microsoft.com/dotnet/sdk:6.0 as build-app
WORKDIR /src
COPY test/aspnet-app/*.csproj .
RUN dotnet restore
COPY test/aspnet-app .
RUN dotnet publish --configuration Release --output /out

FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
COPY --from=build-healthchecker /out/healthchecker.dll .
COPY --from=build-healthchecker /out/healthchecker.deps.json .
COPY --from=build-healthchecker /out/healthchecker.runtimeconfig.json .
COPY --from=build-app /out .

ENTRYPOINT ["dotnet", "aspnet-app.dll"]
