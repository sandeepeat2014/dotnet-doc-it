FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 5002

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["dotnet-doc-it.csproj", "./"]
RUN dotnet restore "dotnet-doc-it.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "dotnet-doc-it.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "dotnet-doc-it.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "dotnet-doc-it.dll"]
