import { Routes, Route } from "react-router-dom";
import Home from "./pages/home";
import DetailsPage from "./pages/details";

export default function MainRoutes() {
  return (
    <Routes>
      <Route path="/" element={<Home />} />
      <Route path="/jogosJogador" element={<DetailsPage />} />
      <Route path="/jogosHotel" element={<DetailsPage />} />
      <Route path="/jogosArbitro" element={<DetailsPage />} />
    </Routes>
  );
}
