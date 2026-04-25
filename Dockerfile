# Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy solution and project files
COPY ["RecipePlatform.sln", "./"]
COPY ["src/RecipePlatform.Domain/RecipePlatform.Domain.csproj", "src/RecipePlatform.Domain/"]
COPY ["src/RecipePlatform.Application/RecipePlatform.Application.csproj", "src/RecipePlatform.Application/"]
COPY ["src/RecipePlatform.Infrastructure/RecipePlatform.Infrastructure.csproj", "src/RecipePlatform.Infrastructure/"]
COPY ["src/RecipePlatform.API/RecipePlatform.API.csproj", "src/RecipePlatform.API/"]

# Restore dependencies
RUN dotnet restore "RecipePlatform.sln"

# Build
RUN dotnet build "RecipePlatform.sln" -c Release -o /app/build

# Publish stage
FROM build AS publish
RUN dotnet publish "src/RecipePlatform.API/RecipePlatform.API.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Final stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=publish /app/publish .

# Expose ports
EXPOSE 80
EXPOSE 443

# Environment variables
ENV ASPNETCORE_ENVIRONMENT=Production
ENV ASPNETCORE_URLS=http://+:80

ENTRYPOINT ["dotnet", "RecipePlatform.API.dll"]