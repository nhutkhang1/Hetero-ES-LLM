import { ClusterSummary } from "../components/workers/ClusterSummary";
import { WorkerTable } from "../components/workers/WorkerTable";
import { useWorkers } from "../hooks/useWorkers";
import { LoadingState } from "../components/common/LoadingState";
import { ErrorState } from "../components/common/ErrorState";

export function WorkersPage() {
  const {
    data: workers,
    isPending,
    isError,
    error,
  } = useWorkers();

  if (isPending) {
    return <LoadingState message="Loading workers..." />;
  }

  if (isError) {
      return (
        <ErrorState
          message={`Failed to load workers: ${error.message}`}
        />
      );
  }

  return (
    <section>
      <h2>Workers</h2>

      <ClusterSummary workers={workers} />

      <WorkerTable workers={workers} />
    </section>
  );
}
