FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

ENV ASPNETCORE_URLS=http://+:80

#ARG BUILDPLATFORM=linux/amd64
#FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
#ARG configuration=Release
#WORKDIR /src
#COPY ["WebApp/WebApp.csproj", "WebApp/"]
#RUN dotnet restore "WebApp/WebApp.csproj"
#COPY . .
#WORKDIR "/src/WebApp"
#RUN dotnet build "WebApp.csproj" -c $configuration -o /app/build

#FROM build AS publish
#ARG configuration=Release
#RUN dotnet publish "WebApp.csproj" -c $configuration -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /WebApp/bin/Release/net6.0 .
ENTRYPOINT ["dotnet", "WebApp.dll"]
