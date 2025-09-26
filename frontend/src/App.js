import React, { useState } from "react";
import axios from "axios";
import "./App.css";

function App() {
  const [origin, setOrigin] = useState("");
  const [destination, setDestination] = useState("");
  const [departure, setDeparture] = useState("");
  const [returnDate, setReturnDate] = useState("");
  const [flights, setFlights] = useState([]);

  const [chatMsg, setChatMsg] = useState("");
  const [chatResp, setChatResp] = useState({});

  const [flightId, setFlightId] = useState("");
  const [bookingResp, setBookingResp] = useState({});

  const BASE_URL = process.env.REACT_APP_API_URL || "http://localhost:8080";

  const searchFlights = async () => {
    try {
      const res = await axios.get(`${BASE_URL}/flights/search`, {
        params: { origin, destination, departure, return_date: returnDate }
      });
      setFlights(res.data);
    } catch (err) {
      console.error(err);
      setFlights([{ error: "Failed to fetch flights" }]);
    }
  };

  const sendChat = async () => {
    try {
      const res = await axios.post(`${BASE_URL}/chat/`, { message: chatMsg });
      setChatResp(res.data);
    } catch (err) {
      console.error(err);
      setChatResp({ error: "Failed to get chat response" });
    }
  };

  const createBooking = async () => {
    try {
      const res = await axios.post(`${BASE_URL}/bookings/`, { flight_id: flightId });
      setBookingResp(res.data);
    } catch (err) {
      console.error(err);
      setBookingResp({ error: "Failed to create booking" });
    }
  };

  return (
    <div style={{ padding: 20 }}>
      <h1>FlyBot React Frontend</h1>

      <h2>Flight Search</h2>
      <input placeholder="Origin" value={origin} onChange={e => setOrigin(e.target.value)} />
      <input placeholder="Destination" value={destination} onChange={e => setDestination(e.target.value)} />
      <input type="date" value={departure} onChange={e => setDeparture(e.target.value)} />
      <input type="date" value={returnDate} onChange={e => setReturnDate(e.target.value)} />
      <button onClick={searchFlights}>Search Flights</button>
      <pre>{JSON.stringify(flights, null, 2)}</pre>

      <h2>Chat</h2>
      <input placeholder="Ask something..." value={chatMsg} onChange={e => setChatMsg(e.target.value)} />
      <button onClick={sendChat}>Send</button>
      <pre>{JSON.stringify(chatResp, null, 2)}</pre>

      <h2>Bookings</h2>
      <input placeholder="Flight ID" value={flightId} onChange={e => setFlightId(e.target.value)} />
      <button onClick={createBooking}>Book</button>
      <pre>{JSON.stringify(bookingResp, null, 2)}</pre>
    </div>
  );
}

export default App;
