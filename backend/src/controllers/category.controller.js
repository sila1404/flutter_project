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
    "SELECT * FROM category WHERE category_name = ?",
    category_name,
    (err, result) => {
      if (err) {
        return res.status(500).json({
          success: false,
          message: err.message,
        });
      }

      if (result[0]) {
        return res.status(400).json({
          success: false,
          message: "ໝວດໝູ່ນີ້ມີໃນລະບົບແລ້ວ, ກະລຸນາສ້າງໝວດໝູ່ໃໝ່",
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
        "SELECT * FROM category WHERE category_name = ?",
        category_name,
        (err, result) => {
          if (err) {
            return res.status(500).json({
              success: false,
              message: err.message,
            });
          }

          if (result[0]) {
            return res.status(400).json({
              success: false,
              message: "ໝວດໝູ່ນີ້ມີໃນລະບົບແລ້ວ, ກະລຸນາສ້າງໝວດໝູ່ໃໝ່",
            });
          }

          conn.query(
            "UPDATE category SET category_name = ? WHERE category_id = ?",
            [category_name, cID],
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
  );
}

function deleteCategory(req, res) {
  const { cID } = req.params;

  // First check if category exists
  conn.query(
    "SELECT * FROM category WHERE category_id = ?",
    cID,
    (err, categoryResult) => {
      if (err) {
        return res.status(500).json({
          success: false,
          message: err.message,
        });
      }

      if (!categoryResult[0]) {
        return res.status(404).json({
          success: false,
          message: "ບໍ່ພົບຂໍ້ມູນໝວດໝູ່ດັ່ງກ່າວ",
        });
      }

      // Check if category has associated products
      conn.query(
        "SELECT COUNT(*) as productCount FROM product WHERE category_id = ?",
        cID,
        (err, productResult) => {
          if (err) {
            return res.status(500).json({
              success: false,
              message: err.message,
            });
          }

          if (productResult[0].productCount > 0) {
            return res.status(400).json({
              success: false,
              message:
                "ບໍ່ສາມາດລົບໝວດໝູ່ນີ້ໄດ້ ເນື່ອງຈາກມີສິນຄ້າທີ່ກ່ຽວຂ້ອງຢູ່",
            });
          }

          // If no associated products, proceed with deletion
          conn.query(
            "DELETE FROM category WHERE category_id = ?",
            cID,
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

function countProductOnCategory(req, res) {
  const { cID } = req.params;
  conn.query(
    `SELECT 
      category.category_name,
      COUNT(product.product_id) as count
    FROM category
    LEFT JOIN product ON category.category_id = product.category_id
    WHERE category.category_id = ?
    GROUP BY category.category_id, category.category_name`,
    cID,
    (err, result) => {
      if (err) {
        res.status(500).json({
          success: false,
          message: err.message,
        });
        return;
      }

      if (!result[0]) {
        res.json({
          success: true,
          message: "ບໍ່ພົບຂໍ້ມູນຈຳນວນສິນຄ້າ",
          data: {
            category_name: "",
            count: 0,
          },
        });
        return;
      }

      res.json({
        success: true,
        message: "ສຳເລັດການດຶງຂໍ້ມູນຈຳນວນສິນຄ້າ",
        data: {
          category_name: result[0].category_name,
          count: result[0].count,
        },
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
  selectProductOnCategory,
  countProductOnCategory,
};
