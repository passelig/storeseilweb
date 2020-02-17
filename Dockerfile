FROM microsoft/dotnet:aspnetcore-runtime AS base
WORKDIR /app

FROM microsoft/dotnet:sdk AS build
WORKDIR /src

COPY . ./
RUN dotnet restore -nowarn:msb3202,nu1503 StorseilWeb.sln

FROM build AS publish
RUN dotnet publish -c Release -o /app StorseilWeb.sln

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
RUN apt-get update && apt-get install -y \
	procps \
	less 
RUN	groupadd -g 999 appusergroup && \
    useradd -r -u 999 -g appusergroup appuser
	
USER appuser
ENTRYPOINT ["dotnet", "StorseilWeb.dll"]
