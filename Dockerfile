#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 7777

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ./SignalRChat/SignalRChat.csproj .
RUN dotnet restore ./SignalRChat-along_tutorial.cs.csproj
COPY ./SignalRChat-along_tutorial.cs .
RUN dotnet build ./SignalRChat-along_tutorial.cs.csproj -c Release -o /app/build

FROM build AS publish
RUN dotnet publish SignalRChat-along_tutorial.cs.csproj -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "SignalRChat-along_tutorial.cs.dll"]
