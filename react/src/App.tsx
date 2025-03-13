import { useState, useEffect } from 'react';
import './App.css'
import axios from 'axios'

type Item = {
  price: number;
  qty: number;
}

function App() {
  const [items, setItems] = useState<Item[]>([])

  useEffect(() => {
    axios.get('/items').then(response => setItems(response.data)).catch(console.error)
  }, [])
  console.log(items)

  return (

    <div>{items.length > 0 ? (
      items.map((item, index) => (
        <ul>
          <li key={index}>
            <strong>Price: </strong> ${item.price} <br/>
            <strong>Qty: </strong> ${item.qty} <br/>
          </li>
        </ul>
      ))
    ) : (<div>no items</div>)}
    </div>
  )
}

export default App
