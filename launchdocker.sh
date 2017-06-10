#!/bin/sh

# Cleanup old images, if they exist
docker rm mssql
docker rm shinyserver
docker rm rstudioweb

# Launch SQL Server
docker run -v '/Users/dthole/Programming/r-shiny-docker:/data' -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=pAssw04d' --name mssql -p 1433:1433 -d microsoft/mssql-server-linux

# Launch Shiny Server
docker run -d --name shinyserver -p 3838:3838 --link mssql:mssql -v '/Users/dthole/Programming/r-shiny-docker/Shiny:/srv/shiny-server/' -v '/Users/dthole/Programming/r-shiny-docker/Shiny.Logs:/var/log/shiny-server/' thedarktrumpet/shiny:v1

# Launch rstudioweb
docker run -v '/Users/dthole/Programming/r-shiny-docker:/home/rstudio/src' --name rstudioweb --link mssql:mssql -d -p 8787:8787 thedarktrumpet/rstudio:v2

echo "Rstudio Server: http://localhost:8787"
echo "Shiny Server: http://localhost:3838"

echo "Restoring database backup"
sleep 20

# Restore database backup
docker run -v '/Users/dthole/Programming/r-shiny-docker/:/data/' --link mssql:mssql -it fabiang/sqlcmd -S mssql -U sa -P pAssw04d '-i/data/Data/RestoreDatabase.sql'
