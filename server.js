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

app.get("/api/airports", async (req, res) => {
  try {
    const [rows] = await pool.query("SELECT * FROM airports ORDER BY city, name");
    res.json(rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Failed to fetch airports" });
  }
});


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

app.get("/api/flights/:id", async (req, res) => {
  const { id } = req.params;

  try {
    const [rows] = await pool.query("SELECT * FROM flights WHERE id = ?", [id]);
    if (rows.length === 0) {
      return res.status(404).json({ error: "Flight not found" });
    }
    res.json(rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Failed to fetch flight details" });
  }
});


app.post("/api/book", async (req, res) => {
  const { flight_id, name, email, phone } = req.body;

  if (!flight_id || !name || !email || !phone) {
    return res.status(400).json({ error: "Missing data" });
  }

  try {
    const [existing] = await pool.query("SELECT id FROM passengers WHERE email = ?", [email]);
    let passengerId = existing.length ? existing[0].id : null;

    if (!passengerId) {
      const [pResult] = await pool.query(
        "INSERT INTO passengers (first_name, last_name, email, phone) VALUES (?, ?, ?, ?)",
        [name.split(" ")[0], name.split(" ").slice(1).join(" ") || "-", email, phone]
      );
      passengerId = pResult.insertId;
    }

    const [bResult] = await pool.query(
      "INSERT INTO bookings (flight_id, passenger_id) VALUES (?, ?)",
      [flight_id, passengerId]
    );
    const bookingId = bResult.insertId;

    const [fResult] = await pool.query("SELECT price FROM flights WHERE id = ?", [flight_id]);
    const price = fResult[0].price;

    await pool.query(
      "INSERT INTO payments (booking_id, amount, status) VALUES (?, ?, ?)",
      [bookingId, price, "pending"]
    );

    res.json({ success: true, bookingId });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Server error. Please try again." });
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
        f.image,
        CONCAT(p.first_name, ' ', p.last_name) AS passenger,
        p.email,
        p.phone,
        b.booking_date,
        pay.status AS payment_status,
        pay.transaction_code,
        pay.payment_date
      FROM bookings b
      JOIN flights f ON b.flight_id = f.id
      JOIN passengers p ON b.passenger_id = p.id
      LEFT JOIN payments pay ON pay.booking_id = b.id
      ORDER BY b.booking_date DESC
    `);
    res.json(rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Failed to fetch bookings" });
  }
});


app.delete("/api/bookings", async (req, res) => {
  try {
    await pool.query("DELETE FROM bookings");
    res.json({ success: true });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Failed to clear bookings" });
  }
});


app.post("/api/payment/confirm", async (req, res) => {
  const { booking_id, transaction_code } = req.body;

  if (!booking_id || !transaction_code) {
    return res.status(400).json({ error: "Missing booking_id or transaction_code" });
  }

  try {
    await pool.query(
      `UPDATE payments 
       SET status = ?, transaction_code = ?, payment_date = NOW()
       WHERE booking_id = ?`,
      ["paid", transaction_code, booking_id]
    );

    res.json({ success: true, message: "Payment confirmed" });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Failed to confirm payment" });
  }
});



const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Server running at: http://localhost:${PORT}`);
});
