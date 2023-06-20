import React, { useEffect } from "react";
import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  BarElement,
  Title,
  Tooltip,
  Legend,
} from "chart.js";
import { Bar } from "react-chartjs-2";
import { BarContainer, PageContainer } from "./styles";

import api from "../../api";

ChartJS.register(
  CategoryScale,
  LinearScale,
  BarElement,
  Title,
  Tooltip,
  Legend
);

export const options = {
  maintainAspectRatio: false,
  plugins: {
    title: {
      display: false,
      text: "",
    },
  },
};

export default function Grafico(props: any) {
  const [data, setData] = React.useState<any>([]);
  const [graphicTitle, setGraphicTitle] = React.useState<any>("");

  useEffect(() => {
    const getData = async () => {
      if (props.value === "movement") {
        const data = await api.get("/movimentosJogos");

        setGraphicTitle("Quantidade de movimentos por jogo");

        setData(
          data.data.map((resp: any) => {
            return {
              label: resp.idjogo,
              bars: resp.totaldemovimentos,
            };
          })
        );
      } else {
        const data = await api.get("/jogadoresPais");

        setGraphicTitle("Quantidade de jogadores por país");

        setData(
          data.data.map((resp: any) => {
            return {
              label: resp.nomepais,
              bars: resp.totaldejogadores,
            };
          })
        );
      }
    };

    getData().catch((err) => console.log(err));
  }, []);

  const typeData = {
    labels: data.map((resp: any) => resp.label),
    datasets: [
      {
        label: graphicTitle,
        data: data.map((resp: any) => resp.bars),
        backgroundColor: "#000",
      },
    ],
  };

  return (
    <PageContainer>
      <BarContainer>
        <Bar options={options} data={typeData} />
      </BarContainer>
    </PageContainer>
  );
}
