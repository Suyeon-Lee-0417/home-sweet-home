import {Router, Request, Response} from "express";
import User, {IUser} from "../model/User";
import dotenv from "dotenv";
dotenv.config();

const router = Router();

// GET /api/users/:uid
router.get("/:uid", async (req: Request, res: Response) => {
  try {
    const user = await User.findOne({firebaseUid: req.params.uid});
    if (!user) return res.status(404).json({message: "User not found"});
    res.json({user});
  } catch (error) {
    console.error("Error fetching user:", error);
    res.status(500).json({message: "Error fetching user"});
  }
});
export default router;
