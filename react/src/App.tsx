import { useState, useEffect } from 'react';
import './App.css';
import { Line } from 'react-chartjs-2';
// import axios from 'axios';
import fetchGraphQL from './hooks/fetchGraphQL';
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

type Receipts = {
  purchaseDate: string;
  totalPrice: number;
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
  const [receipts, setReceipts] = useState<Receipts[]>([]);

  useEffect(() => {
    const query = `
      query GetReceipts {
        receipts {
          id
          purchaseDate
          totalPrice
        }
      }
    `;

    fetchGraphQL(query, {}).then((response) => {
      if (response.data) {
        setReceipts(response.data.receipts);
      } else {
        console.error('GraphQL error:', response.errors);
      }
    });
  }, []);

  useEffect(() => {
    console.log(receipts)
  }, [receipts])
  // useEffect(() => {
  //   axios
  //     .get('/receipts')
  //     .then((response) => setReceipts(response.data))
  //     .catch(console.error);
  // }, []);

  const labels = receipts.map((item) => item.purchaseDate);
  const prices = receipts.map((item) => item.totalPrice);

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
      <h1>Receipts Line Chart</h1>
      <Line options={options} data={data} />
    </div>
  );
}

export default App;