import {Router, Request, Response} from "express";
import User, {IUser} from "../model/User";
import Team from "../model/Team";
import dotenv from "dotenv";
dotenv.config();

const router = Router();

// GET /api/users/:uid
router.get("/:uid", async (req: Request, res: Response) => {
  try {
    let user = await User.findOne({firebaseUid: req.params.uid});
    if (!user) return res.status(404).json({message: "User not found"});
    // findout in which team the user belongs
    // get the team details

    const team = await Team.findOne({memberIds: user._id});
    if (!team) return res.json({user});

    res.json({user, team});
  } catch (error) {
    console.error("Error fetching user:", error);
    res.status(500).json({message: "Error fetching user"});
  }
});
export default router;
