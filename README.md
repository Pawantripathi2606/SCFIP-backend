# SCFIP Backend API

**Smart Customer Feedback Intelligence Platform - FastAPI Backend**

A powerful REST API for analyzing customer feedback using NLP and Deep Learning. This backend provides sentiment analysis, intent classification, and comprehensive analytics for customer feedback data.

## 🚀 Features

- **Sentiment Analysis**: Bi-LSTM model for accurate sentiment classification (Positive/Neutral/Negative)
- **Intent Classification**: LSTM model for categorizing feedback intent
- **NLP Pipeline**: Advanced text preprocessing with spaCy and NLTK
- **RESTful API**: FastAPI-powered endpoints with automatic documentation
- **Database**: SQLite for persistent feedback storage
- **Analytics**: Comprehensive analytics and trend analysis
- **CORS Enabled**: Ready for frontend integration

## 📋 Prerequisites

- Python 3.10+
- pip (Python package manager)
- Git

## 🛠️ Local Setup

### 1. Clone the Repository

```bash
git clone https://github.com/Pawantripathi2606/SCFIP-backend.git
cd SCFIP-backend
```

### 2. Create Virtual Environment

```bash
python -m venv venv

# Windows
venv\\Scripts\\activate

# Linux/Mac
source venv/bin/activate
```

### 3. Install Dependencies

```bash
pip install -r requirements.txt
```

### 4. Download NLTK Data

```bash
python -c "import nltk; nltk.download('punkt'); nltk.download('stopwords'); nltk.download('wordnet')"
```

### 5. Train ML Models

```bash
python ml/train_models.py
```

This will train both sentiment and intent classification models (~5-10 minutes).

### 6. Run the Server

```bash
uvicorn backend.main:app --reload
```

The API will be available at:
- **API**: http://localhost:8000
- **Interactive Docs**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc

## 📡 API Endpoints

### Health Check
- `GET /health` - Check API and models status

### Feedback Management
- `POST /api/feedback/add` - Add single feedback
- `POST /api/feedback/bulk` - Add multiple feedback entries
- `GET /api/feedback/all` - Get all feedback (with filters)
- `GET /api/feedback/{feedback_id}` - Get specific feedback

### Analysis
- `POST /api/analyze` - Analyze any text
- `POST /api/feedback/analyze/{feedback_id}` - Analyze stored feedback
- `POST /api/feedback/analyze-all` - Analyze all unprocessed feedback

### Analytics
- `GET /api/analytics/summary` - Get overall statistics
- `GET /api/analytics/trends` - Get sentiment trends over time
- `GET /api/analytics/negative-feedback` - Get recent negative feedback

## 📝 API Usage Examples

### Analyze Text

```bash
curl -X POST "http://localhost:8000/api/analyze" \\
  -H "Content-Type: application/json" \\
  -d '{"text": "This product is amazing! I love it."}'
```

Response:
```json
{
  "text": "This product is amazing! I love it.",
  "sentiment": "Positive",
  "sentiment_score": 0.95,
  "intent": "Praise",
  "intent_score": 0.89
}
```

### Add Feedback

```bash
curl -X POST "http://localhost:8000/api/feedback/add" \\
  -H "Content-Type: application/json" \\
  -d '{
    "feedback_id": "F001",
    "text": "Great service!",
    "source": "Mobile App",
    "date": "2026-01-02"
  }'
```

### Get Analytics

```bash
curl "http://localhost:8000/api/analytics/summary"
```

## 🌐 Deployment to Render

See [RENDER_DEPLOYMENT.md](RENDER_DEPLOYMENT.md) for detailed deployment instructions.

### Quick Deploy

1. Push code to GitHub
2. Go to [dashboard.render.com](https://dashboard.render.com)
3. Create new Web Service
4. Configure:
   - **Build Command**: `pip install -r requirements.txt && chmod +x build.sh && ./build.sh`
   - **Start Command**: `uvicorn backend.main:app --host 0.0.0.0 --port $PORT`
5. Deploy!

## 🔧 Configuration

### Environment Variables

Create a `.env` file (see `.env.example`):

```env
API_HOST=0.0.0.0
API_PORT=8000
ENVIRONMENT=production
DATABASE_PATH=./feedback.db
CORS_ORIGINS=*
```

### CORS Configuration

For production, update `backend/main.py` to specify allowed origins:

```python
app.add_middleware(
    CORSMiddleware,
    allow_origins=["https://your-frontend.streamlit.app"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

## 📊 Project Structure

```
SCFIP-backend/
├── backend/
│   ├── __init__.py
│   ├── main.py              # FastAPI app
│   ├── database/
│   │   ├── __init__.py
│   │   └── db.py            # Database operations
│   ├── routes/
│   │   ├── __init__.py
│   │   └── feedback.py      # API endpoints
│   └── schemas/
│       ├── __init__.py
│       └── feedback.py      # Pydantic models
├── ml/
│   ├── __init__.py
│   ├── nlp_pipeline.py      # Text preprocessing
│   ├── sentiment_model.py   # Sentiment analysis
│   ├── intent_model.py      # Intent classification
│   ├── train_models.py      # Model training
│   └── models/              # Trained models (created during build)
├── data/
│   └── sample_feedback.csv  # Sample data
├── config.py                # Configuration
├── requirements.txt         # Python dependencies
├── Procfile                 # Render deployment
├── build.sh                 # Build script
├── runtime.txt              # Python version
└── README.md               # This file
```

## 🧪 Testing

### Test Health Endpoint

```bash
curl http://localhost:8000/health
```

### Test Analysis

```bash
curl -X POST "http://localhost:8000/api/analyze" \\
  -H "Content-Type: application/json" \\
  -d '{"text": "The app crashes frequently"}'
```

### Load Sample Data

```bash
# Use the sample CSV file
python -c "
import pandas as pd
import requests

df = pd.read_csv('data/sample_feedback.csv')
for _, row in df.iterrows():
    requests.post('http://localhost:8000/api/feedback/add', json=row.to_dict())
"
```

## 🔍 Troubleshooting

### Models Not Loading

**Issue**: `Models not trained yet` error

**Solution**:
```bash
python ml/train_models.py
```

### Port Already in Use

**Issue**: `Address already in use` error

**Solution**:
```bash
# Use a different port
uvicorn backend.main:app --port 8001
```

### NLTK Data Not Found

**Issue**: `Resource punkt not found` error

**Solution**:
```bash
python -c "import nltk; nltk.download('punkt'); nltk.download('stopwords'); nltk.download('wordnet')"
```

## 📚 Documentation

- **API Documentation**: http://localhost:8000/docs (when running locally)
- **Deployment Guide**: [RENDER_DEPLOYMENT.md](RENDER_DEPLOYMENT.md)
- **API Reference**: [API_DOCUMENTATION.md](API_DOCUMENTATION.md)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## 📄 License

This project is part of the Smart Customer Feedback Intelligence Platform.

## 🔗 Related Repositories

- **Frontend Dashboard**: [SCFIP Frontend](https://github.com/Pawantripathi2606/Smart-Customer-Feedback-Intelligence-Platform-SCFIP-)

## 📞 Support

For issues and questions:
- Open an issue on GitHub
- Check the documentation
- Review the API docs at `/docs`

---

**Built with FastAPI, TensorFlow, and ❤️**
