import cron from "node-cron";
import {sendNotificationToDevice} from "./notifications";
import Task from "../model/Task";
import User from "../model/User";

async function checkTaskDeadlines() {
  // Find tasks with deadlines 1 day from now
  const tomorrow = new Date();
  tomorrow.setDate(tomorrow.getDate() + 1);
  const startOfDay = new Date(tomorrow.setHours(0, 0, 0, 0));
  const endOfDay = new Date(tomorrow.setHours(23, 59, 59, 999));

  const tasks = await Task.find({
    dueDate: {$gte: startOfDay, $lte: endOfDay}
  });

  for (const task of tasks) {
    // Assuming each task document has a field `userToken` for the FCM token
    const payload = {
      title: "Task Reminder",
      body: `Your task "${task.title}" is due tomorrow.`,
      data: {taskId: task._id as string}
    };

    const reciever = await User.findById(task.assignedTo);
    if (!reciever) {
      console.error("User not found for task:", task._id);
      continue;
    }

    if (reciever.fcmToken) {
      await sendNotificationToDevice(reciever.fcmToken, payload);
    } else {
      console.error("FCM token not found for user:", reciever._id);
    }
  }
}

// Schedule the job to run every day at a specific time (e.g., 8 AM)
cron.schedule("0 8 * * *", () => {
  console.log("Running task deadline check job");
  checkTaskDeadlines().catch((err) => console.error("Job error:", err));
});
