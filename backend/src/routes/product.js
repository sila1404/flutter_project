import express from "express";
import {
  selectAllProduct,
  deleteProduct,
  insertProduct,
  selectProductByID,
  updateProduct,
  searchProduct,
} from "../controllers/product.controller";

const router = express.Router();

router.get("/", selectAllProduct);
router.get("/search", searchProduct);
router.get("/:pID", selectProductByID);
router.post("/", insertProduct);
router.put("/:pID", updateProduct);
router.delete("/:pID", deleteProduct);

export default router;
