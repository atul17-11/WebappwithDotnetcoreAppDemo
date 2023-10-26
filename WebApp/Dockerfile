#######################################################
# Step 1: Build the application in a container        #
#######################################################
# Download the official ASP.NET Core SDK image
# to build the project while creating the docker image
#FROM mcr.microsoft.com/dotnet/core/sdk:3.1 as build
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

ARG SONAR_PROJECT_KEY=scrum-demo-project
ARG SONAR_OGRANIZAION_KEY=sonarcloudwith-atul-lv
ARG SONAR_HOST_URL=https://sonarcloud.io
ARG SONAR_TOKEN="sonarcloud-scrum-demo"

WORKDIR /app

# Install Sonar Scanner, Coverlet and Java (required for Sonar Scanner)
RUN apt-get update && apt-get install -y openjdk-11-jdk
RUN dotnet tool install --global dotnet-sonarscanner --version 5.7.1
RUN dotnet tool install --global coverlet.console
ENV PATH="$PATH:/root/.dotnet/tools"

# Start Sonar Scanner
RUN dotnet sonarscanner begin \
  /k:"scrum-demo-project" \
  /o:"sonarcloudwith-atul-lv" \
  /d:sonar.host.url="https://sonarcloud.io" \
  /d:sonar.login="sonarcloud-scrum-demo" \
  /d:sonar.cs.opencover.reportsPaths=/coverage.opencover.xml

# Restore NuGet packages
#COPY *.csproj .
#RUN dotnet restore

# Copy the rest of the files over
#COPY . .

# Build and test the application
#RUN dotnet publish --output /out/



#FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
#WORKDIR /app
#EXPOSE 80
#EXPOSE 443

ENV ASPNETCORE_URLS=http://+:80

#ARG BUILDPLATFORM=linux/amd64
#FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
ARG configuration=Release
WORKDIR /src
COPY ["WebApp/WebApp.csproj", "WebApp/"]
RUN dotnet restore "WebApp/WebApp.csproj"
COPY . .
WORKDIR "/src/WebApp"
RUN dotnet build "WebApp.csproj" -c $configuration -o /app/build

RUN dotnet test \
  /p:CollectCoverage=true \
  /p:CoverletOutputFormat=opencover \
  /p:CoverletOutput="/coverage"

# End Sonar Scanner
RUN dotnet sonarscanner end /d:sonar.login=$SONAR_TOKEN

#FROM build AS publish
#ARG configuration=Release
#RUN dotnet publish "WebApp.csproj" -c $configuration -o /app/publish /p:UseAppHost=false

#FROM base AS final
FROM mcr.microsoft.com/dotnet/sdk:6.0
WORKDIR /app
EXPOSE 80
COPY --from=build /app/build .
ENTRYPOINT ["dotnet", "WebApp.dll"]
