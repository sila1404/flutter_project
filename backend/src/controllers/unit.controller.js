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

  conn.query("INSERT INTO unit VALUES (?)", [unit_name], (err, result) => {
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
  });
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

  conn.query("SELECT * FROM unit WHERE unit_id = ?", cID, (err, result) => {
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
      "UPDATE category SET unit_name = ? WHERE unit_id = ?",
      [unit_name, result[0].unit_id],
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
  });
}

function deleteUnit(req, res) {
  const { uID } = req.params;
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
      "DELETE FROM unit WHERE unit_id = ?",
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
          message: "ສຳເລັດການລົບຫົວໜ່ວຍ",
        });
      }
    );
  });
}

export { selectAllUnit, selectUnitByID, insertUnit, updateUnit, deleteUnit };
