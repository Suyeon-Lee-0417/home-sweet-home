import cors from "cors";
import express from "express";
import dotenv from "dotenv";
import {connectDB} from "./utils/DBconnection";
import authRouter from "./routes/auth";

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

export default app;
