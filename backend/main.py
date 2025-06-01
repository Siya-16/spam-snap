from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import joblib

model = joblib.load('spam_classifier.pkl')

app = FastAPI(title="SpamSnap API")

origins = [
    "http://localhost:8080",  # Replace with your actual frontend URL
    "*",  # Remove * in production, use specific allowed origins only
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class Message(BaseModel):
    text: str

@app.get("/")
async def root():
    return {"message": "Welcome to SpamSnap API"}

@app.post("/predict")
async def predict_spam(message: Message):
    prediction = model.predict([message.text])[0]
    label = "Spam" if prediction == 1 else "Not Spam"
    proba = model.predict_proba([message.text])[0]
    confidence = proba[prediction]

    return {
        "prediction": label,
        "confidence": round(confidence * 100, 2)
    }
