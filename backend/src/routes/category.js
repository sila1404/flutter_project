import express from "express";
import {
	selectAllCategory,
	selectCategoryByID,
	insertCategory,
	updateCategory,
	deleteCategory,
	searchCategory,
	selectProductOnCategory,
	countProductOnCategory
} from "../controllers/category.controller.js";

const router = express.Router();

router.get("/", selectAllCategory);
router.get("/search", searchCategory);
router.get("/product/:cID", selectProductOnCategory);
router.get("/product/:cID/count", countProductOnCategory);
router.get("/:cID", selectCategoryByID);
router.post("/", insertCategory);
router.put("/:cID", updateCategory);
router.delete("/:cID", deleteCategory);

export default router;
