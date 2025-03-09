import {sendNotificationToDevice} from "../notify/notifications";
import {Request, Response, Router} from "express";
import admin from "../config/firebase";

const router = Router();

// POST /api/notifications
// Example endpoint for a user pinging another user
router.post("/api/notification/ping", async (req, res) => {
  const {targetToken, senderName, taskId} = req.body;

  if (!targetToken || !senderName) {
    return res.status(400).json({error: "Missing parameters"});
  }

  const payload = {
    title: "You have a new ping!",
    body: `${senderName} has just pinged you.`
  };

  try {
    await sendNotificationToDevice(targetToken, payload);
    res.status(200).json({message: "Notification sent"});
  } catch (error) {
    res.status(500).json({error: "Notification failed to send"});
  }
});
