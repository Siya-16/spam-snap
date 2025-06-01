import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.naive_bayes import MultinomialNB
from sklearn.pipeline import Pipeline
from sklearn.metrics import accuracy_score
import joblib

# Load dataset with correct columns
df = pd.read_csv('spam.csv', encoding='latin-1')

# Use only needed columns (already label, message)
df = df[['label', 'message']]

# Map labels: 'ham' -> 0, 'spam' -> 1
df['label'] = df['label'].map({'ham': 0, 'spam': 1})

# Split into train and test sets
X_train, X_test, y_train, y_test = train_test_split(
    df['message'], df['label'], test_size=0.2, random_state=42)

# Build pipeline: vectorizer + naive bayes classifier
model = Pipeline([
    ('vectorizer', CountVectorizer()),
    ('classifier', MultinomialNB())
])

# Train the model
model.fit(X_train, y_train)

# Predict on test set
preds = model.predict(X_test)
print(f'Accuracy: {accuracy_score(y_test, preds):.2f}')

# Save the trained model
joblib.dump(model, 'spam_classifier.pkl')
print('Model saved as spam_classifier.pkl')
