import { useParams } from "react-router";
import { AdmissionBadge } from "../components/workers/AdmissionBadge";
import { WorkerStatusBadge } from "../components/workers/WorkerStatusBadge";
import { useWorker } from "../hooks/useWorker";

export function WorkerDetailPage() {
  const { workerId = "" } = useParams();

  const {
    data: worker,
    isPending,
    isError,
    error,
  } = useWorker(workerId);

  if (isPending) {
    return <p>Loading worker...</p>;
  }

  if (isError) {
    return <p>Failed to load worker: {error.message}</p>;
  }

  return (
    <section>
      <h2>{worker.workerId}</h2>

      <p>
        <WorkerStatusBadge status={worker.status} />
      </p>

      <h3>GPU Profile</h3>

      <dl>
        <dt>GPU</dt>
        <dd>{worker.profile.gpuName}</dd>

        <dt>Total VRAM</dt>
        <dd>{worker.profile.vramTotalMb} MB</dd>

        <dt>Free VRAM</dt>
        <dd>{worker.profile.vramFreeMb ?? "N/A"} MB</dd>

        <dt>Throughput</dt>
        <dd>
          {worker.profile.throughputTokensPerSecond ?? "N/A"} tok/s
        </dd>

        <dt>Safe Chunk Size</dt>
        <dd>{worker.profile.safeChunkSize ?? "N/A"}</dd>
      </dl>

      <h3>Admission</h3>

      <p>
        <AdmissionBadge status={worker.admissionStatus} />
      </p>

      <p>{worker.admissionReason ?? "No admission reason available."}</p>

      <h3>Heartbeat</h3>

      <p>{worker.lastHeartbeatAt ?? "N/A"}</p>
    </section>
  );
}
