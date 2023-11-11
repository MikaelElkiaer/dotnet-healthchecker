FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY src/*.csproj .
RUN dotnet restore
COPY src .
RUN dotnet publish --configuration Release --runtime linux-x64 --no-self-contained --output /out

FROM scratch AS output
COPY --from=build /out /

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS test-app-build
WORKDIR /src
COPY test/aspnet-app/*.csproj .
RUN dotnet restore
COPY test/aspnet-app .
RUN dotnet publish --configuration Release --output /out

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS test-app
WORKDIR /app
COPY --from=build /out/healthchecker.dll .
COPY --from=build /out/healthchecker.deps.json .
COPY --from=build /out/healthchecker.runtimeconfig.json .
COPY --from=test-app-build /out .

ENTRYPOINT ["dotnet", "aspnet-app.dll"]
