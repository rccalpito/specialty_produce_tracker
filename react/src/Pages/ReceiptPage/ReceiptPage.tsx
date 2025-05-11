import { useEffect, useState } from "react";
import fetchGraphQL from "../../hooks/fetchGraphQL";
import LineChart from "../../components/LineChart/LineChart";
import ItemizedReceiptModal from "../../components/ItemizedReceiptModal/ItemizedReceiptModal";

type ReceiptItem = {
  name: string;
  price: number;
  qty: number;
  unitType: number;
  unitPrice: number;
  receipt: Receipts
};

type Receipts = {
  id: string;
  purchaseDate: string;
  totalPrice: number;
  items: ReceiptItem[];
};

const receiptLineChartOptions = {
  responsive: true,
  plugins: {
    legend: {
      position: 'top' as const,
    },
    title: {
      display: true,
      text: 'Total Receipt Cost',
    },
  },
};

function ReceiptPage() {
  const [receipts, setReceipts] = useState<Receipts[]>([]);
  const [items, setItems] = useState<ReceiptItem[]>([]);
  const purchaseDate = receipts.map((item) => item.purchaseDate);
  const total = receipts.map((item) => item.totalPrice);
  const [showModal, setShowModal]  = useState<boolean>(true)
  const [receiptId, setReceiptId]  = useState<string>()
  const [showOtherLineChart, setShowOtherLineChart] = useState<boolean>(false)

  const handleClick = (event: any, elements: any[], chart: any) => {
    if (!elements.length) return;
    const index = elements[0].index;
    const receipt = receipts[index];
    setReceiptId(receipt.id)
  };

  const handleOtherClick = (itemName: string) => {
    const query = `
      query GetItemPriceHistory($name: String!) {
        priceHistory(name: $name) {
          name
          unitPrice
          receipt {
            purchaseDate
          }
        }
      }
    `;

    fetchGraphQL(query, { name: itemName }).then((response) => {
      if (response.data) {
        console.log("Price history:", response.data.priceHistory);
        setShowOtherLineChart(true)
        setItems(response.data.priceHistory)
      }
    });
  };

  const itemData = {
    labels: items.map((item) => item.receipt.purchaseDate),
    datasets: [
      {
        label: 'Price',
        data: items.map((item) => item.unitPrice),
        borderColor: 'rgb(153, 102, 255)',
        backgroundColor: 'rgba(153, 102, 255, 0.2)',
      }
    ]
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

  const receiptData = {
    labels: purchaseDate,
    datasets: [
      {
        label: 'Total',
        data: total,
        borderColor: 'rgb(75, 192, 192)',
        backgroundColor: 'rgba(75, 192, 192, 0.2)',
      },
    ],
  };

  const receiptChartOptions = {
    responsive: true,
    plugins: {
      legend: {
        position: 'top' as const,
      },
      title: {
        display: true,
        text: 'Total Receipt Cost',
      },
    },
    onClick: (event: any, elements: any, chart: any) => handleClick(event, elements, chart),
  };

  const priceHistoryChartOptions = {
    responsive: true,
    plugins: {
      legend: {
        position: 'top' as const,
      },
      title: {
        display: true,
        text: 'Total Receipt Cost',
      },
    },
  }

  return (
    <div className="flex flex-row gap-4 items-start">
      <div className="w-full lg:w-1/2 flex flex-col gap-4">
        <LineChart
          data={receiptData}
          title="Receipt"
          chartOptions={receiptChartOptions}
        />

        {showOtherLineChart && (
          <LineChart
            data={itemData}
            title="Price History"
            chartOptions={priceHistoryChartOptions}
          />
        )}
      </div>

      {showModal && (
        <div className="w-full lg:w-1/2 max-w-xl">
          <ItemizedReceiptModal
            receiptId={receiptId}
            onClick={handleOtherClick}
            onClose={() => setShowModal(false)}
          />
        </div>
      )}
    </div>
  );
}

export default ReceiptPage