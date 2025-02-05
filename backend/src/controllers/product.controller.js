import conn from "../configs/database.js";

function selectAllProduct(req, res) {
  conn.query(
    `SELECT 
		product.product_id, 
		product.product_name, 
		product.quantity, 
		product.price, 
		product.sale_price, 
    unit.unit_id,
		unit.unit_name,
    product.category_id
	FROM product
	INNER JOIN unit
	ON product.unit_id = unit.unit_id`,
    (err, result) => {
      if (err) {
        res.status(500).json({
          success: false,
          message: err.message,
        });
      }

      res.json({
        success: true,
        message: "ສຳເລັດການດຶງຂໍ້ມູນສິນຄ້າ",
        data: result,
      });
    }
  );
}

function selectProductByID(req, res) {
  const { pID } = req.params;
  conn.query(
    `SELECT 
      product.product_id, 
      product.product_name, 
      product.quantity, 
      product.price, 
      product.sale_price, 
      unit.unit_name
    FROM product
    INNER JOIN unit
    ON product.unit_id = unit.unit_id
    WHERE product.product_id = ?
	`,
    pID,
    (err, result) => {
      if (err) {
        res.status(500).json({
          success: false,
          message: err.message,
        });
      }

      if (!result[0]) {
        res.status(404).json({
          success: false,
          message: "ບໍ່ພົບຂໍ້ມູນສິນຄ້າດັ່ງກ່າວ",
        });
      }

      res.json({
        success: true,
        message: "ສຳເລັດການດຶງຂໍ້ມູນສິນຄ້າ",
        data: result,
      });
    }
  );
}

function insertProduct(req, res) {
  const { product_name, quantity, price, sale_price, category_id, unit_id } =
    req.body;

  // Check for required fields
  if (
    !product_name ||
    !sale_price ||
    !quantity ||
    !price ||
    !category_id ||
    !unit_id
  ) {
    return res.status(400).json({
      success: false,
      message: "ກະລຸນາໃສ່ຊື່ສິນຄ້າ ແລະ ລາຄາ",
    });
  }

  // Check if sale price is valid
  if (sale_price < price) {
    return res.status(400).json({
      success: false,
      message: "ລາຄາຂາຍຕ້ອງສູງກວ່າລາຄາຊື້",
    });
  }

  // Check for duplicate product with the same name and unit
  conn.query(
    "SELECT * FROM product WHERE product_name = ? AND unit_id = ?",
    [product_name, unit_id],
    (err, result) => {
      if (err) {
        return res.status(500).json({
          success: false,
          message: err.message,
        });
      }

      if (result.length > 0) {
        return res.status(400).json({
          success: false,
          message: "ສິນຄ້ານີ້ມີໃນລະບົບແລ້ວ, ກະລຸນາປ່ຽນຊື່ສິນຄ້າ ຫຼື ຫົວໜ່ວຍ",
        });
      }

      // Proceed with insertion since no duplicates found
      conn.query(
        "INSERT INTO product (product_name, quantity, price, sale_price, category_id, unit_id) VALUES (?, ?, ?, ?, ?, ?)",
        [product_name, quantity, price, sale_price, category_id, unit_id],
        (err, result) => {
          if (err) {
            return res.status(500).json({
              success: false,
              message: err.message,
            });
          }

          res.status(201).json({
            success: true,
            message: "ສຳເລັດການເພີ່ມຂໍ້ມູນສິນຄ້າ",
          });
        }
      );
    }
  );
}

function updateProduct(req, res) {
  const { pID } = req.params;
  const { product_name, quantity, price, sale_price, category_id, unit_id } =
    req.body;

  // Validate required fields
  if (
    !product_name ||
    !sale_price ||
    !quantity ||
    !price ||
    !category_id ||
    !unit_id
  ) {
    return res.status(400).json({
      success: false,
      message: "ກະລຸນາໃສ່ຊື່ສິນຄ້າ ແລະ ລາຄາ",
    });
  }

  // Validate sale price is greater than purchase price
  if (sale_price < price) {
    return res.status(400).json({
      success: false,
      message: "ກະລຸນາກຳນົດລາຄາຂາຍໃຫ້ຫຼາຍກວ່າລາຄາຊື້",
    });
  }

  // Check for duplicate product with the same name and unit
  conn.query(
    "SELECT * FROM product WHERE product_name = ? AND unit_id = ?",
    [product_name, unit_id],
    (err, result) => {
      if (err) {
        return res.status(500).json({
          success: false,
          message: err.message,
        });
      }

      if (result.length > 0) {
        return res.status(400).json({
          success: false,
          message: "ສິນຄ້ານີ້ມີໃນລະບົບແລ້ວ, ກະລຸນາປ່ຽນຊື່ສິນຄ້າ ຫຼື ຫົວໜ່ວຍ",
        });
      }

      // Update product in database
      conn.query(
        "UPDATE product SET product_name = ?, quantity = ?, price = ?, sale_price = ?, category_id = ?, unit_id = ? WHERE product_id = ?",
        [product_name, quantity, price, sale_price, category_id, unit_id, pID],
        (err, result) => {
          if (err) {
            return res.status(500).json({
              success: false,
              message: err.message,
            });
          }

          if (result.affectedRows === 0) {
            return res.status(404).json({
              success: false,
              message: "ບໍ່ພົບຂໍ້ມູນສິນຄ້າທີ່ຕ້ອງການແກ້ໄຂ",
            });
          }

          res.status(200).json({
            success: true,
            message: "ສຳເລັດການແກ້ໄຂຂໍ້ມູນສິນຄ້າ",
          });
        }
      );
    }
  );
}

function deleteProduct(req, res) {
  const { pID } = req.params;
  conn.query(
    "SELECT * FROM product WHERE product_id = ?",
    pID,
    (err, result) => {
      if (err) {
        return res.status(500).json({
          success: false,
          message: err.message,
        });
      }

      if (!result[0]) {
        return res.status(404).json({
          success: false,
          message: "ບໍ່ພົບສິນຄ້າ",
        });
      }

      conn.query(
        "DELETE FROM product WHERE product_id = ?",
        pID,
        (err, result) => {
          if (err) {
            return res.status(500).json({
              success: false,
              message: err.message,
            });
          }

          return res.status(200).json({
            success: true,
            message: "ສຳເລັດການລົບສິນຄ້າ",
          });
        }
      );
    }
  );
}

function searchProduct(req, res) {
  const { q } = req.query;

  if (!q) {
    return res.status(400).json({
      success: false,
      message: "ກະລຸນາໃສ່ຄຳຄົ້ນຫາ",
    });
  }

  conn.query(
    "SELECT * FROM product WHERE product_name LIKE ?",
    [`%${q}%`],
    (err, result) => {
      if (err) {
        return res.status(500).json({
          success: false,
          message: err.message,
        });
      }

      if (result.length === 0) {
        return res.status(404).json({
          success: false,
          message: "ບໍ່ພົບຂໍ້ມູນສິນຄ້າທີ່ກ່ຽວຂ້ອງ",
        });
      }

      return res.status(200).json({
        success: true,
        message: "ສຳເລັດການຄົ້ນຫາຂໍ້ມູນສິນຄ້າ",
        data: result,
      });
    }
  );
}

export {
  selectAllProduct,
  selectProductByID,
  insertProduct,
  updateProduct,
  deleteProduct,
  searchProduct
};
