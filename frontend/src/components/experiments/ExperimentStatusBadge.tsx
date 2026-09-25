interface ExperimentStatusBadgeProps {
  status: string;
}

export function ExperimentStatusBadge({
  status,
}: ExperimentStatusBadgeProps) {
  return (
    <span className={`status-badge status-${status.toLowerCase()}`}>
      {status}
    </span>
  );
}
