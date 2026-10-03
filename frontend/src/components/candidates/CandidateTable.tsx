import type { Candidate } from "../../types/candidate";
import { EmptyState } from "../common/EmptyState";
import { CandidateStatusBadge } from "./CandidateStatusBadge";
import { Link } from "react-router";

interface CandidateTableProps {
  candidates: Candidate[];
}

export function CandidateTable({
  candidates,
}: CandidateTableProps) {
  if (candidates.length === 0) {
    return <EmptyState message="No candidates available." />;
  }

  return (
    <table>
      <thead>
        <tr>
          <th>Candidate</th>
          <th>Status</th>
          <th>Attempt</th>
          <th>Model Version</th>
          <th>Worker</th>
          <th>Seed</th>
          <th>Batch</th>
        </tr>
      </thead>

      <tbody>
        {candidates.map((candidate) => (
          <tr key={candidate.candidateId}>
            <td>
              <Link
                to={`/experiments/${candidate.experimentId}/generations/${candidate.generationId}/candidates/${candidate.candidateId}`}
              >
                {candidate.candidateId}
              </Link>
            </td>

            <td>
              <CandidateStatusBadge status={candidate.status} />
            </td>

            <td>{candidate.attemptId}</td>
            <td>{candidate.modelVersion}</td>
            <td>{candidate.workerId ?? "Unassigned"}</td>
            <td>{candidate.seed}</td>
            <td>{candidate.batchIds.join(", ")}</td>
          </tr>
        ))}
      </tbody>
    </table>
  );
}
