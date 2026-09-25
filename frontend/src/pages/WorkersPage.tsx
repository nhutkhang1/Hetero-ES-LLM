import { ClusterSummary } from "../components/workers/ClusterSummary";
import { WorkerTable } from "../components/workers/WorkerTable";
import { useWorkers } from "../hooks/useWorkers";

export function WorkersPage() {
  const {
    data: workers,
    isPending,
    isError,
    error,
  } = useWorkers();

  if (isPending) {
    return <p>Loading workers...</p>;
  }

  if (isError) {
    return <p>Failed to load workers: {error.message}</p>;
  }

  return (
    <section>
      <h2>Workers</h2>

      <ClusterSummary workers={workers} />

      <WorkerTable workers={workers} />
    </section>
  );
}
