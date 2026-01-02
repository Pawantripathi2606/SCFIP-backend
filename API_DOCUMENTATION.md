# API Documentation - SCFIP Backend

Complete API reference for the Smart Customer Feedback Intelligence Platform backend.

## Base URL

**Local Development:**
```
http://localhost:8000
```

**Production (Render):**
```
https://scfip-backend.onrender.com
```

## Authentication

Currently, the API does not require authentication. For production use, consider implementing API keys or OAuth.

## Response Format

All responses are in JSON format.

**Success Response:**
```json
{
  "message": "Success message",
  "data": {...}
}
```

**Error Response:**
```json
{
  "detail": "Error description"
}
```

---

## Endpoints

### 1. Health Check

Check API and models status.

**Endpoint:** `GET /health`

**Response:**
```json
{
  "status": "healthy",
  "models_loaded": true,
  "database": "connected"
}
```

---

### 2. Root Information

Get API information and available endpoints.

**Endpoint:** `GET /`

**Response:**
```json
{
  "message": "Smart Customer Feedback Intelligence Platform API",
  "version": "1.0.0",
  "docs": "/docs",
  "endpoints": {
    "add_feedback": "POST /api/feedback/add",
    "bulk_upload": "POST /api/feedback/bulk",
    ...
  }
}
```

---

## Feedback Management

### 3. Add Feedback

Add a single feedback entry to the database.

**Endpoint:** `POST /api/feedback/add`

**Request Body:**
```json
{
  "feedback_id": "F001",
  "text": "Great product! Very satisfied.",
  "source": "Mobile App",
  "date": "2026-01-02"
}
```

**Parameters:**
- `feedback_id` (string, required): Unique identifier
- `text` (string, required): Feedback text content
- `source` (string, required): Source of feedback (Mobile App, Web, Support)
- `date` (string, required): Date in YYYY-MM-DD format

**Response:**
```json
{
  "message": "Feedback F001 added successfully",
  "success": true
}
```

**Error Responses:**
- `400 Bad Request`: Feedback ID already exists
- `422 Unprocessable Entity`: Invalid request format

---

### 4. Bulk Upload

Add multiple feedback entries at once.

**Endpoint:** `POST /api/feedback/bulk`

**Request Body:**
```json
{
  "feedbacks": [
    {
      "feedback_id": "F001",
      "text": "Great product!",
      "source": "Mobile App",
      "date": "2026-01-02"
    },
    {
      "feedback_id": "F002",
      "text": "App crashes frequently",
      "source": "Web",
      "date": "2026-01-02"
    }
  ]
}
```

**Response:**
```json
{
  "message": "Added 2 feedback entries. 0 duplicates skipped.",
  "success": true
}
```

---

### 5. Get All Feedback

Retrieve all feedback with optional filters.

**Endpoint:** `GET /api/feedback/all`

**Query Parameters:**
- `limit` (integer, optional): Maximum number of results
- `source` (string, optional): Filter by source
- `sentiment` (string, optional): Filter by sentiment (Positive, Neutral, Negative)

**Example:**
```
GET /api/feedback/all?limit=10&sentiment=Negative
```

**Response:**
```json
[
  {
    "id": 1,
    "feedback_id": "F001",
    "text": "Great product!",
    "source": "Mobile App",
    "date": "2026-01-02",
    "sentiment": "Positive",
    "sentiment_score": 0.95,
    "intent": "Praise",
    "intent_score": 0.89,
    "created_at": "2026-01-02 10:30:00"
  }
]
```

---

### 6. Get Specific Feedback

Get a single feedback entry by ID.

**Endpoint:** `GET /api/feedback/{feedback_id}`

**Example:**
```
GET /api/feedback/F001
```

**Response:**
```json
{
  "id": 1,
  "feedback_id": "F001",
  "text": "Great product!",
  "source": "Mobile App",
  "date": "2026-01-02",
  "sentiment": "Positive",
  "sentiment_score": 0.95,
  "intent": "Praise",
  "intent_score": 0.89,
  "created_at": "2026-01-02 10:30:00"
}
```

**Error Responses:**
- `404 Not Found`: Feedback ID not found

---

## Analysis

### 7. Analyze Text

Analyze any text using NLP and Deep Learning models.

**Endpoint:** `POST /api/analyze`

**Request Body:**
```json
{
  "text": "This product is amazing! I love it."
}
```

**Response:**
```json
{
  "text": "This product is amazing! I love it.",
  "sentiment": "Positive",
  "sentiment_score": 0.95,
  "intent": "Praise",
  "intent_score": 0.89
}
```

**Sentiment Values:**
- `Positive`: Positive sentiment
- `Neutral`: Neutral sentiment
- `Negative`: Negative sentiment

**Intent Values:**
- `Bug Report`: Reporting a bug or issue
- `Feature Request`: Requesting a new feature
- `Praise`: Positive feedback or compliment
- `Complaint`: Negative feedback or complaint
- `Question`: Asking a question
- `Other`: Other types of feedback

**Error Responses:**
- `503 Service Unavailable`: Models not trained yet

---

### 8. Analyze Stored Feedback

Analyze a specific feedback entry already in the database.

**Endpoint:** `POST /api/feedback/analyze/{feedback_id}`

**Example:**
```
POST /api/feedback/analyze/F001
```

