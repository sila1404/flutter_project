import express from "express";
import {
  selectUnitByID,
  insertUnit,
  selectAllUnit,
  updateUnit,
  deleteUnit,
} from "../controllers/unit.controller";

const router = express.Router();

router.get("/", selectAllUnit);
router.get("/:uID", selectUnitByID);
router.get("/", insertUnit);
router.put("/:uID", updateUnit);
router.delete("/:uID", deleteUnit);

export default router;
