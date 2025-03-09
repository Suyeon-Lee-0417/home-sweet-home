import {Schema, Document} from "mongoose";

export interface IUser extends Document {
  firebaseUid: string;
  email: string;
  displayName?: string;
}

export const userSchema = new Schema<IUser>(
  {
    firebaseUid: {type: String, required: true, unique: true},
    email: {type: String, required: true, unique: true},
    displayName: {type: String}
  },
  {timestamps: true}
);

export const userSchemaName: string = "User";
