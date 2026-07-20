FROM python:3.12-slim
RUN apt-get update && apt-get install -y curl gnupg2 apt-transport-https unixodbc-dev \
  && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
  && curl https://packages.microsoft.com/config/debian/12/prod.list > /etc/apt/sources.list.d/mssql-release.list \
  && apt-get update && ACCEPT_EULA=Y apt-get install -y msodbcsql18
RUN pip install pyodbc
COPY FlowerShopDB.sql /FlowerShopDB.sql
COPY run_init.py /run_init.py
CMD ["python", "/run_init.py"]