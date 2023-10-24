#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["src/WebApp/WebApp.csproj", "src/WebApp/"]
RUN dotnet restore "WebApp.csproj"
COPY . .
WORKDIR "/src/WebApp"
RUN dotnet build WebApp.csproj -c Debug -o /app

FROM build as debug
RUN dotnet publish "WebApp.csproj" -c Debug -o /app

FROM base as final
WORKDIR /app
COPY --from=publish/app /app .
ENTRYPOINT ["dotnet", "WebApp.dll"]
