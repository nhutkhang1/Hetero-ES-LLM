import type { Experiment } from "../../types/experiment";
import { EmptyState } from "../common/EmptyState";
import { ExperimentStatusBadge } from "./ExperimentStatusBadge";

interface ExperimentTableProps {
  experiments: Experiment[];
}

export function ExperimentTable({
  experiments,
}: ExperimentTableProps) {
  if (experiments.length === 0) {
    return <EmptyState message="No experiments available." />;
  }

  return (
    <table>
      <thead>
        <tr>
          <th>Experiment</th>
          <th>Status</th>
          <th>Model</th>
          <th>Version</th>
          <th>Scheduler</th>
          <th>Sync Mode</th>
          <th>Generation</th>
        </tr>
      </thead>

      <tbody>
        {experiments.map((experiment) => (
          <tr key={experiment.experimentId}>
            <td>{experiment.name}</td>

            <td>
              <ExperimentStatusBadge status={experiment.status} />
            </td>

            <td>{experiment.modelName}</td>

            <td>{experiment.modelVersion}</td>

            <td>{experiment.schedulerPolicy}</td>

            <td>{experiment.syncMode}</td>

            <td>{experiment.currentGenerationId ?? "N/A"}</td>
          </tr>
        ))}
      </tbody>
    </table>
  );
}
