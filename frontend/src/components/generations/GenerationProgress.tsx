interface GenerationProgressProps {
  committed: number;
  total: number;
}

export function GenerationProgress({
  committed,
  total,
}: GenerationProgressProps) {
  const percentage =
    total === 0 ? 0 : Math.round((committed / total) * 100);

  return (
    <div>
      <div>
        {committed} / {total} ({percentage}%)
      </div>

      <progress
        value={committed}
        max={total || 1}
      />
    </div>
  );
}
