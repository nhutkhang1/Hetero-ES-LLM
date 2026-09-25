import type { AdmissionStatus } from "../../types/worker";

interface AdmissionBadgeProps {
  status: AdmissionStatus;
}

export function AdmissionBadge({
  status,
}: AdmissionBadgeProps) {
  return (
    <span
      className={`admission-badge admission-${status.toLowerCase()}`}
    >
      {status}
    </span>
  );
}
