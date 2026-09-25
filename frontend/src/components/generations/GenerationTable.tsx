import type { Generation } from "../../types/generation";
import { EmptyState } from "../common/EmptyState";
import { GenerationProgress } from "./GenerationProgress";
import { GenerationStatusBadge } from "./GenerationStatusBadge";

interface GenerationTableProps {
  generations: Generation[];
}

export function GenerationTable({
  generations,
}: GenerationTableProps) {
  if (generations.length === 0) {
    return <EmptyState message="No generations available." />;
  }

  return (
    <table>
      <thead>
        <tr>
          <th>Generation</th>
          <th>Status</th>
          <th>Model Version</th>
          <th>Candidate Progress</th>
          <th>Mean Reward</th>
          <th>Best Reward</th>
        </tr>
      </thead>

      <tbody>
        {generations.map((generation) => (
          <tr key={generation.generationId}>
            <td>{generation.generationId}</td>

            <td>
              <GenerationStatusBadge status={generation.status} />
            </td>

            <td>{generation.modelVersion}</td>

            <td>
              <GenerationProgress
                committed={generation.committedCandidateCount}
                total={generation.candidateCount}
              />
            </td>

            <td>
              {generation.rewardMean ?? "N/A"}
            </td>

            <td>
              {generation.rewardBest ?? "N/A"}
            </td>
          </tr>
        ))}
      </tbody>
    </table>
  );
}
