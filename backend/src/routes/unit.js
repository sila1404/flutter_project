import express from "express";
import {
  selectUnitByID,
  insertUnit,
  selectAllUnit,
  updateUnit,
  deleteUnit,
  searchUnit,
} from "../controllers/unit.controller";

const router = express.Router();

router.get("/", selectAllUnit);
router.get("/search", searchUnit);
router.get("/:uID", selectUnitByID);
router.post("/", insertUnit);
router.put("/:uID", updateUnit);
router.delete("/:uID", deleteUnit);

export default router;
