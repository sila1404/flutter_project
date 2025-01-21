import express from "express";
import {
	selectUnitByID,
	insertUnit,
	selectAllUnit,
} from "../controllers/unit.controller";

const router = express.Router();

router.get("/", selectAllUnit);
router.get("/:uID", selectUnitByID);
router.get("/", insertUnit);

export default router;
