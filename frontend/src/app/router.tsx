import { Navigate, Route, Routes } from "react-router";

import { AppLayout } from "../components/layout/AppLayout";
import { ArtifactsPage } from "../pages/ArtifactsPage";
import { DashboardPage } from "../pages/DashboardPage";
import { EventsPage } from "../pages/EventsPage";
import { ExperimentsPage } from "../pages/ExperimentsPage";
import { NotFoundPage } from "../pages/NotFoundPage";
import { WorkersPage } from "../pages/WorkersPage";
import { WorkerDetailPage } from "../pages/WorkerDetailPage";

export function AppRouter() {
  return (
    <Routes>
      <Route element={<AppLayout />}>
        <Route index element={<Navigate to="/dashboard" replace />} />

        <Route path="/dashboard" element={<DashboardPage />} />
        <Route path="/workers" element={<WorkersPage />} />
        <Route
          path="/workers/:workerId"
          element={<WorkerDetailPage />}
        />
        <Route path="/experiments" element={<ExperimentsPage />} />
        <Route path="/events" element={<EventsPage />} />
        <Route path="/artifacts" element={<ArtifactsPage />} />

        <Route path="*" element={<NotFoundPage />} />
      </Route>
    </Routes>
  );
}
