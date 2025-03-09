import mongoose, {Document, Schema} from "mongoose";

export interface ITeam extends Document {
  name: string;
  members: [Schema.Types.ObjectId]; // List of user IDs
  tasks: [Schema.Types.ObjectId]; // List of task IDs
  admin: string; // User ID of the admin
}

const TeamSchema: Schema = new Schema(
  {
    name: {type: String, required: true},
    members: {type: [Schema.Types.ObjectId], default: [], ref: "User"},
    tasks: {type: [Schema.Types.ObjectId], default: [], ref: "Task"},
    admin: {type: Schema.Types.ObjectId, required: true, ref: "User"}
  },
  {timestamps: true}
);

export default mongoose.model<ITeam>("Team", TeamSchema);
