// src/routes/team.ts
import {Router, Request, Response} from "express";
import Team from "../model/Team";
import admin from "../config/firebase";
import User, {IUser} from "../model/User";

const router = Router();

// Create a new team
// POST /api/teams
router.post("/", async (req: Request, res: Response) => {
  try {
    const {name, adminUid} = req.body;
    if (!name || !adminUid) {
      return res.status(400).json({message: "Name and admin are required."});
    }

    // find admin._id based on adminUid
    const adminUser = await User.findOne({firebaseUid: adminUid});
    if (!adminUser) return res.status(404).json({message: "Admin not found"});

    // Create the team and add the admin as the first member
    const team = new Team({
      name,
      adminId: adminUser._id,
      memberIds: [adminUser._id]
    });
    await team.save();

    // The join token is the team's _id (auto-generated)
    res.status(201).json({team, joinToken: team._id});
  } catch (error) {
    console.error("Error creating team:", error);
    res.status(500).json({message: "Error creating team"});
  }
});

// Update a team name (only allowed for authorized users, e.g. admin)
// PUT /api/teams/:id
router.put("/:id", async (req: Request, res: Response) => {
  try {
    const {uid} = req.body;
    if (!uid) return res.status(400).json({message: "User ID is required"});
    const firebaseUser = await admin.auth().getUser(uid);
    const {uid: firebaseUid} = firebaseUser;

    // Get user from MongoDB to check if they are the admin
    let user: IUser | null = await User.findOne({firebaseUid: firebaseUid});
    if (!user) return res.status(404).json({message: "User not found"});

    // Check if user is the admin of the team
    const team = await Team.findById(req.params.id);
    if (!team) return res.status(404).json({message: "Team not found"});
    if (team.adminId.toString() !== uid.toString()) {
      return res.status(403).json({message: "Unauthorized"});
    }

    await team.save();
    res.json({team});
  } catch (error) {
    console.error("Error updating team:", error);
    res.status(500).json({message: "Error updating team"});
  }
});

// Delete a team (only allowed for authorized users, e.g. admin)
// DELETE /api/teams/:id
router.delete("/:id", async (req: Request, res: Response) => {
  try {
    const team = await Team.findByIdAndDelete(req.params.id);
    if (!team) return res.status(404).json({message: "Team not found"});
    res.json({message: "Team deleted successfully"});
  } catch (error) {
    console.error("Error deleting team:", error);
    res.status(500).json({message: "Error deleting team"});
  }
});

export default router;
