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
		},
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
		},
	);
}

export { selectAllCategory, selectCategoryByID, insertCategory };
