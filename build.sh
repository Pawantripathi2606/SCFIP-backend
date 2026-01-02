#!/bin/bash

echo "Starting build process..."

# Download NLTK data
echo "Downloading NLTK data..."
python -c "import nltk; nltk.download('punkt'); nltk.download('punkt_tab'); nltk.download('stopwords'); nltk.download('wordnet'); nltk.download('omw-1')"

# Train ML models
echo "Training ML models..."
python ml/train_models.py

echo "Build complete!"
