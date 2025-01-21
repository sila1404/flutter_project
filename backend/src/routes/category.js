import express from "express";
import {
	selectAllCategory,
	selectCategoryByID,
	insertCategory,
} from "../controllers/category.controller.js";

const router = express.Router();

router.get("/", selectAllCategory);
router.get("/:cID", selectCategoryByID);
router.post("/", insertCategory);

export default router;
