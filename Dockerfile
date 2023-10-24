FROM mcr.microsoft.com/dotnet/sdk:6.0.0 AS build-env
WORKDIR /src
COPY ["WebApp.csproj","./"]
RUN dotnet restore "./WebApp.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "WebApp.csproj" -c Release -o /app/build

FROM build AS publish 
RUN dotnet publish "WebApp.csproj" -c Release -o /app/publish


FROM mcr.microsoft.com/dotnet/aspnet:6.0.0
WORKDIR /src
COPY --from=publish  app/publish .
ENTRYPOINT ["dotnet", "WebApp.dll"]
