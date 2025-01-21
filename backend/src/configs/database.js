import mysql from "mysql";

const conn = mysql.createConnection({
	host: process.env.MYSQL_HOST,
	user: process.env.MYSQL_USER,
	password: process.env.MYSQL_PASSWORD,
	port: process.env.MYSQL_PORT,
	database: process.env.MYSQL_DATABASE,
});

conn.connect((err) => {
	if (err) console.log("Error connect to database");

	console.log("Database connect successfully");
});

export default conn;
