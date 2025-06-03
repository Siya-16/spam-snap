### Spam Message Classifiation

Spam Message Classification is a mobile application built using Flutter that uses machine learning to classify text messages as Spam or Not Spam. It integrates with a FastAPI backend running a Naive Bayes classifier and stores classified messages in Supabase.

The app allows users to enter messages, get instant predictions, and swipe messages to manually label them, improving dataset quality.

- Key Use Case:

Every day, users receive dozens of unwanted or spammy messages. This app helps in identifying and filtering spam messages . It's lightweight, mobile-friendly, and deployable, making it useful for educational, research, or even practical anti-spam tools.

- Project Goals:

* Build an model that detects spam messages.

* Create a user-friendly mobile interface to scan and analyze messages.

* Store messages and results in a cloud database (Supabase).

* Allow real-time model interaction and result visualization.

* Provide an easy-to-deploy solution using open-source tools.

- Live Backend API
[https://spam-snap-api.onrender.com/predict]

- Features

* Classify messages using a trained Naive Bayes model
* FlipCard animation to reveal results (Spam or Not Spam)
* Save all predictions to Supabase (with confidence level)
* Add new messages easily via floating action button
* Clean and user-friendly UI

- How It Works

1. You type or paste a message into the app.
2. The message is sent to the FastAPI backend deployed on Render.
3. The backend returns a prediction and confidence score.
4. The result is shown using a flip-card UI.
5. All predictions are stored in the Supabase database.

- Screenshots

Include screenshots in a /screenshots folder and reference them like this:

Example:

### Home Screen and Prediction Result

![home](https://github.com/user-attachments/assets/2ed4f1f6-53ed-47f8-a896-8985855bfedb)




### Message Input 
### HAM Message
![ham (2)](https://github.com/user-attachments/assets/f72d4b23-235d-4d68-a621-53f038f76386)

### SPAM message
![spam](https://github.com/user-attachments/assets/aacaa897-8063-4c8e-bc0a-c6aa64072471)



- Technologies Used

Frontend (Flutter):

* Flutter (Dart)
* flip\_card
* supabase\_flutter
* http

Backend (FastAPI):

* Python
* FastAPI
* scikit-learn (Naive Bayes)
* joblib
* Render (deployment)

Database:

* Supabase (PostgreSQL)

- Deployment

* Backend is deployed on Render.
* Flutter app can be run on emulator/device or built for Android/iOS.



