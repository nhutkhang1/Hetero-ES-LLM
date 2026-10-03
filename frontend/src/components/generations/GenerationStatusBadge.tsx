interface GenerationStatusBadgeProps {
  status: string;
}

export function GenerationStatusBadge({
  status,
}: GenerationStatusBadgeProps) {
  return (
    <span className={`status-badge status-${status.toLowerCase()}`}>
      {status}
    </span>
  );
}
