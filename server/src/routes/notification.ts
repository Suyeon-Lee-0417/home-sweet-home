import {sendNotificationToDevice} from "../notify/notifications";
import {Request, Response, Router} from "express";
import User from "../model/User";
import Task from "../model/Task";

const router = Router();

// POST /api/notification/ping
// Example endpoint for a user pinging another user
router.post("/notifications/ping", async (req: Request, res: Response) => {
  const {uid, taskId} = req.body;
  if (!uid || !taskId) {
    return res.status(400).json({error: "Missing required fields"});
  }

  console.log("uid", uid);
  console.log("taskId", taskId);
  const sender = await User.findOne({firebaseUid: uid});
  const task = await Task.findById(taskId);
  if (!sender || !task || !task.assignedTo) {
    return res.status(404).json({error: "User or task not found"});
  }

  const receiver = await User.findById(task.assignedTo);
  if (!receiver) {
    return res.status(404).json({error: "Receiver not found"});
  }

  const payload = {
    title: "Congratulation! You received an offer from Amazon!",
    body: `${sender.firstName} ${sender.lastName} just dropped a ping—apparently, even superheroes have chores! Time to show 'em your magic. 😉`
  };

  if (!receiver.fcmToken) {
    return res.status(400).json({error: "User has no FCM token"});
  }

  try {
    await sendNotificationToDevice(receiver.fcmToken, payload);
    res.status(200).json({message: "Notification sent"});
  } catch (error) {
    res.status(500).json({error: "Notification failed to send"});
  }
});

export default router;
