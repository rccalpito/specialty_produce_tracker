import { Line } from 'react-chartjs-2';
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

type LineChartProps = {
  data: any;
  title: string;
  // handleClick?: (event: any, elements: any, chart: any) => void
  chartOptions: any;
}

function LineChart({
    data,
    chartOptions,
    title,
  }: LineChartProps
){

  return (
    <div>
      <h1 className="text-sm text-center text-white">{title} Line Chart</h1>
      <Line options={chartOptions} data={data} />
    </div>
  );
}

export default LineChart