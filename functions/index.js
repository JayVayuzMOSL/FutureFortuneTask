const express = require("express");
const cors = require("cors");
const admin = require("firebase-admin");
const serviceAccount = require(
    "./futurefortunetasks-firebase-adminsdk-fbsvc-664ef0a5a8.json",
);


// Initialize Express app
const app = express();
app.use(express.json());

// CORS Middleware
app.use(
    cors({
      origin: "*",
      methods: ["GET", "POST", "PUT", "DELETE", "PATCH"],
    }),
);


// Initialize Firebase Admin SDK
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

// API Endpoint to send FCM notification
app.post("/send", async (req, res) => {
  try {
    const {fcmToken} = req.body;

    if (!fcmToken) {
      return res.status(400).json({error: "FCM token is required"});
    }

    const message = {
      notification: {
        title: "New Notification",
        body: "This is a test notification from Firebase",
      },
      token: fcmToken,
    };

    const response = await admin.messaging().send(message);
    console.log("Successfully sent message:", response);

    res.status(200).json({
      message: "Notification sent successfully",
      token: fcmToken,
    });
  } catch (error) {
    console.error("Error sending message:", error);
    res.status(500).json({error: error.message});
  }
});

// Start Express server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
});
