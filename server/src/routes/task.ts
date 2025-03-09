import {Router, Request, Response} from "express";
import admin from "../config/firebase";
import Task from "../model/Task";
import Team from "../model/Team";
import User from "../model/User";
import {Schema} from "mongoose";
import moment from "moment-timezone";

const router = Router();

/**
 * Create a new task.
 * Only the team admin can create a task.
 * POST /api/tasks
 */
router.post("/", async (req: Request, res: Response) => {
  try {
    const {title, description, assignedTo, createdByUid, teamId, category, dueDate, points, priority, recurrence} =
      req.body;

    if (!title || !createdByUid || !teamId || !category || !dueDate || !points || !priority) {
      return res.status(400).json({message: "Missing required fields"});
    }

    // Verify that the team exists and the current user is its admin.
    const team = await Team.findById(teamId);
    if (!team) {
      return res.status(404).json({message: "Team not found"});
    }

    const firebaseUser = await admin.auth().getUser(createdByUid);
    const {uid: firebaseUid} = firebaseUser;

    const adminUser = await User.findOne({firebaseUid: firebaseUid}).select("_id");
    const adminUserId = adminUser?._id as Schema.Types.ObjectId;

    // Check if the user is the admin of the team
    if (team.adminId.toString() !== adminUserId.toString()) {
      return res.status(403).json({message: "Only team admin can create tasks"});
    }

    // TODO - Check if the assigned user is a member of the team

    // Create the task (admin can assign tasks to any member)
    const newTask = new Task({
      title,
      description,
      isCompleted: false,
      assignedTo,
      createdByUid,
      teamId,
      category,
      dueDate,
      points,
      priority,
      recurrence
    });

    // add the new task to the team's task list
    await Team.findByIdAndUpdate(teamId, {$push: {tasksIds: newTask._id}});

    const savedTask = await newTask.save();
    res.status(201).json({task: savedTask});
  } catch (error) {
    console.error("Error creating task:", error);
    res.status(500).json({message: "Error creating task", error});
  }
});

/**
 * Get all tasks for current user due today.
 * GET /api/tasks/:uid
 */

router.get("/:uid", async (req: Request, res: Response) => {
  try {
    const {uid} = req.params;
    if (!uid) return res.status(400).json({message: "User ID is required"});

    const user = await User.findOne({firebaseUid: uid});
    if (!user) return res.status(404).json({message: "User not found"});

    // Calculate the current time and 24 hours from now
    const now = new Date();
    const twentyFourHoursFromNow = new Date(now.getTime() + 24 * 60 * 60 * 1000);

    console.log("Current time:", now);
    console.log("24 hours from now:", twentyFourHoursFromNow);

    // Query tasks due within the next 24 hours
    const tasks = await Task.find({
      assignedTo: user._id,
      dueDate: {
        $gte: now,
        $lte: twentyFourHoursFromNow
      }
    });

    res.json({tasks});
  } catch (error) {
    console.error("Error fetching tasks:", error);
    res.status(500).json({message: "Error fetching tasks", error});
  }
});
/**
 * Get a single task by ID.
 * GET /api/tasks/:id
 */
router.get("/:id", async (req: Request, res: Response) => {
  try {
    const task = await Task.findById(req.params.id);
    if (!task) return res.status(404).json({message: "Task not found"});
    res.json({task});
  } catch (error) {
    console.error("Error fetching task:", error);
    res.status(500).json({message: "Error fetching task", error});
  }
});

/**
 * Update a task.
 * - Team admin can update any field.
 * - A non-admin team member can only update the "assignedTo" field (and only to assign the task to themselves).
 * PUT /api/tasks/:id
 */
router.put("/:id", async (req: Request, res: Response) => {
  try {
    const {createdByUid} = req.body;
    const task = await Task.findById(req.params.id);
    if (!task) return res.status(404).json({message: "Task not found"});

    // Get team details to check admin permissions.
    const team = await Team.findById(task.teamId);
    if (!team) {
      return res.status(404).json({message: "Team not found for task"});
    }
    // check if the user is the admin of the team

    const firebaseUser = await admin.auth().getUser(createdByUid);
    const {uid: firebaseUid} = firebaseUser;

    const adminUser = await User.findOne({firebaseUid: firebaseUid}).select("_id");
    const adminUserId = adminUser?._id as Schema.Types.ObjectId;

    // If the current user is the team admin, allow updating all provided fields.
    if (team.adminId.toString() === adminUserId.toString()) {
      Object.assign(task, req.body);
      const updatedTask = await task.save();
      return res.json({task: updatedTask});
    } else {
      // Non-admins can only update the "assignedTo" field to themselves.
      if (req.body.assignedTo && req.body.assignedTo.toString() !== adminUserId.toString()) {
        task.assignedTo = req.body.assignedTo;
        const updatedTask = await task.save();
        return res.json({task: updatedTask});
      } else {
        return res.status(403).json({message: "You are not allowed to update this task."});
      }
    }
  } catch (error) {
    console.error("Error updating task:", error);
    res.status(500).json({message: "Error updating task", error});
  }
});

// mark task as completed and award points
// PUT /api/tasks/complete/:taskId
router.put("/complete/:taskId", async (req: Request, res: Response) => {
  try {
    const task = await Task.findById(req.params.taskId);
    if (!task) return res.status(404).json({message: "Task not found"});
    // Get user that being assigned the task
    const user = await User.findById(task.assignedTo);
    if (!user) return res.status(404).json({message: "User not found"});

    // update task as completed
    task.isCompleted = true;

    // award points to user
    user.points += task.points;
    await user.save();
    await task.save();
  } catch (error) {
    console.error("Error updating task:", error);
    res.status(500).json({message: "Error updating task", error});
  }
});

export default router;
