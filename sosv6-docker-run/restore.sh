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

echo "Verificando si la base de datos 'SOSv5DB' ya existe..."
/opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "${MSSQL_SA_PASSWORD}" -C -Q \
"IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'SOSv5DB')
BEGIN
    PRINT 'SOSv5DB no encontrada. Iniciando restauración desde backup...'
    RESTORE DATABASE SOSv5DB 
    FROM DISK = '/var/opt/mssql/backup/SOSv5DB.bak' 
    WITH MOVE 'SOSv5DB' TO '/var/opt/mssql/data/SOSv5DB.mdf', 
         MOVE 'SOSv5DB_log' TO '/var/opt/mssql/data/SOSv5DB.ldf'
END
ELSE
BEGIN
    PRINT 'SOSv5DB ya existe en el volumen persistente. Saltando restauración.'
END"
/opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "${MSSQL_SA_PASSWORD}" -N -C -Q "USE SOSv5DB; UPDATE Usuarios SET Privilegio = 'Admin' WHERE Alias = 'ELENA86';"
wait