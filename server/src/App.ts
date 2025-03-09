import cors from "cors";
import express from "express";
import dotenv from "dotenv";
import {connectDB} from "./utils/DBconnection";
import UserRepository from "./repository/UserRepository";
import UserService from "./service/UserService";
import UserController from "./controller/UserController";

dotenv.config();

const app = express();

app.use(express.json());
app.use(cors());

const userRepository = new UserRepository();
const userController = new UserController(new UserService(userRepository));

connectDB();

export const endpoint: string = "/pineapple/api";
app.get(`${endpoint}/`, (req, res) => {
  res.status(200).json({result: "Welcome to pineapple!"});
});

app.post(`${endpoint}/users/`, userController.create);

export default app;
