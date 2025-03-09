import mongoose, {Document, Schema} from "mongoose";

export interface IRecurrence {
  frequency: "daily" | "weekly" | "monthly" | "yearly";
  interval: number;
  weekdays: number[];
  endDate?: Date;
}

export interface ITask extends Document {
  title: string;
  description: string;
  status: "pending" | "completed" | "not started";
  assignedTo: Schema.Types.ObjectId;
  createdBy: Schema.Types.ObjectId;
  teamId: Schema.Types.ObjectId;
  dueDate: Date;
  points: number;
  recurrence?: IRecurrence;
}

const RecurrenceSchema: Schema = new Schema(
  {
    frequency: {
      type: String,
      enum: ["daily", "weekly", "monthly", "yearly"],
      required: true
    },
    interval: {type: Number, required: true},
    weekdays: {type: [Number], required: true},
    endDate: {type: Date}
  },
  {_id: false}
);

const TaskSchema: Schema = new Schema(
  {
    title: {type: String, required: true},
    description: {type: String},
    status: {
      type: String,
      enum: ["pending", "completed", "not started"],
      default: "pending"
    },
    assignedTo: {type: Schema.Types.ObjectId, ref: "User", required: true},
    createdBy: {type: Schema.Types.ObjectId, ref: "User", required: true},
    teamId: {type: Schema.Types.ObjectId, ref: "Team", required: true},
    dueDate: {type: Date, required: true},
    points: {type: Number, required: true},
    recurrence: {type: RecurrenceSchema}
  },
  {timestamps: true}
);

export default mongoose.model<ITask>("Task", TaskSchema);
