import express from "express";
import cors from "cors";

import "./configs/database.js";
import logger from "./middlewares/logger.js";
import errorHandler from "./middlewares/errorHandler.js";

import categoryRoute from "./routes/category.js";
import unitRoute from "./routes/unit.js";
import productRoute from "./routes/product.js";

const app = express();

app.use(cors());
app.use(express.json());
app.use(logger);

app.use("/api/category", categoryRoute);
app.use("/api/unit", unitRoute);
app.use("/api/product", productRoute);

app.get("/", (req, res) => {
	res.json({
		message: "hello world",
	});
});

app.use("*", (req, res) => {
	res.status(404).json({
		success: false,
		message: "route not found",
	});
});

app.use(errorHandler);

const server_url = process.env.SERVER_HOST || "127.0.0.1"
app.listen(3000, server_url,() => {
	console.log(`server running at  http://${server_url}:3000`);
});
