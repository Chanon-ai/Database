import express from "express";
import cors from "cors";
import mysql from "mysql2";

const app = express();
app.use(cors());
app.use(express.json());
app.use(express.static("public"));


const pool = mysql.createPool({
  host: "localhost",
  user: "root",    
  password: "",       
  database: "database", // ชื่อฐานข้อมูล
  connectionLimit: 10,
}).promise();


app.get("/api/flights", async (req, res) => {
  const { origin, destination, date } = req.query;

  let query = "SELECT * FROM flights WHERE 1=1";
  const params = [];

  if (origin) {
    query += " AND origin_code = ?";
    params.push(origin);
  }
  if (destination) {
    query += " AND destination_code = ?";
    params.push(destination);
  }
  if (date) {
    query += " AND flight_date = ?";
    params.push(date);
  }

  try {
    const [rows] = await pool.query(query, params);
    res.json(rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Database query failed" });
  }
});



app.post("/api/book", async (req, res) => {
  const { flight_id, passenger_id } = req.body;

  if (!flight_id || !passenger_id) {
    return res.status(400).json({ error: "Missing flight_id or passenger_id" });
  }

  try {
    const [result] = await pool.query(
      "INSERT INTO bookings (flight_id, passenger_id) VALUES (?, ?)",
      [flight_id, passenger_id]
    );

    res.json({ success: true, bookingId: result.insertId });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Failed to create booking" });
  }
});


app.get("/api/bookings", async (req, res) => {
  try {
    const [rows] = await pool.query(`
      SELECT 
        b.id AS booking_id,
        f.flight_number,
        CONCAT(f.origin_code, ' → ', f.destination_code) AS route,
        f.flight_date,
        f.depart_time,
        f.price,
        CONCAT(p.first_name, ' ', p.last_name) AS passenger,
        p.email,
        p.phone,
        b.booking_date
      FROM bookings b
      JOIN flights f ON b.flight_id = f.id
      JOIN passengers p ON b.passenger_id = p.id
      ORDER BY b.booking_date DESC
    `);
    res.json(rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Failed to fetch bookings" });
  }
});


const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Server running at: http://localhost:${PORT}`);
});
