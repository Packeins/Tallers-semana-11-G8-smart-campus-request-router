$env:JAVA_HOME="C:\Program Files\Java\jdk-21"
Write-Host "Iniciando compilación del proyecto con JDK 21..." -ForegroundColor Green
mvn clean package
if ($LASTEXITCODE -eq 0) {
    Write-Host "`nCompilación exitosa. Iniciando la aplicación..." -ForegroundColor Green
    java -jar target/smart-campus-request-router-1.0.0.jar
} else {
    Write-Host "`nError en la compilación. Verifica que JDK 21 esté instalado en C:\Program Files\Java\jdk-21." -ForegroundColor Red
}
