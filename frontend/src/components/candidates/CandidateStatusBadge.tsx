import type { CandidateStatus } from "../../types/candidate";

interface CandidateStatusBadgeProps {
  status: CandidateStatus;
}

export function CandidateStatusBadge({
  status,
}: CandidateStatusBadgeProps) {
  return (
    <span className={`status-badge status-${status.toLowerCase()}`}>
      {status}
    </span>
  );
}
