import {IUser} from "../model/User";
import UserRepository from "../repository/UserRepository";

import AbstractService from "./AbstractService";
import {NotFoundError, UnauthorizedError, BadRequestError} from "../utils/exception/PineappleError";
import admin from "../config/firebase";
import jwt from "jsonwebtoken";

export default class UserService extends AbstractService<IUser> {
  public create(dto: IUser): Promise<IUser> {
    throw new Error("Method not implemented.");
  }
  private userRepo: UserRepository;

  constructor(userRepo: UserRepository) {
    super();
    this.userRepo = userRepo;
  }
  public getAll(): Promise<IUser[]> {
    throw new Error("Method not implemented.");
  }
  public getById(id: string): Promise<IUser> {
    throw new Error("Method not implemented.");
  }
  public update(id: string, dto: IUser): Promise<IUser> {
    throw new Error("Method not implemented.");
  }
  public delete(id: string): Promise<void> {
    throw new Error("Method not implemented.");
  }
  public async login(idToken: string): Promise<string> {
    const decodedToken = await admin.auth().verifyIdToken(idToken);
    const {uid, email, name} = decodedToken;

    let user = await this.userRepo.findByFirebaseUid(uid);
    if (!user) {
      const newUser = {
        firebaseUid: uid,
        email: email || "",
        displayName: name || ""
      };

      user = await this.userRepo.create(newUser as IUser);
    }

    const jwtToken = jwt.sign({uid: user.firebaseUid, email: user.email}, process.env.JWT_SECRET as string, {
      expiresIn: "24h"
    });

    return jwtToken;
  }
}
