# syntax=docker/dockerfile:1
# FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env
# ENV http_proxy http://proxy.fpts.com.vn:8080
# ENV https_proxy http://proxy.fpts.com.vn:8080
# WORKDIR /app
# Copy csproj and restore as distinct layers
# COPY APIDemo/*.csproj .
# RUN dotnet restore

# Copy everything else and build
# COPY . .
# RUN dotnet publish "APIDemo.csproj" -c Release -o out

# Build runtime image
# FROM mcr.microsoft.com/dotnet/aspnet:6.0
# WORKDIR /app
# COPY --from=build-env /app/out .
# ENTRYPOINT ["dotnet", "APIDemo.dll"]



#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY APIDemo/*.csproj .
RUN dotnet restore "./APIDemo.csproj"
COPY APIDemo/. .
WORKDIR "/src/."
RUN dotnet build "APIDemo.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "APIDemo.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "APIDemo.dll"]