FROM tancloud/hertzbeat:latest

COPY ["hertzbeat-collector.jar", "/opt/hertzbeat/lib/"]
