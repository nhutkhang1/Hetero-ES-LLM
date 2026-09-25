interface WorkerStatusBadgeProps {
  status: string;
}

export function WorkerStatusBadge({
  status,
}: WorkerStatusBadgeProps) {
  return (
    <span className={`status-badge status-${status.toLowerCase()}`}>
      {status}
    </span>
  );
}
