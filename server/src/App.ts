import cors from "cors";
import express from "express";
import dotenv from "dotenv";
import {connectDB} from "./utils/DBconnection";
import authRouter from "./routes/auth";
import teamRouter from "./routes/team";
import taskRouter from "./routes/task";
import userRouter from "./routes/user";
import notificationRouter from "./routes/notification";

dotenv.config();

const app = express();

app.use(express.json());
app.use(cors());

connectDB();

export const endpoint: string = "/pineapple/api";
app.get(`${endpoint}/`, (req, res) => {
  res.status(200).json({result: "Welcome to pineapple!"});
});

app.use(`${endpoint}/auth`, authRouter);
app.use(`${endpoint}/teams`, teamRouter);
app.use(`${endpoint}/tasks`, taskRouter);
app.use(`${endpoint}/users`, userRouter);
app.use(`${endpoint}/notifications`, notificationRouter);
export default app;
