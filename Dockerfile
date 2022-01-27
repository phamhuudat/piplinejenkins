# syntax=docker/dockerfile:1
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build-env
WORKDIR /app
ENV http_proxy=http://proxy.fpts.com.vn:8080
ENV https_proxy=http://proxy.fpts.com.vn:8080
# Copy csproj and restore as distinct layers
COPY APIDemo/*.csproj .
RUN dotnet restore

# Copy everything else and build
COPY . .
RUN dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:5.0
WORKDIR /app
ENV http_proxy=http://proxy.fpts.com.vn:8080
ENV https_proxy=http://proxy.fpts.com.vn:8080
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "apidemo.dll"]