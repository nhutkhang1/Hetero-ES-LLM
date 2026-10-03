import { useParams } from "react-router";

import { AttemptDetail } from "../components/attempts/AttemptDetail";
import { CandidateStatusBadge } from "../components/candidates/CandidateStatusBadge";
import { ErrorState } from "../components/common/ErrorState";
import { LoadingState } from "../components/common/LoadingState";

import { useAttempt } from "../hooks/useAttempt";
import { useCandidate } from "../hooks/useCandidate";

export function CandidateDetailPage() {
  const {
    candidateId = "",
  } = useParams();

  const {
    data: candidate,
    isPending,
    isError,
    error,
  } = useCandidate(candidateId);

  const shouldLoadAttempt = Boolean(
    candidate?.attemptId &&
    candidate?.workerId &&
    candidate?.leaseToken,
  );

  const {
    data: attempt,
    isPending: attemptPending,
    isError: attemptError,
    error: attemptErrorData,
  } = useAttempt(
    candidate?.attemptId ?? "",
    shouldLoadAttempt,
  );

  if (isPending) {
    return (
      <LoadingState message="Loading candidate..." />
    );
  }

  if (isError) {
    return (
      <ErrorState
        message={`Failed to load candidate: ${error.message}`}
      />
    );
  }

  return (
    <section>
      <h2>{candidate.candidateId}</h2>

      <h3>Candidate Descriptor</h3>

      <div>
        <strong>Status:</strong>{" "}
        <CandidateStatusBadge status={candidate.status} />
      </div>

      <div>
        <strong>Experiment:</strong>{" "}
        {candidate.experimentId}
      </div>

      <div>
        <strong>Generation:</strong>{" "}
        {candidate.generationId}
      </div>

      <div>
        <strong>Attempt ID:</strong>{" "}
        {candidate.attemptId}
      </div>

      <div>
        <strong>Model Version:</strong>{" "}
        {candidate.modelVersion}
      </div>

      <div>
        <strong>Seed:</strong>{" "}
        {candidate.seed}
      </div>

      <div>
        <strong>Noise Recipe Hash:</strong>{" "}
        {candidate.noiseRecipeHash}
      </div>

      <div>
        <strong>Generation Config Hash:</strong>{" "}
        {candidate.generationConfigHash}
      </div>

      <div>
        <strong>Batch IDs:</strong>{" "}
        {candidate.batchIds.join(", ")}
      </div>

      <h3>Lease Information</h3>

      <div>
        <strong>Worker:</strong>{" "}
        {candidate.workerId ?? "Unassigned"}
      </div>

      <div>
        <strong>Lease Token:</strong>{" "}
        {candidate.leaseToken ?? "N/A"}
      </div>

      <div>
        <strong>Lease Deadline:</strong>{" "}
        {candidate.leaseDeadline ?? "N/A"}
      </div>

      <hr />

      <h3>Attempt</h3>

      {!shouldLoadAttempt && (
        <p>Attempt not started.</p>
      )}

      {shouldLoadAttempt && attemptPending && (
        <LoadingState message="Loading attempt..." />
      )}

      {shouldLoadAttempt && attemptError && (
        <ErrorState
          message={`Failed to load attempt: ${attemptErrorData.message}`}
        />
      )}

      {attempt && (
        <AttemptDetail attempt={attempt} />
      )}
    </section>
  );
}
