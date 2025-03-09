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
  isCompleted: boolean;
  assignedTo?: Schema.Types.ObjectId;
  createdByUid: string;
  teamId: Schema.Types.ObjectId;
  category: string;
  dueDate: Date;
  points: number;
  priority: string;
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
    isCompleted: {type: Boolean, default: false},
    assignedTo: {type: Schema.Types.ObjectId, ref: "User"},
    createdByUid: {type: String},
    category: {type: String, required: true},
    teamId: {type: Schema.Types.ObjectId, ref: "Team", required: true},
    dueDate: {type: Date, required: true},
    points: {type: Number, required: true},
    priority: {type: String, enum: ["low", "medium", "high"], default: "medium"},
    recurrence: {type: RecurrenceSchema}
  },
  {timestamps: true}
);

export default mongoose.model<ITask>("Task", TaskSchema);
