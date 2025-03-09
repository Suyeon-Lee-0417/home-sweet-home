import {IUser, userSchema, userSchemaName} from "../model/User";
import AbstractRepository from "./AbstractRepository";

export default class UserRepository extends AbstractRepository<IUser> {
  constructor() {
    super(userSchema, userSchemaName);
  }

  public create = async (item: IUser): Promise<IUser> => {
    return await super.create(item);
  };

  public findByFirebaseUid = async (uid: string): Promise<IUser | null> => {
    return this.model.findOne({firebaseUid: uid});
  };
}
