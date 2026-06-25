$RABBITMQ_API="http://localhost:15672/api"
$USER="guest"
$PASS="guest"
$VHOST="%2F"
$EXCHANGE="campus.exchange"

$pair = "$($USER):$($PASS)"
$bytes = [System.Text.Encoding]::ASCII.GetBytes($pair)
$base64 = [System.Convert]::ToBase64String($bytes)
$basicAuthValue = "Basic $base64"

$headers = @{
    "Authorization" = $basicAuthValue
    "Content-Type" = "application/json"
}

Write-Host "Creando exchange..."
$exchangeBody = @{
    type = "direct"
    durable = $true
} | ConvertTo-Json

Invoke-RestMethod -Uri "$RABBITMQ_API/exchanges/$VHOST/$EXCHANGE" -Method Put -Headers $headers -Body $exchangeBody

Write-Host "`nCreando colas..."
$queues = @(
 "campus.requests.in",
 "campus.admissions.queue",
 "campus.payments.queue",
 "campus.support.queue",
 "campus.academic.queue",
 "campus.manual-review.queue"
)

foreach ($queue in $queues) {
    $queueBody = @{
        durable = $true
    } | ConvertTo-Json
    Invoke-RestMethod -Uri "$RABBITMQ_API/queues/$VHOST/$queue" -Method Put -Headers $headers -Body $queueBody
    Write-Host "Cola creada: $queue"
}

Write-Host "`nCreando bindings..."
foreach ($queue in $queues) {
    $bindingBody = @{
        routing_key = $queue
    } | ConvertTo-Json
    Invoke-RestMethod -Uri "$RABBITMQ_API/bindings/$VHOST/e/$EXCHANGE/q/$queue" -Method Post -Headers $headers -Body $bindingBody
    Write-Host "Binding creado para routing key: $queue"
}

Write-Host "`nConfiguración de RabbitMQ completada."
