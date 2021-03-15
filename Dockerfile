FROM mcr.microsoft.com/dotnet/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build
WORKDIR /src
COPY ["CloudNativeApi.csproj", "./"]
RUN dotnet restore "CloudNativeApi.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "CloudNativeApi.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "CloudNativeApi.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "CloudNativeApi.dll"]
