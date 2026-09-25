interface ErrorStateProps {
  message: string;
}

export function ErrorState({
  message,
}: ErrorStateProps) {
  return (
    <div className="state-message state-error">
      <p>{message}</p>
    </div>
  );
}
