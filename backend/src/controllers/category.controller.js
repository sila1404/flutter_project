import conn from "../configs/database.js";

function selectAllCategory(req, res, next) {
  conn.query("SELECT * FROM category", (err, result) => {
    if (err) {
      return res.status(500).json({
        success: false,
        message: err.message,
      });
    }

    return res.status(200).json({
      success: true,
      message: "ສຳເລັດການດຶງຂໍ້ມູນໝວດໝູ່",
      data: result,
    });
  });
}

function selectCategoryByID(req, res) {
  const { cID } = req.params;

  conn.query(
    "SELECT * FROM category WHERE category_id = ?",
    cID,
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
          message: "ບໍ່ພົບຂໍ້ມູນໝວດໝູ່ດັ່ງກ່າວ",
        });
      }

      return res.status(200).json({
        success: true,
        message: "ສຳເລັດການດຶງຂໍ້ມູນໝວດໝູ່",
        data: result,
      });
    }
  );
}

function insertCategory(req, res) {
  const { category_name } = req.body;
  if (!category_name) {
    return res.status(400).json({
      success: false,
      message: "ກະລຸນາໃສ່ຊື່ໝວດໝູ່",
    });
  }
  conn.query(
    "INSERT INTO category (category_name) VALUES (?)",
    [category_name],
    (err, result) => {
      if (err) {
        return res.status(500).json({
          success: false,
          message: err.message,
        });
      }

      return res.status(201).json({
        success: true,
        message: "ສຳເລັດການເພີ່ມຂໍ້ມູນໝວດໝູ່",
      });
    }
  );
}

function updateCategory(req, res) {
  const { cID } = req.params;
  const { category_name } = req.body;
  if (!category_name) {
    return res.status(400).json({
      success: false,
      message: "ກະລຸນາໃສ່ຊື່ໝວດໝູ່",
    });
  }

  conn.query(
    "SELECT * FROM category WHERE category_id = ?",
    cID,
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
          message: "ບໍ່ພົບຂໍ້ມູນໝວດໝູ່ດັ່ງກ່າວ",
        });
      }

      conn.query(
        "UPDATE category SET category_name = ? WHERE category_id = ?",
        [category_name, result[0].category_id],
        (err, result) => {
          if (err) {
            return res.status(500).json({
              success: false,
              message: err.message,
            });
          }

          return res.status(200).json({
            success: true,
            message: "ສຳເລັດການແກ້ໄຂຂໍ້ມູນໝວດໝູ່",
          });
        }
      );
    }
  );
}

function deleteCategory(req, res) {
  const { cID } = req.params;
  conn.query(
    "SELECT * FROM category WHERE category_id = ?",
    cID,
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
          message: "ບໍ່ພົບຂໍ້ມູນໝວດໝູ່ດັ່ງກ່າວ",
        });
      }

      conn.query(
        "DELETE FROM category WHERE category_id = ?",
        result[0].category_id,
        (err, result) => {
          if (err) {
            return res.status(500).json({
              success: false,
              message: err.message,
            });
          }

          return res.status(200).json({
            success: true,
            message: "ສຳເລັດການລົບໝວດໝູ່",
          });
        }
      );
    }
  );
}

function searchCategory(req, res) {
  const { q } = req.query;

  if (!q) {
    return res.status(400).json({
      success: false,
      message: "ກະລຸນາໃສ່ຄຳຄົ້ນຫາ",
    });
  }

  conn.query(
    "SELECT * FROM category WHERE category_name LIKE ?",
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
          message: "ບໍ່ພົບຂໍ້ມູນໝວດໝູ່ທີ່ກ່ຽວຂ້ອງ",
        });
      }

      return res.status(200).json({
        success: true,
        message: "ສຳເລັດການຄົ້ນຫາຂໍ້ມູນໝວດໝູ່",
        data: result,
      });
    }
  );
}

function selectProductOnCategory(req, res) {
  const { cID } = req.params;
  conn.query(
    `SELECT 
		  product.product_id, 
		  product.product_name, 
		  product.quantity, 
		  product.price, 
		  product.sale_price, 
      unit.unit_id,
		  unit.unit_name,
      category.category_id
		FROM product
		INNER JOIN unit
		ON product.unit_id = unit.unit_id
		INNER JOIN category
		ON product.category_id = category.category_id
		WHERE category.category_id = ?
		`,
    cID,
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
          message: "ບໍ່ພົບຂໍ້ມູນສິນຄ້າ",
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

export {
  selectAllCategory,
  selectCategoryByID,
  insertCategory,
  updateCategory,
  deleteCategory,
  searchCategory,
  selectProductOnCategory
};
