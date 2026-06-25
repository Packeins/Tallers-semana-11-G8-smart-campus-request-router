#!/bin/bash
RABBITMQ_API="http://localhost:15672/api"
USER="guest"
PASS="guest"
VHOST="%2F"
EXCHANGE="campus.exchange"
ROUTING_KEY="campus.requests.in"

publish_message() {
 local message="$1"
 curl -u $USER:$PASS -H "content-type:application/json" \
  -X POST $RABBITMQ_API/exchanges/$VHOST/$EXCHANGE/publish \
  -d "{
  \"properties\": {
    \"content_type\": \"application/json\"
  },
  \"routing_key\": \"$ROUTING_KEY\",
  \"payload\": $(echo "$message" | jq -Rs .),
  \"payload_encoding\": \"string\"
 }"
 echo ""
 echo "Mensaje publicado:"
 echo "$message"
 echo ""
}

echo "Publicando mensaje ADMISSION..."
publish_message '{
 "request_id": "REQ-1001",
 "student_name": "Ana Pérez",
 "student_document": "1712345678",
 "request_type": "ADMISSION",
 "channel": "web",
 "created_at": "2026-06-10T10:30:00"
}'

echo "Publicando mensaje PAYMENT..."
publish_message '{
 "request_id": "REQ-1002",
 "student_name": "Luis Gómez",
 "student_document": "1722222222",
 "request_type": "PAYMENT",
 "channel": "mobile",
 "created_at": "2026-06-10T11:00:00"
}'

echo "Publicando mensaje SUPPORT..."
publish_message '{
 "request_id": "REQ-1003",
 "student_name": "Carla Torres",
 "student_document": "1733333333",
 "request_type": "SUPPORT",
 "channel": "admin-platform",
 "created_at": "2026-06-10T11:30:00"
}'

echo "Publicando mensaje ACADEMIC..."
publish_message '{
 "request_id": "REQ-1004",
 "student_name": "Pedro Morales",
 "student_document": "1744444444",
 "request_type": "ACADEMIC",
 "channel": "web",
 "created_at": "2026-06-10T12:00:00"
}'

echo "Publicando mensaje con tipo no reconocido..."
publish_message '{
 "request_id": "REQ-1005",
 "student_name": "María Sánchez",
 "student_document": "1755555555",
 "request_type": "LIBRARY",
 "channel": "web",
 "created_at": "2026-06-10T12:30:00"
}'

echo "Publicando mensaje inválido..."
publish_message '{
 "request_id": "REQ-1006",
 "student_name": "Diego Ruiz",
 "channel": "web"
}'
