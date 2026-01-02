# 🚀 Render Deployment Guide - SCFIP Backend

Complete guide for deploying the SCFIP FastAPI backend to Render.

## Prerequisites

- GitHub account
- Render account (sign up at [render.com](https://render.com))
- Code pushed to GitHub repository

## Deployment Steps

### 1. Prepare Your Repository

Ensure these files are in your repository:
- ✅ `backend/` - Backend application code
- ✅ `ml/` - ML models and training scripts
- ✅ `requirements.txt` - Python dependencies
- ✅ `Procfile` - Process configuration
- ✅ `runtime.txt` - Python version
- ✅ `build.sh` - Build script
- ✅ `config.py` - Configuration file

### 2. Push to GitHub

```bash
git init
git add .
git commit -m "Initial commit - SCFIP Backend"
git remote add origin https://github.com/Pawantripathi2606/SCFIP-backend.git
git push -u origin main
```

### 3. Create Web Service on Render

1. Go to [dashboard.render.com](https://dashboard.render.com)
2. Click **"New +"** → **"Web Service"**
3. Connect your GitHub account (if not already connected)
4. Select repository: `Pawantripathi2606/SCFIP-backend`

### 4. Configure Service

| Setting | Value |
|---------|-------|
| **Name** | `scfip-backend` (or your choice) |
| **Region** | Choose closest to you |
| **Branch** | `main` |
| **Runtime** | `Python 3` |
| **Build Command** | `pip install -r requirements.txt && chmod +x build.sh && ./build.sh` |
| **Start Command** | `uvicorn backend.main:app --host 0.0.0.0 --port $PORT` |
| **Plan** | `Free` |

### 5. Environment Variables (Optional)

Add in Render dashboard:

| Key | Value |
|-----|-------|
| `PYTHON_VERSION` | `3.10.12` |
| `ENVIRONMENT` | `production` |

### 6. Deploy

1. Click **"Create Web Service"**
2. Wait for deployment (~10-15 minutes)
3. Monitor logs for progress

## Deployment Timeline

| Phase | Duration | What Happens |
|-------|----------|--------------|
| **Build** | 5-8 min | Installs dependencies |
| **NLTK Download** | 1-2 min | Downloads NLTK data |
| **Model Training** | 3-5 min | Trains ML models |
| **Start** | 1 min | Starts FastAPI server |
| **Total** | ~10-15 min | Deployment complete |

## Monitoring Deployment

### Check Build Logs

1. Go to your service in Render dashboard
2. Click **"Logs"** tab
3. Watch for:
   ```
   Downloading NLTK data...
   Training ML models...
   Build complete!
   Application startup complete.
   ```

### Success Indicators

✅ **Successful Deployment:**
```
INFO:     Application startup complete.
INFO:     Uvicorn running on http://0.0.0.0:10000
```

❌ **Failed Deployment:**
- Check logs for specific error
- Verify all files are in repository
- Ensure build.sh has correct permissions

## Accessing Your API

Once deployed, Render provides a URL:
```
https://scfip-backend.onrender.com
```

### Test Endpoints

**Health Check:**
```bash
curl https://scfip-backend.onrender.com/health
```

**API Documentation:**
```
https://scfip-backend.onrender.com/docs
```

**Analyze Text:**
```bash
curl -X POST "https://scfip-backend.onrender.com/api/analyze" \\
  -H "Content-Type: application/json" \\
  -d '{"text": "Great product!"}'
```

## Connecting to Streamlit Cloud

### 1. Note Your Backend URL

After deployment, copy your Render URL:
```
https://scfip-backend.onrender.com
```

### 2. Configure Streamlit Cloud

In your Streamlit Cloud app settings:

1. Go to **"Secrets"**
2. Add:
   ```toml
   API_BASE_URL = "https://scfip-backend.onrender.com/api"
   ```

### 3. Update Dashboard Code

Modify `streamlit_app/dashboard.py`:

```python
import streamlit as st

# API Base URL
if "API_BASE_URL" in st.secrets:
    API_BASE_URL = st.secrets["API_BASE_URL"]
else:
    API_BASE_URL = "http://localhost:8000/api"
```

## Important Notes

### Free Tier Limitations

- **Spin Down**: App sleeps after 15 minutes of inactivity
- **Cold Start**: First request after sleep takes 30-60 seconds
- **Hours**: 750 hours/month free
- **Memory**: Limited RAM

### Model Training

- Models are trained during each deployment
- Takes ~3-5 minutes
- Models are stored in deployment instance
- Models persist between restarts (not redeploys)

### Database

- SQLite database is **NOT persistent** on free tier
- Data lost on redeploy
- For production, consider:
  - PostgreSQL (Render offers free tier)
  - External database service

### CORS Configuration

Update `backend/main.py` for production:

```python
app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "https://your-app.streamlit.app",
        "https://scfip-backend.onrender.com"
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

## Troubleshooting

### Issue: Build Timeout

**Solution:**
- Render free tier has build time limits
- Model training is acceptable (~5 min)
- If timeout, try deploying again

### Issue: Module Not Found

**Solution:**
- Ensure all dependencies in `requirements.txt`
- Check build logs for failed installations
- Verify Python version compatibility

### Issue: Models Not Loading

**Solution:**
- Check if `build.sh` executed successfully
- Look for "Training ML models..." in logs
- Verify model training completed

### Issue: Port Binding Error

**Solution:**
- Ensure start command uses `$PORT`
- Current command is correct:
  ```
  uvicorn backend.main:app --host 0.0.0.0 --port $PORT
  ```

### Issue: CORS Errors

**Solution:**
- Update `allow_origins` in `backend/main.py`
- Add your Streamlit Cloud URL
- Redeploy after changes

### Issue: Database Connection Failed

**Solution:**
- SQLite is file-based, no connection needed
- Check `config.py` for correct path
- Ensure write permissions

## Updating Your Deployment

### Automatic Deployment

Render automatically redeploys when you push to GitHub:

```bash
git add .
git commit -m "Update backend"
git push
```

### Manual Deployment

1. Go to Render dashboard
2. Select your service
3. Click **"Manual Deploy"** → **"Deploy latest commit"**

## Monitoring & Maintenance

### View Logs

```bash
# Real-time logs in Render dashboard
# Or use Render CLI
render logs -f
```

### Check Resource Usage

1. Go to service in Render dashboard
2. View **"Metrics"** tab
3. Monitor CPU, memory, requests

### Health Monitoring

Set up monitoring:
- Use `/health` endpoint
- Configure uptime monitoring (e.g., UptimeRobot)
- Get alerts for downtime

## Upgrading to Paid Tier

Benefits:
- ✅ No spin-down
- ✅ Persistent disk storage
- ✅ More CPU/memory
- ✅ Custom domains
- ✅ Priority support

## Best Practices

1. **Environment Variables**: Use for sensitive data
2. **Logging**: Monitor logs regularly
3. **Error Handling**: Implement proper error responses
4. **Rate Limiting**: Consider adding rate limits
5. **Caching**: Cache model predictions if needed
6. **Database**: Use PostgreSQL for production

## Support

- **Render Docs**: https://render.com/docs
- **Render Community**: https://community.render.com
- **GitHub Issues**: Report issues in your repository

---

## Summary

✅ **Deployment files ready**  
✅ **Configuration documented**  
✅ **Troubleshooting guide included**  
✅ **Ready to deploy!**

Your SCFIP backend will be live on Render in ~10-15 minutes! 🚀
