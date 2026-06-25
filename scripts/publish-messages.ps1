$RABBITMQ_API="http://localhost:15672/api"
$USER="guest"
$PASS="guest"
$VHOST="%2F"
$EXCHANGE="campus.exchange"
$ROUTING_KEY="campus.requests.in"

$pair = "$($USER):$($PASS)"
$bytes = [System.Text.Encoding]::ASCII.GetBytes($pair)
$base64 = [System.Convert]::ToBase64String($bytes)
$basicAuthValue = "Basic $base64"

$headers = @{
    "Authorization" = $basicAuthValue
    "Content-Type" = "application/json"
}

function Publish-Message($message) {
    $publishBody = @{
        properties = @{
            content_type = "application/json"
        }
        routing_key = $ROUTING_KEY
        payload = $message
        payload_encoding = "string"
    } | ConvertTo-Json -Depth 5
    
    $uri = "$RABBITMQ_API/exchanges/$VHOST/$EXCHANGE/publish"
    $response = Invoke-RestMethod -Uri $uri -Method Post -Headers $headers -Body $publishBody
    
    Write-Host "`nMensaje publicado:"
    Write-Host $message
}

Write-Host "Publicando mensaje ADMISSION..."
Publish-Message '{
 "request_id": "REQ-1001",
 "student_name": "Ana Pérez",
 "student_document": "1712345678",
 "request_type": "ADMISSION",
 "channel": "web",
 "created_at": "2026-06-10T10:30:00"
}'

Write-Host "Publicando mensaje PAYMENT..."
Publish-Message '{
 "request_id": "REQ-1002",
 "student_name": "Luis Gómez",
 "student_document": "1722222222",
 "request_type": "PAYMENT",
 "channel": "mobile",
 "created_at": "2026-06-10T11:00:00"
}'

Write-Host "Publicando mensaje SUPPORT..."
Publish-Message '{
 "request_id": "REQ-1003",
 "student_name": "Carla Torres",
 "student_document": "1733333333",
 "request_type": "SUPPORT",
 "channel": "admin-platform",
 "created_at": "2026-06-10T11:30:00"
}'

Write-Host "Publicando mensaje ACADEMIC..."
Publish-Message '{
 "request_id": "REQ-1004",
 "student_name": "Pedro Morales",
 "student_document": "1744444444",
 "request_type": "ACADEMIC",
 "channel": "web",
 "created_at": "2026-06-10T12:00:00"
}'

Write-Host "Publicando mensaje con tipo no reconocido..."
Publish-Message '{
 "request_id": "REQ-1005",
 "student_name": "María Sánchez",
 "student_document": "1755555555",
 "request_type": "LIBRARY",
 "channel": "web",
 "created_at": "2026-06-10T12:30:00"
}'

Write-Host "Publicando mensaje inválido..."
Publish-Message '{
 "request_id": "REQ-1006",
 "student_name": "Diego Ruiz",
 "channel": "web"
}'
