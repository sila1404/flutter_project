function selectAllProduct(req, res) {
	//TODO: might also select product base on category
	conn.query("SELECT * FROM product", (err, result) => {
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
	});
}

function selectProductByID(req, res) {
	//TODO: might also select product base on category
	const { pID } = req.params;
	conn.query(
		"SELECT * FROM product WHERE product_id = ?",
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
		},
	);
}

function insertProduct(req, res) {
	//TODO: continue to implement insert product logic
	const { product_name, sale_price } = req.body;
	if (!product_name || !sale_price) {
		res.status(400).json({
			success: false,
			message: "ກະລຸນາໃສ່ຊື່ສິນຄ້າ ແລະ ລາຄາ",
		});
	}

	conn.query(
		"INSERT INTO product VALUES (?, ?)",
		[product_name, sale_price],
		(err, result) => {
			if (err) {
				res.status(500).json({
					success: false,
					message: err.message,
				});
			}

			res.status(201).json({
				success: true,
				message: "ສຳເລັດການເພີ່ມຂໍ້ມູນສິນຄ້າ",
			});
		},
	);
}

function updateProduct(req, res) {
	//TODO: implement update product logic
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
				},
			);
		},
	);
}

export {
	selectAllProduct,
	selectProductByID,
	insertProduct,
	updateProduct,
	deleteProduct,
};
