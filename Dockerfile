FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env
WORKDIR /WebApp
COPY . ./
RUN dotnet restore
RUN dotnet publish -c Release -o out
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /WebApp
COPY --from=build-env /WebApp/out .
ENTRYPOINT ["dotnet","WebApp.dll"]