**Response:**
```json
{
  "message": "Feedback F001 analyzed and updated successfully",
  "success": true
}
```

**Error Responses:**
- `404 Not Found`: Feedback ID not found
- `503 Service Unavailable`: Models not trained

---

### 9. Analyze All Feedback

Analyze all unprocessed feedback entries in the database.

**Endpoint:** `POST /api/feedback/analyze-all`

**Response:**
```json
{
  "message": "Analyzed 15 feedback entries",
  "success": true
}
```

**Error Responses:**
- `503 Service Unavailable`: Models not trained

---

## Analytics

### 10. Get Analytics Summary

Get overall statistics and distributions.

**Endpoint:** `GET /api/analytics/summary`

**Response:**
```json
{
  "total_feedback": 100,
  "avg_sentiment_score": 0.72,
  "top_intent": "Praise",
  "sentiment_distribution": {
    "Positive": 60,
    "Neutral": 25,
    "Negative": 15
  },
  "intent_distribution": {
    "Praise": 45,
    "Bug Report": 20,
    "Feature Request": 18,
    "Complaint": 12,
    "Question": 5
  },
  "source_distribution": {
    "Mobile App": 50,
    "Web": 35,
    "Support": 15
  }
}
```

---

### 11. Get Trends

Get sentiment trends over time.

**Endpoint:** `GET /api/analytics/trends`

**Response:**
```json
{
  "trends": [
    {
      "date": "2026-01-01",
      "sentiment": "Positive",
      "count": 25
    },
    {
      "date": "2026-01-01",
      "sentiment": "Negative",
      "count": 5
    },
    {
      "date": "2026-01-02",
      "sentiment": "Positive",
      "count": 30
    }
  ]
}
```

---

### 12. Get Negative Feedback

Get most recent negative feedback for quick review.

**Endpoint:** `GET /api/analytics/negative-feedback`

**Query Parameters:**
- `limit` (integer, optional, default: 10): Number of results

**Example:**
```
GET /api/analytics/negative-feedback?limit=5
```

**Response:**
```json
[
  {
    "id": 15,
    "feedback_id": "F015",
    "text": "App crashes frequently",
    "source": "Mobile App",
    "date": "2026-01-02",
    "sentiment": "Negative",
    "sentiment_score": 0.85,
    "intent": "Bug Report",
    "intent_score": 0.92,
    "created_at": "2026-01-02 14:30:00"
  }
]
```

---

## Error Codes

| Code | Description |
|------|-------------|
| 200 | Success |
| 400 | Bad Request - Invalid input |
| 404 | Not Found - Resource not found |
| 422 | Unprocessable Entity - Validation error |
| 503 | Service Unavailable - Models not trained |

---

## Rate Limiting

Currently, no rate limiting is implemented. For production use, consider implementing rate limits to prevent abuse.

---

## CORS

The API allows cross-origin requests from all origins (`*`). For production, update `backend/main.py` to specify allowed origins:

```python
app.add_middleware(
    CORSMiddleware,
    allow_origins=["https://your-frontend.streamlit.app"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

---

## Interactive Documentation

The API provides interactive documentation using Swagger UI and ReDoc:

- **Swagger UI**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc

These interfaces allow you to:
- View all endpoints
- Test API calls directly
- See request/response schemas
- Download OpenAPI specification

---

## Code Examples

### Python

```python
import requests

# Analyze text
response = requests.post(
    "http://localhost:8000/api/analyze",
    json={"text": "Great product!"}
)
result = response.json()
print(f"Sentiment: {result['sentiment']}")
print(f"Intent: {result['intent']}")

# Add feedback
response = requests.post(
    "http://localhost:8000/api/feedback/add",
    json={
        "feedback_id": "F001",
        "text": "Great product!",
        "source": "Mobile App",
        "date": "2026-01-02"
    }
)
print(response.json())

# Get analytics
response = requests.get("http://localhost:8000/api/analytics/summary")
analytics = response.json()
print(f"Total Feedback: {analytics['total_feedback']}")
```

### JavaScript

```javascript
// Analyze text
fetch('http://localhost:8000/api/analyze', {
  method: 'POST',
  headers: {'Content-Type': 'application/json'},
  body: JSON.stringify({text: 'Great product!'})
})
.then(response => response.json())
.then(data => {
  console.log('Sentiment:', data.sentiment);
  console.log('Intent:', data.intent);
});

// Get analytics
fetch('http://localhost:8000/api/analytics/summary')
.then(response => response.json())
.then(data => {
  console.log('Total Feedback:', data.total_feedback);
});
```

### cURL

```bash
# Analyze text
curl -X POST "http://localhost:8000/api/analyze" \\
  -H "Content-Type: application/json" \\
  -d '{"text": "Great product!"}'

# Add feedback
curl -X POST "http://localhost:8000/api/feedback/add" \\
  -H "Content-Type: application/json" \\
  -d '{
    "feedback_id": "F001",
    "text": "Great product!",
    "source": "Mobile App",
    "date": "2026-01-02"
  }'

# Get analytics
curl "http://localhost:8000/api/analytics/summary"
```

---

## Support

For API issues or questions:
- Check the interactive docs at `/docs`
- Review this documentation
- Open an issue on GitHub
- Check the main README.md

---

**API Version:** 1.0.0  
**Last Updated:** 2026-01-02
