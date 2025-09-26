#!/bin/bash

set -e

echo "🚀 Initializing FlyBot project directory structure with tests under $(pwd)"

# -----------------------------
# Cleanup old backend
# -----------------------------
if [ -d "backend" ]; then
  echo "🧹 Cleaning up old backend files..."
  rm -rf backend/*
fi

# -----------------------------
# Core folders
# -----------------------------
mkdir -p backend/app/routes
mkdir -p backend/app/services
mkdir -p backend/app/models
mkdir -p backend/app/utils
mkdir -p backend/tests
mkdir -p frontend/src
mkdir -p infra/main
mkdir -p infra/modules/cloudrun
mkdir -p infra/modules/pubsub
mkdir -p infra/modules/storage
mkdir -p infra/workspaces/dev
mkdir -p infra/workspaces/prod
mkdir -p .github/workflows
mkdir -p argo/k8s-manifests

# -----------------------------
# Backend (FastAPI entrypoint)
# -----------------------------
cat > backend/app/main.py <<EOF
from fastapi import FastAPI
from app.routes import flights, chat, bookings

app = FastAPI(title="FlyBot API")

app.include_router(flights.router)
app.include_router(chat.router)
app.include_router(bookings.router)

@app.get("/ping")
async def ping():
    return {"message": "pong"}
EOF

# -----------------------------
# Models
# -----------------------------
cat > backend/app/models/__init__.py <<EOF
from .flight import Flight
from .booking import Booking
from .chat import ChatMessage
EOF

cat > backend/app/models/flight.py <<EOF
from pydantic import BaseModel
from datetime import datetime
from typing import Optional

class Flight(BaseModel):
    flight_id: str
    airline: str
    flight_number: str
    departure_airport: str
    arrival_airport: str
    departure_time: datetime
    arrival_time: datetime
    price: float
    currency: str
    seats_available: Optional[int] = None
EOF

cat > backend/app/models/booking.py <<EOF
from pydantic import BaseModel
from datetime import datetime

class Booking(BaseModel):
    booking_id: str
    flight_id: str
    user_id: str
    status: str
    booked_at: datetime
    total_price: float
    currency: str
EOF

cat > backend/app/models/chat.py <<EOF
from pydantic import BaseModel
from datetime import datetime
from typing import Optional

class ChatMessage(BaseModel):
    message_id: str
    user_id: str
    input_text: str
    response_text: Optional[str] = None
    timestamp: datetime
EOF

# -----------------------------
# Routes
# -----------------------------
cat > backend/app/routes/flights.py <<EOF
from fastapi import APIRouter
from app.services.amadeus_client import search_flights

router = APIRouter(prefix="/flights", tags=["flights"])

@router.get("/search")
async def search_flights_route(origin: str = "LOS", destination: str = "LHR", departure: str = "2025-11-18", return_date: str = "2025-12-07"):
    return search_flights(origin, destination, departure, return_date)
EOF

cat > backend/app/routes/chat.py <<EOF
from fastapi import APIRouter
from app.services.openai_client import parse_message

router = APIRouter(prefix="/chat", tags=["chat"])

@router.post("/")
async def chat(message: str):
    return parse_message(message)
EOF

cat > backend/app/routes/bookings.py <<EOF
from fastapi import APIRouter

router = APIRouter(prefix="/bookings", tags=["bookings"])

@router.post("/")
async def create_booking(flight_id: str):
    return {"status": "success", "flight_id": flight_id}
EOF

# -----------------------------
# Services
# -----------------------------
cat > backend/app/services/amadeus_client.py <<EOF
import os
from amadeus import Client, ResponseError

amadeus = Client(
    client_id=os.getenv("AMADEUS_CLIENT_ID", "your_client_id"),
    client_secret=os.getenv("AMADEUS_CLIENT_SECRET", "your_client_secret")
)

def search_flights(origin: str, destination: str, departure: str, return_date: str, adults: int = 1, non_stop: bool = True):
    try:
        response = amadeus.shopping.flight_offers_search.get(
            originLocationCode=origin,
            destinationLocationCode=destination,
            departureDate=departure,
            returnDate=return_date,
            adults=adults,
            nonStop=non_stop,
            currencyCode="USD",
            max=3
        )
        return response.data
    except ResponseError as e:
        return {"error": str(e)}
EOF

cat > backend/app/services/openai_client.py <<EOF
import os
import json
from openai import OpenAI

client = OpenAI(api_key=os.getenv("OPENAI_API_KEY", "your_api_key"))

def parse_message(user_message: str):
    prompt = f"""
    Extract flight search details from: "{user_message}".
    Return JSON with: origin, destination, departureDate, returnDate, adults, nonStop.
    """
    response = client.chat.completions.create(
        model="gpt-4o-mini",
        messages=[{"role": "user", "content": prompt}],
        temperature=0
    )
    try:
        parsed = json.loads(response.choices[0].message.content)
        return {"user_message": user_message, "parsed": parsed}
    except Exception:
        return {"user_message": user_message, "parsed": None, "raw": response.choices[0].message.content}
EOF

# -----------------------------
# Requirements
# -----------------------------
cat > backend/requirements.txt <<EOF
fastapi
uvicorn[standard]
httpx
python-dotenv
openai
amadeus
EOF

cat > backend/requirements-dev.txt <<EOF
-r requirements.txt
pytest
pytest-asyncio
pytest-mock
EOF

# -----------------------------
# Tests
# -----------------------------
cat > backend/tests/test_ping.py <<EOF
from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)

def test_ping():
    response = client.get("/ping")
    assert response.status_code == 200
    assert response.json() == {"message": "pong"}
EOF

cat > backend/tests/test_amadeus_client.py <<EOF
import pytest
from app.services import amadeus_client

def test_search_flights_mock(monkeypatch):
    class DummyResponse:
        data = [{"flight": "BA001", "price": "USD 500"}]

    def mock_get(*args, **kwargs):
        return DummyResponse()

    monkeypatch.setattr(amadeus_client.amadeus.shopping.flight_offers_search, "get", mock_get)
    results = amadeus_client.search_flights("LOS", "LHR", "2025-11-18", "2025-12-07")
    assert isinstance(results, list)
    assert results[0]["price"] == "USD 500"
EOF

cat > backend/tests/test_openai_client.py <<EOF
import pytest
from app.services import openai_client

def test_parse_message_mock(monkeypatch):
    class DummyChoice:
        message = type("obj", (object,), {"content": '{"origin":"LOS","destination":"LHR"}'})

    class DummyResponse:
        choices = [DummyChoice()]

    def mock_chat_completion(*args, **kwargs):
        return DummyResponse()

    monkeypatch.setattr(openai_client.client.chat.completions, "create", mock_chat_completion)
    result = openai_client.parse_message("Find me a flight from Lagos to London")
    assert "parsed" in result
    assert result["parsed"]["origin"] == "LOS"
EOF

# -----------------------------
# Dockerfile
# -----------------------------
cat > backend/Dockerfile <<EOF
FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY app app

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8080"]
EOF

# -----------------------------
# Frontend placeholder
# -----------------------------
cat > frontend/index.html <<EOF
<!DOCTYPE html>
<html>
<head>
  <title>FlyBot</title>
</head>
<body>
  <h1>Welcome to FlyBot</h1>
  <p>Chat interface will be implemented here.</p>
</body>
</html>
EOF

# -----------------------------
# Infra placeholders
# -----------------------------
touch infra/main/main.tf
touch infra/main/variables.tf
touch infra/main/outputs.tf

for module in cloudrun pubsub storage; do
    touch "infra/modules/$module/main.tf"
    touch "infra/modules/$module/variables.tf"
    touch "infra/modules/$module/outputs.tf"
done

touch infra/workspaces/dev/terraform.tfvars
touch infra/workspaces/prod/terraform.tfvars

# -----------------------------
# README
# -----------------------------
cat > README.md <<EOF
# FlyBot ✈️

FlyBot is a conversational flight search & booking assistant.

## Backend (Python FastAPI)
Run locally:
\`\`\`bash
cd backend
pip install -r requirements-dev.txt
uvicorn app.main:app --reload --port 8080
\`\`\`

Run tests:
\`\`\`bash
cd backend
pytest
\`\`\`

## Frontend
Simple placeholder under \`frontend/\`.

## Infrastructure
Terraform configs under \`infra/\`.
EOF

echo "✅ FlyBot project initialized with
