import mongoose, {Document, Schema} from "mongoose";

export interface ITeam extends Document {
  name: string;
  memberIds: Schema.Types.ObjectId[]; // List of user IDs
  tasksIds: Schema.Types.ObjectId[]; // List of task IDs
  adminId: string; // User ID of the admin
}

const TeamSchema: Schema = new Schema(
  {
    name: {type: String, required: true},
    memberIds: {type: [Schema.Types.ObjectId], default: [], ref: "User"},
    tasksIds: {type: [Schema.Types.ObjectId], default: [], ref: "Task"},
    adminId: {type: Schema.Types.ObjectId, required: true, ref: "User"}
  },
  {timestamps: true}
);

export default mongoose.model<ITeam>("Team", TeamSchema);
