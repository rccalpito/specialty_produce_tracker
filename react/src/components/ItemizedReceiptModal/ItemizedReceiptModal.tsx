import { useEffect, useState } from "react";
import fetchGraphQL from "../../hooks/fetchGraphQL";
import { ReceiptItem } from "../LineChart/LineChart";

type receipt = {
  id: string;
  purchaseDate: string;
  totalPrice: number;
  items: ReceiptItem[]
}

type ItemizedReceiptModalProps = {
  receiptId: string | undefined;
  onClick: (itemName: string) => void
  onClose: () => void;
};

function ItemizedReceiptModal({ receiptId, onClose, onClick }: ItemizedReceiptModalProps) {
  const [receipt, setReceipt] = useState<receipt>()

  useEffect(() => {
    if (!receiptId) return;
    console.log(receiptId)

    const query =
    `query GetReceiptWithItems($receiptId: ID!) {
        receipt(id: $receiptId) {
          id
          purchaseDate
          totalPrice
          items {
            name
            price
            qty
            unitType
            unitPrice
          }
        }
      }`;

    fetchGraphQL(query, { receiptId }).then((response) => {
      if (response.data) {
        setReceipt(response.data.receipt);
      }
    });
  }, [receiptId]);

  return (
    <div className="text-white overflow-x-auto">
      <table className="min-w-full border border-white">
        <thead>
          <tr className="bg-gray-800 text-left">
            <th className="px-4 py-2 border-b border-white">Item</th>
            <th className="px-4 py-2 border-b border-white">Quantity</th>
            <th className="px-4 py-2 border-b border-white">Unit Price</th>
            <th className="px-4 py-2 border-b border-white">Amount</th>
          </tr>
        </thead>
        <tbody>
          {receipt?.items.map((item, index) => (
            <tr
            key={index}
            className="border-t border-white cursor-pointer hover:bg-gray-700"
            onClick={() => onClick(item.name)}
          >
              <td className="px-4 py-2">{item.name}</td>
              <td className="px-4 py-2">
                {item.qty} {item.unitType === "per" ? "" : item.unitType}
              </td>
              <td className="px-4 py-2">
                {item.unitPrice}$ {item.unitType === "lbs" ? "lb" : item.unitType}
              </td>
              <td className="px-4 py-2">${item.price.toFixed(2)}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}

export default ItemizedReceiptModal