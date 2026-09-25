interface EmptyStateProps {
  message: string;
}

export function EmptyState({
  message,
}: EmptyStateProps) {
  return (
    <div className="state-message">
      <p>{message}</p>
    </div>
  );
}
