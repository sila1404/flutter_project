import express from "express";
import {
	selectAllCategory,
	selectCategoryByID,
	insertCategory,
	updateCategory,
	deleteCategory,
	searchCategory
} from "../controllers/category.controller.js";

const router = express.Router();

router.get("/", selectAllCategory);
router.get("/search", searchCategory);
router.get("/:cID", selectCategoryByID);
router.post("/", insertCategory);
router.put("/:cID", updateCategory);
router.delete("/:cID", deleteCategory);

export default router;
