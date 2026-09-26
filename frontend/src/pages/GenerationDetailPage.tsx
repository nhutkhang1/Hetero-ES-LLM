import { useParams } from "react-router";

import { CandidateTable } from "../components/candidates/CandidateTable";
import { ErrorState } from "../components/common/ErrorState";
import { LoadingState } from "../components/common/LoadingState";
import { GenerationProgress } from "../components/generations/GenerationProgress";
import { GenerationStatusBadge } from "../components/generations/GenerationStatusBadge";

import { useCandidates } from "../hooks/useCandidates";
import { useGeneration } from "../hooks/useGeneration";

export function GenerationDetailPage() {
  const {
    experimentId = "",
    generationId = "",
  } = useParams();

  const {
    data: generation,
    isPending,
    isError,
    error,
  } = useGeneration(experimentId, generationId);

  const {
    data: candidates,
    isPending: candidatesPending,
    isError: candidatesError,
    error: candidatesErrorData,
  } = useCandidates(generationId);

  if (isPending) {
    return <LoadingState message="Loading generation..." />;
  }

  if (isError) {
    return (
      <ErrorState
        message={`Failed to load generation: ${error.message}`}
      />
    );
  }

  return (
    <section>
      <h2>{generation.generationId}</h2>

      <div>
        <strong>Experiment:</strong>{" "}
        {generation.experimentId}
      </div>

      <div>
        <strong>Status:</strong>{" "}
        <GenerationStatusBadge status={generation.status} />
      </div>

      <div>
        <strong>Model Version:</strong>{" "}
        {generation.modelVersion}
      </div>

      <div>
        <strong>Candidate Progress:</strong>

        <GenerationProgress
          committed={generation.committedCandidateCount}
          total={generation.candidateCount}
        />
      </div>

      <div>
        <strong>Mean Reward:</strong>{" "}
        {generation.rewardMean ?? "N/A"}
      </div>

      <div>
        <strong>Best Reward:</strong>{" "}
        {generation.rewardBest ?? "N/A"}
      </div>

      <div>
        <strong>Started At:</strong>{" "}
        {generation.startedAt ?? "N/A"}
      </div>

      <div>
        <strong>Completed At:</strong>{" "}
        {generation.completedAt ?? "N/A"}
      </div>

      <hr />

      <section>
        <h3>Candidates</h3>

        {candidatesPending && (
          <LoadingState message="Loading candidates..." />
        )}

        {candidatesError && (
          <ErrorState
            message={`Failed to load candidates: ${candidatesErrorData.message}`}
          />
        )}

        {candidates && (
          <CandidateTable candidates={candidates} />
        )}
      </section>
    </section>
  );
}
