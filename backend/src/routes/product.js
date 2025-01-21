import express from "express";
import {
	selectAllProduct,
	deleteProduct,
	insertProduct,
	selectProductByID,
	updateProduct,
} from "../controllers/product.controller";


const router = express.Router()

router.get("/", selectAllProduct)
router.get("/:pID", selectProductByID)
router.post("/", insertProduct)
router.put("/", updateProduct)
router.delete("/", deleteProduct)

export default router