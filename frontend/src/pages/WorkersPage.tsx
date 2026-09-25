import { ClusterSummary } from "../components/workers/ClusterSummary";
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

      {workers.length === 0 ? (
        <p>No workers available.</p>
      ) : (
        <table>
          <thead>
            <tr>
              <th>Worker</th>
              <th>GPU</th>
              <th>Status</th>
              <th>Admission</th>
              <th>VRAM</th>
              <th>Throughput</th>
            </tr>
          </thead>

          <tbody>
            {workers.map((worker) => (
              <tr key={worker.workerId}>
                <td>{worker.workerId}</td>
                <td>{worker.profile.gpuName}</td>
                <td>{worker.status}</td>
                <td>{worker.admissionStatus}</td>
                <td>{worker.profile.vramTotalMb} MB</td>
                <td>
                  {worker.profile.throughputTokensPerSecond ?? "N/A"}
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
    </section>
  );
}
