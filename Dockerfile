FROM microsoft/dotnet:aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 80

FROM microsoft/dotnet:sdk AS build
WORKDIR /src
COPY *.csproj ./
RUN dotnet restore -nowarn:msb3202,nu1503
COPY . ./

FROM build AS publish
RUN dotnet publish -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "StorseilWeb.dll"]
