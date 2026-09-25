import type { Worker } from "../../types/worker";
import { AdmissionBadge } from "./AdmissionBadge";
import { WorkerStatusBadge } from "./WorkerStatusBadge";
import { Link } from "react-router";

interface WorkerTableProps {
  workers: Worker[];
}

export function WorkerTable({
  workers,
}: WorkerTableProps) {
  if (workers.length === 0) {
    return <p>No workers available.</p>;
  }

  return (
    <table>
      <thead>
        <tr>
          <th>Worker</th>
          <th>GPU</th>
          <th>Status</th>
          <th>Admission</th>
          <th>VRAM</th>
          <th>Free VRAM</th>
          <th>Throughput</th>
          <th>Safe Chunk</th>
        </tr>
      </thead>

      <tbody>
        {workers.map((worker) => (
          <tr key={worker.workerId}>

            <td>
              <Link to={`/workers/${worker.workerId}`}>
                {worker.workerId}
              </Link>
            </td>

            <td>{worker.profile.gpuName}</td>

            <td>
              <WorkerStatusBadge status={worker.status} />
            </td>

            <td>
              <AdmissionBadge
                status={worker.admissionStatus}
              />
            </td>

            <td>
              {worker.profile.vramTotalMb} MB
            </td>

            <td>
              {worker.profile.vramFreeMb !== undefined
                ? `${worker.profile.vramFreeMb} MB`
                : "N/A"}
            </td>

            <td>
              {worker.profile.throughputTokensPerSecond !== undefined
                ? `${worker.profile.throughputTokensPerSecond} tok/s`
                : "N/A"}
            </td>

            <td>
              {worker.profile.safeChunkSize ?? "N/A"}
            </td>
          </tr>
        ))}
      </tbody>
    </table>
  );
}
