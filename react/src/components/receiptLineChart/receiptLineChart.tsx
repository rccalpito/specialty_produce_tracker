import { useState, useEffect } from 'react';
import { Line } from 'react-chartjs-2';
import ItemizedReceiptModal from '../itemizedReceiptModal/itemizedReceiptModal';
import fetchGraphQL from '../../hooks/fetchGraphQL';
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

export type ReceiptItem = {
  name: string;
  price: number;
  qty: number;
  unitType: number;
};

type Receipts = {
  id: string;
  purchaseDate: string;
  totalPrice: number;
  items: ReceiptItem[];
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

export const ReceiptLineChart = () => {
  const [receipts, setReceipts] = useState<Receipts[]>([]);
  const [receiptId, setReceiptId]  = useState<string>()
  const [showModal, setShowModal] = useState(false);

  const handleClick = (event: any, elements: any[], chart: any) => {
    if (!elements.length) return;
    const index = elements[0].index;
    const receipt = receipts[index];
    setReceiptId(receipt.id)
    setShowModal(true);
  };

  const chartOptions = {
    ...options,
    onClick: (event: any, elements: any, chart: any) => handleClick(event, elements, chart),
  };

  useEffect(() => {
    const query = `
      query getReceipts {
        receipts {
          id
          purchaseDate
          receiptNumber
          totalPrice
        }
      }
    `
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

  useEffect(() => {
    console.log(data)
  }, [data])

  return (
    <div>
      <h1>Receipts Line Chart</h1>
      <Line options={chartOptions} data={data} />
      {showModal && (
        <ItemizedReceiptModal
          receiptId={receiptId}
          show={showModal}
          onClose={(() => setShowModal(false))}
          />
        )
      }
    </div>
  );
}