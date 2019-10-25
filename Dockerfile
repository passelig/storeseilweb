FROM microsoft/dotnet:aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 80

FROM microsoft/dotnet:sdk AS build
WORKDIR /src

COPY . ./
RUN dotnet restore -nowarn:msb3202,nu1503 StorseilWeb.sln

FROM build AS publish
RUN dotnet publish -c Release -o /app StorseilWeb.sln

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "StorseilWeb.dll"]
