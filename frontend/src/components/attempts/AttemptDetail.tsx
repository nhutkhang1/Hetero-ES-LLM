import type { Attempt } from "../../types/attempt";

interface AttemptDetailProps {
  attempt: Attempt;
}

export function AttemptDetail({
  attempt,
}: AttemptDetailProps) {
  return (
    <div>
      <div>
        <strong>Attempt ID:</strong>{" "}
        {attempt.attemptId}
      </div>

      <div>
        <strong>Status:</strong>{" "}
        {attempt.status}
      </div>

      <div>
        <strong>Worker:</strong>{" "}
        {attempt.workerId}
      </div>

      <div>
        <strong>Model Version:</strong>{" "}
        {attempt.modelVersion}
      </div>

      <div>
        <strong>Lease Token:</strong>{" "}
        {attempt.leaseToken}
      </div>

      <div>
        <strong>Started At:</strong>{" "}
        {attempt.startedAt ?? "N/A"}
      </div>

      <div>
        <strong>Completed At:</strong>{" "}
        {attempt.completedAt ?? "N/A"}
      </div>

      <div>
        <strong>Error Type:</strong>{" "}
        {attempt.errorType ?? "None"}
      </div>
    </div>
  );
}
