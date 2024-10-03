import React, { useEffect, useState } from 'react';
import axios from 'axios';

function App() {
  const [data, setData] = useState("");

  useEffect(() => {
    axios.get("/api/message")
      .then(response => {
        console.log("response = ", response);
        console.log("response.data = ", response.data);
        setData(response.data);
      })
      .catch(error => {
        console.error("There was an error fetching the data!", error);
      });
  }, []);

  return (
    <div>
      <h1>Hello World!</h1>
      <h2>React with Go Backend</h2>
      <p>{data}</p>
    </div>
  );
}

export default App;