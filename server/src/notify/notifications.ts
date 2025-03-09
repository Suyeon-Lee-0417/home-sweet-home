import admin from "../config/firebase";

interface NotificationPayload {
  title: string;
  body: string;
  data?: {[key: string]: string};
}

export async function sendNotificationToDevice(token: string, payload: NotificationPayload) {
  const message = {
    notification: {
      title: payload.title,
      body: payload.body
    },
    data: payload.data,
    token: token
  };

  try {
    const response = await admin.messaging().send(message);
    console.log("Notification sent successfully:", response);
  } catch (error) {
    console.error("Error sending notification:", error);
  }
}
