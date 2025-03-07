import conn from "../configs/database.js";

function selectAllUnit(req, res) {
  conn.query("SELECT * FROM unit", (err, result) => {
    if (err) {
      res.status(500).json({
        success: false,
        message: err.message,
      });
    }

    res.json({
      success: true,
      message: "ສຳເລັດການດຶງຂໍ້ມູນຫົວໜ່ວຍ",
      data: result,
    });
  });
}

function selectUnitByID(req, res) {
  const { uID } = req.params;
  conn.query("SELECT * FROM unit WHERE unit_id = ?", uID, (err, result) => {
    if (err) {
      res.status(500).json({
        success: false,
        message: err.message,
      });
    }

    if (!result[0]) {
      res.status(404).json({
        success: false,
        message: "ບໍ່ພົບຂໍ້ມູນຫົວໜ່ວຍດັ່ງກ່າວ",
      });
    }

    res.json({
      success: true,
      message: "ສຳເລັດການດຶງຂໍ້ມູນຫົວໜ່ວຍ",
      data: result,
    });
  });
}

function insertUnit(req, res) {
  const { unit_name } = req.body;
  if (!unit_name) {
    res.status(400).json({
      success: false,
      message: "ກະລຸນາໃສ່ຊື່ຫົວໜ່ວຍ",
    });
  }

  conn.query(
    "SELECT * FROM unit WHERE unit_name = ?",
    unit_name,
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
          message: "ຫົວໜ່ວຍນີ້ມີໃນລະບົບແລ້ວ, ກະລຸນາສ້າງຫົວໜ່ວຍໃໝ່",
        });
      }

      conn.query(
        "INSERT INTO unit (unit_name) VALUES (?)",
        [unit_name],
        (err, result) => {
          if (err) {
            res.status(500).json({
              success: false,
              message: err.message,
            });
          }

          res.status(201).json({
            success: true,
            message: "ສຳເລັດການເພີ່ມຂໍ້ມູນຫົວໜ່ວຍ",
          });
        }
      );
    }
  );
}

function updateUnit(req, res) {
  const { uID } = req.params;
  const { unit_name } = req.body;
  if (!unit_name) {
    return res.status(400).json({
      success: false,
      message: "ກະລຸນາໃສ່ຊື່ຫົວໜ່ວຍ",
    });
  }

  conn.query("SELECT * FROM unit WHERE unit_id = ?", uID, (err, result) => {
    if (err) {
      return res.status(500).json({
        success: false,
        message: err.message,
      });
    }

    if (!result[0]) {
      return res.status(404).json({
        success: false,
        message: "ບໍ່ພົບຂໍ້ມູນຫົວໜ່ວຍດັ່ງກ່າວ",
      });
    }

    conn.query(
      "SELECT * FROM unit WHERE unit_name = ?",
      unit_name,
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
            message: "ຫົວໜ່ວຍນີ້ມີໃນລະບົບແລ້ວ, ກະລຸນາສ້າງຫົວໜ່ວຍໃໝ່",
          });
        }

        conn.query(
          "UPDATE unit SET unit_name = ? WHERE unit_id = ?",
          [unit_name, uID],
          (err, result) => {
            if (err) {
              return res.status(500).json({
                success: false,
                message: err.message,
              });
            }

            return res.status(200).json({
              success: true,
              message: "ສຳເລັດການແກ້ໄຂຂໍ້ມູນຫົວໜ່ວຍ",
            });
          }
        );
      }
    );
  });
}

function deleteUnit(req, res) {
  const { uID } = req.params;

  // First check if unit exists
  conn.query("SELECT * FROM unit WHERE unit_id = ?", uID, (err, unitResult) => {
    if (err) {
      return res.status(500).json({
        success: false,
        message: err.message,
      });
    }

    if (!unitResult[0]) {
      return res.status(404).json({
        success: false,
        message: "ບໍ່ພົບຂໍ້ມູນຫົວໜ່ວຍດັ່ງກ່າວ",
      });
    }

    // Check if unit has associated products
    conn.query(
      "SELECT COUNT(*) as productCount FROM product WHERE unit_id = ?",
      uID,
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
            message: "ບໍ່ສາມາດລົບຫົວໜ່ວຍນີ້ໄດ້ ເນື່ອງຈາກມີສິນຄ້າທີ່ກ່ຽວຂ້ອງຢູ່",
            hasProducts: true,
            productCount: productResult[0].productCount,
          });
        }

        // If no associated products, proceed with deletion
        conn.query("DELETE FROM unit WHERE unit_id = ?", uID, (err, result) => {
          if (err) {
            return res.status(500).json({
              success: false,
              message: err.message,
            });
          }

          return res.status(200).json({
            success: true,
            message: "ສຳເລັດການລົບຫົວໜ່ວຍ",
          });
        });
      }
    );
  });
}

function searchUnit(req, res) {
  const { q } = req.query;

  if (!q) {
    return res.status(400).json({
      success: false,
      message: "ກະລຸນາໃສ່ຄຳຄົ້ນຫາ",
    });
  }

  conn.query(
    "SELECT * FROM unit WHERE unit_name LIKE ?",
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
          message: "ບໍ່ພົບຂໍ້ມູນຫົວໜ່ວຍທີ່ກ່ຽວຂ້ອງ",
        });
      }

      return res.status(200).json({
        success: true,
        message: "ສຳເລັດການຄົ້ນຫາຂໍ້ມູນຫົວໜ່ວຍ",
        data: result,
      });
    }
  );
}

export {
  selectAllUnit,
  selectUnitByID,
  insertUnit,
  updateUnit,
  deleteUnit,
  searchUnit,
};
