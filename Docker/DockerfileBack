#================================
# Stage One --> Runtime image
#================================
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80

#================================
# Stage Two --> Build & Update DB
#================================
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY *.csproj .
RUN dotnet restore 
COPY . .
RUN dotnet tool install --global dotnet-ef
ENV PATH="$PATH:/root/.dotnet/tools"
RUN dotnet build -c ${BUILD_CONFIGURATION} -o /app/build
RUN dotnet ef database update

#================================
# Stage Three --> Publish
#================================
FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish -c ${BUILD_CONFIGURATION} -o /app/publish /p:UseAppHost=false

#================================
# Stage Four --> Go Online
#================================
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT [ "dotnet", "EcoPowerHub.dll" ]