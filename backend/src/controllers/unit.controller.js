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

export { selectAllUnit, selectUnitByID, insertUnit };
