import { Routes, Route } from "react-router-dom";
import Home from "./pages/home";
import DetailsPage from "./pages/details";

export default function MainRoutes() {
  return (
    <Routes>
      <Route path="/" element={<Home />} />
      <Route path="/players" element={<DetailsPage />} />
      <Route path="/hotels" element={<DetailsPage />} />
      <Route path="/referees" element={<DetailsPage />} />
    </Routes>
  );
}
