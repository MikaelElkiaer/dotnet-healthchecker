FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY src/*.csproj .
RUN dotnet restore
COPY src .
RUN dotnet publish --configuration Release --no-restore --output /out

FROM scratch AS output
COPY --from=build /out /

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS test-app-build
WORKDIR /src
COPY test/aspnet-app/*.csproj .
RUN dotnet restore
COPY test/aspnet-app .
RUN dotnet publish --configuration Release --no-restore --output /out

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS test-app
WORKDIR /app
COPY --from=build /out/healthchecker /
COPY --from=test-app-build /out .

ENTRYPOINT ["dotnet", "aspnet-app.dll"]
