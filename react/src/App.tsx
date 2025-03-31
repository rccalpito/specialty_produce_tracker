import { useState, useEffect } from 'react';
import './App.css';
import { Line } from 'react-chartjs-2';
import axios from 'axios';
import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  Title,
  Tooltip,
  Legend,
} from 'chart.js';

ChartJS.register(CategoryScale, LinearScale, PointElement, LineElement, Title, Tooltip, Legend);

type Item = {
  name: string;
  price: number;
  qty: number;
};

export const options = {
  responsive: true,
  plugins: {
    legend: {
      position: 'top' as const,
    },
    title: {
      display: true,
      text: 'Item Prices',
    },
  },
};

function App() {
  const [items, setItems] = useState<Item[]>([]);

  useEffect(() => {
    axios
      .get('/items')
      .then((response) => setItems(response.data))
      .catch(console.error);
  }, []);

  const labels = items.map((item) => item.name);
  const prices = items.map((item) => item.price);

  const data = {
    labels,
    datasets: [
      {
        label: 'Price',
        data: prices,
        borderColor: 'rgb(75, 192, 192)',
        backgroundColor: 'rgba(75, 192, 192, 0.2)',
      },
    ],
  };

  return (
    <div>
      <h1>Items Line Chart</h1>
      <Line options={options} data={data} />
    </div>
  );
}

export default App;