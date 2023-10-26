#######################################################
# Step 1: Build the application in a container        #
#######################################################
# Download the official ASP.NET Core SDK image
# to build the project while creating the docker image
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env

ARG SONAR_PROJECT_KEY=scrum-demo-project
ARG SONAR_OGRANIZAION_KEY=sonarcloudwith-atul-lv
ARG SONAR_HOST_URL=https://sonarcloud.io
ARG SONAR_TOKEN=sonarcloud-scrum-demo

#WORKDIR /app

# Install Sonar Scanner, Coverlet and Java (required for Sonar Scanner)
RUN apt-get update && apt-get install -y openjdk-11-jdk
RUN dotnet tool install --global dotnet-sonarscanner --version 5.7.1
RUN dotnet tool install --global coverlet.console
ENV PATH="$PATH:/root/.dotnet/tools"

# Start Sonar Scanner
RUN dotnet sonarscanner begin \
  /k:"$SONAR_PROJECT_KEY" \
  #/o:"$SONAR_OGRANIZAION_KEY" \
  #/d:sonar.host.url="$SONAR_HOST_URL" \
  #/d:sonar.login="$SONAR_TOKEN" \
  #/d:sonar.branch.name="dev" \
  #/d:sonar.cs.opencover.reportsPaths=/coverage.opencover.xml

ARG configuration=Release
WORKDIR /src
COPY ["WebApp/WebApp.csproj", "WebApp/"]
RUN dotnet restore "WebApp/WebApp.csproj"
COPY . .
WORKDIR "/src/WebApp"
RUN dotnet build "WebApp.csproj" -c $configuration -o /app/build

RUN dotnet test "WebApp.UnitTest/*.csproj" \
  /p:CollectCoverage=true \
  /p:CoverletOutputFormat=opencover \
  /p:CoverletOutput="/coverage"

## Create the code coverage file in sonarqube format using the cobertura file generated from the dotnet test command
RUN reportgenerator "-reports:./coverage/*/coverage.opencover.xml" "-targetdir:coverage" "-reporttypes:SonarQube"

ARG configuration=Release
RUN dotnet publish "WebApp.csproj" -c "$configuration" -o /app/publish /p:UseAppHost=false


# End Sonar Scanner
RUN dotnet sonarscanner end /d:sonar.login="$SONAR_TOKEN"

#######################################################
# Step 2: Run the build outcome in a container        #
#######################################################
# Download the official ASP.NET Core Runtime image
# to run the compiled application

FROM mcr.microsoft.com/dotnet/sdk:6.0
WORKDIR /app
# Open port
EXPOSE 80
COPY --from=build-env /app/publish .
ENTRYPOINT ["dotnet", "WebApp.dll"]