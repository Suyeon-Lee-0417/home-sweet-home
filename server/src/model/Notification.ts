import mongoose, {Document, Schema, Types} from "mongoose";

export interface INotification extends Document {
  senderId: Schema.Types.ObjectId; // references User
  receiverId: Schema.Types.ObjectId; // references User
  taskId: Schema.Types.ObjectId; // references Task
  message: string;
  read: boolean;
}

const NotificationSchema: Schema = new Schema(
  {
    senderId: {type: Schema.Types.ObjectId, ref: "User", required: true},
    receiverId: {type: Schema.Types.ObjectId, ref: "User", required: true},
    taskId: {type: Schema.Types.ObjectId, ref: "Task", required: true},
    message: {type: String, required: true},
    read: {type: Boolean, default: false}
  },
  {timestamps: true}
);

export default mongoose.model<INotification>("Notification", NotificationSchema);
