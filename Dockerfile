FROM mcr.microsoft.com/dotnet/core/aspnet:3.0-alpine AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/core/sdk:3.0-alpine  AS build
WORKDIR /src

COPY . ./
RUN dotnet restore -nowarn:msb3202,nu1503 StorseilWeb.sln

FROM build AS publish
RUN dotnet publish -c Release -o /app StorseilWeb.sln

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
#RUN apt-get update && apt-get install -y \
#	procps \
#	less 
RUN addgroup -g 9999 appgroup
RUN adduser -S -u 9999 -g appgroup appuser
RUN chown -R appuser:appgroup /app
	
USER appuser
ENTRYPOINT ["dotnet", "StorseilWeb.dll"]
