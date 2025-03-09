import AbstractController from "./AbstractController";
import {Request, Response} from "express";
import {IUser} from "../model/User";
import UserService from "../service/UserService";

export default class UserController extends AbstractController<IUser> {
  private userService: UserService;

  constructor(userService: UserService) {
    super();
    this.userService = userService;
  }

  public login = async (req: Request, res: Response): Promise<Response> => {
    try {
      const {idToken} = req.body;
      if (!idToken) {
        throw new Error("idToken is required.");
      }
      const user = await this.userService.login(req.body);
      return this.onResolve(res, user);
    } catch (error) {
      return this.handleError(res, error);
    }
  };

  public create(req: Request, res: Response): Promise<Response> {
    throw new Error("Method not implemented.");
  }

  public getAll(req: Request, res: Response): Promise<Response> {
    throw new Error("Method not implemented.");
  }
  public getById(req: Request, res: Response): Promise<Response> {
    throw new Error("Method not implemented.");
  }
  public update(req: Request, res: Response): Promise<Response> {
    throw new Error("Method not implemented.");
  }
  public delete(req: Request, res: Response): Promise<Response> {
    throw new Error("Method not implemented.");
  }
}
