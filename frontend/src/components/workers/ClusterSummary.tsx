import type { Worker } from "../../types/worker";

interface ClusterSummaryProps {
  workers: Worker[];
}

export function ClusterSummary({
  workers,
}: ClusterSummaryProps) {
  const totalWorkers = workers.length;

  const onlineWorkers = workers.filter(
    (worker) => worker.status === "ONLINE",
  ).length;

  const admittedWorkers = workers.filter(
    (worker) =>
      worker.admissionStatus === "ADMITTED" ||
      worker.admissionStatus === "ADMITTED_LIMITED",
  ).length;

  const totalVramMb = workers.reduce(
    (total, worker) =>
      total + worker.profile.vramTotalMb,
    0,
  );

  return (
    <section>
      <h3>Cluster Summary</h3>

      <div className="cluster-summary">
        <div>
          <strong>{totalWorkers}</strong>
          <span>Total Workers</span>
        </div>

        <div>
          <strong>{onlineWorkers}</strong>
          <span>Online</span>
        </div>

        <div>
          <strong>{admittedWorkers}</strong>
          <span>Admitted</span>
        </div>

        <div>
          <strong>
            {(totalVramMb / 1024).toFixed(0)} GB
          </strong>
          <span>Total VRAM</span>
        </div>
      </div>
    </section>
  );
}
