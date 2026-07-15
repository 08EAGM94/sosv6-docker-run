<p>Ruta de la aplicación web una vez iniciado los contenedores (localhost y el puerto pueden ser modificables en el archivo docker-compose.yml):<br/> <strong>http://localhost:8080/SOSv6/service-order-system/home/</strong><br/>nickname administrador: <strong>EAGM</strong><br/>
contraseña: <strong>interpc_2025</strong></p>
<strong>Consideraciones</strong>:<br/>
<p>Puedes descargar Docker desktop dando click a este enlace: <a href="https://docs.docker.com/desktop/setup/install/windows-install/" target="_blank">Docker desktop</a></p>
<p>Una vez instalado en tu equipo, descarga la carpeta de este repositorio, abre docker desktop, abre una terminal apuntando a la carpeta descargada y escribe el comando docker-compose up (puedes modificar los puertos que creas conveniente en el archivo docker-compose.yml, solo hay que verificar si otra instancia de tu equipo esté usando ese puerto o si el puerto tiene permisos de conexión) </p>
<p>Una vez efectuado el comando "docker-compose up" justo en el contenido de esta carpeta (donde está el archivo docker-compose.yml), hay que esperar a que se termine de generar el contenedor de la base de datos, por lo que se recomienda no usar el modo detach en el comando, la terminal debe de mostrar el mensaje de base de datos restaurada si es la primera vez que se crean los contenedores:</p>
<img width="1125" height="289" alt="2026-03-22 20_44_05-docker-compose yml - online-store-repository - Visual Studio Code" src="https://github.com/user-attachments/assets/a9d1def6-90d5-4c66-b415-2749593a9fcd" />
<p>En caso de que se haya generado anteriormente los contenedores, tiene que aparecer el mensaje de recuperación:</p>
<img width="1125" height="289" alt="2026-03-28 21_32_54-Window" src="https://github.com/user-attachments/assets/65236174-4492-49c3-846f-ebc355eac000" />
<p>Esta aplicación web no funcionará correctamente si el contenedor de la base de datos no está listo, si sucede esto, se tendría que reiniciar el contenedor de la aplicación web.</p>
<br/>
<div align="center"><img width="848" height="145" alt="images" src="https://github.com/user-attachments/assets/6ec2418a-6f67-4379-9dc6-57991c58047b" /></div>
<p>Se puede ejecutar pruebas de las funcionalidades del sistema de ordenes de servicio en un CMD, tanto del lado del cliente (Jest) como del lado del servidor (Pest).<br/>
Ejecución de Pest: <strong>docker exec -w /var/www/html/SOSv6/service-order-system/ php_sosv6_app ./vendor/bin/pest -vvv</strong><br/>Ejecución de Jest: <strong>docker run --rm sosv6-jest:latest npm run test</strong></p>
