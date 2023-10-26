# Stage 1: Build the .NET Core application
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
ARG configuration=Release
# Copy the .csproj and restore as distinct layers
COPY ["WebApp/WebApp.csproj", "WebApp/"]
RUN dotnet restore "WebApp/WebApp.csproj"
# Copy the remaining source code
COPY . .
WORKDIR "/src/WebApp"
RUN dotnet build "WebApp.csproj" -c $configuration -o /app/build

 

#RUN dotnet test "WebApp.UnitTest/*.csproj" \
 # /p:CollectCoverage=true \
  #/p:CoverletOutputFormat=opencover \
  #/p:CoverletOutput="/coverage"

 

# Build the application
RUN dotnet publish "WebApp.csproj" -c "$configuration" -o /app/publish /p:UseAppHost=false

 

# Stage 2: Run the SonarCloud scan
FROM sonarsource/sonar-scanner-cli AS sonarscan

 

# Copy the application code from the build stage
COPY --from=build /app/publish /app

 

# Set up the SonarScanner properties
RUN sonar-scanner \
    -Dsonar.projectKey="scrum-demo-project" \
    -Dsonar.sources=/app \
    -Dsonar.host.url=https://sonarcloud.io/organizations/sonarcloudwith-atul-lv/projects \
    -Dsonar.login="sonarcloud-scrum-demo"

 

# Additional steps like setting up runtime environment, exposing ports, etc.

 

# Start your application or any other post-build steps
ENTRYPOINT ["dotnet", "YourApp.dll"]