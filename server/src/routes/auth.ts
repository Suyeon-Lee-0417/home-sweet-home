// src/routes/auth.ts
import {Router, Request, Response} from "express";
import admin from "../config/firebase";
import jwt from "jsonwebtoken";
import User, {IUser} from "../model/User";
import dotenv from "dotenv";
dotenv.config();

const router = Router();

// POST /api/auth
router.post("/", async (req: Request, res: Response) => {
  const {idToken} = req.body;

  if (!idToken) {
    return res.status(400).json({message: "ID token is required."});
  }

  try {
    // Verify Firebase ID token
    const decodedToken = await admin.auth().verifyIdToken(idToken);
    const {uid, email, name} = decodedToken;

    // Check if user exists in MongoDB, else create one
    let user: IUser | null = await User.findOne({firebaseUid: uid});
    if (!user) {
      user = new User({
        firebaseUid: uid,
        email: email,
        displayName: name || ""
      });
      await user.save();
    }

    // Create a custom JWT for your API
    const jwtToken = jwt.sign({uid: user.firebaseUid, email: user.email}, process.env.JWT_SECRET as string, {
      expiresIn: "24h"
    });

    res.json({token: jwtToken});
  } catch (error) {
    console.error("Authentication error:", error);
    res.status(401).json({message: "Invalid token", error});
  }
});

export default router;
