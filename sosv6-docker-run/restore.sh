#!/bin/bash
/opt/mssql/bin/sqlservr &

echo "Esperando a que SQL Server esté disponible..."
for i in {1..50};
do
    /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "${MSSQL_SA_PASSWORD}" -C -Q "SELECT 1" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "SQL Server listo después de $i segundos."
        break
    fi
    sleep 1s
done

if [ $? -ne 0 ]; then
    echo "ERROR: SQL Server no inició tras 50 segundos. Abortando..."
    exit 1  
fi

echo "Verificando si la base de datos 'SOSv6DB' ya existe..."
/opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "${MSSQL_SA_PASSWORD}" -C -Q \
"IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'SOSv6DB')
BEGIN
    PRINT 'SOSv6DB no encontrada. Iniciando restauración desde backup...'
    RESTORE DATABASE SOSv6DB 
    FROM DISK = '/var/opt/mssql/backup/SOSv6DB.bak' 
    WITH MOVE 'SOSv6DB' TO '/var/opt/mssql/data/SOSv6DB.mdf', 
         MOVE 'SOSv6DB_log' TO '/var/opt/mssql/data/SOSv6DB.ldf'
END
ELSE
BEGIN
    PRINT 'SOSv6DB ya existe en el volumen persistente. Saltando restauración.'
END"

echo "Verificando si la base de datos 'SOSTest' ya existe..."
/opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "${MSSQL_SA_PASSWORD}" -C -Q \
"IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'SOSTest')
BEGIN
    PRINT 'SOSTest no encontrada. Iniciando restauración desde backup...'
    RESTORE DATABASE SOSTest 
    FROM DISK = '/var/opt/mssql/backup/SOSTest.bak' 
    WITH MOVE 'SOSTest' TO '/var/opt/mssql/data/SOSTest.mdf', 
         MOVE 'SOSTest_log' TO '/var/opt/mssql/data/SOSTest.ldf'
END
ELSE
BEGIN
    PRINT 'SOSTest ya existe en el volumen persistente. Saltando restauración.'
END"

wait