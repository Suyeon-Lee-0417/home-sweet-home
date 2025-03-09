import mongoose, {Document, Schema, Types} from "mongoose";

export interface IReward extends Document {
  teamId: Schema.Types.ObjectId; // references Team
  name: string;
  cost: number;
  description: string;
}

const RewardSchema: Schema = new Schema(
  {
    teamId: {type: Schema.Types.ObjectId, ref: "Team", required: true},
    name: {type: String, required: true},
    cost: {type: Number, required: true},
    description: {type: String}
  },
  {timestamps: true}
);

export default mongoose.model<IReward>("Reward", RewardSchema);
