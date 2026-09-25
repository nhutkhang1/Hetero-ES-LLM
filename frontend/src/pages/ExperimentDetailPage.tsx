import { useParams } from "react-router";
import { ErrorState } from "../components/common/ErrorState";
import { LoadingState } from "../components/common/LoadingState";
import { ExperimentStatusBadge } from "../components/experiments/ExperimentStatusBadge";
import { useExperiment } from "../hooks/useExperiment";

export function ExperimentDetailPage() {
  const { experimentId = "" } = useParams();

  const {
    data: experiment,
    isPending,
    isError,
    error,
  } = useExperiment(experimentId);

  if (isPending) {
    return (
      <LoadingState message="Loading experiment..." />
    );
  }

  if (isError) {
    return (
      <ErrorState
        message={`Failed to load experiment: ${error.message}`}
      />
    );
  }

  return (
    <section>
      <h2>{experiment.name}</h2>

      <div>
        <strong>Experiment ID:</strong>{" "}
        {experiment.experimentId}
      </div>

      <div>
        <strong>Status:</strong>{" "}
        <ExperimentStatusBadge status={experiment.status} />
      </div>

      <div>
        <strong>Model:</strong> {experiment.modelName}
      </div>

      <div>
        <strong>Model Version:</strong>{" "}
        {experiment.modelVersion}
      </div>

      <div>
        <strong>Scheduler:</strong>{" "}
        {experiment.schedulerPolicy}
      </div>

      <div>
        <strong>Sync Mode:</strong>{" "}
        {experiment.syncMode}
      </div>

      <div>
        <strong>Current Generation:</strong>{" "}
        {experiment.currentGenerationId ?? "N/A"}
      </div>

      <div>
        <strong>Created At:</strong>{" "}
        {experiment.createdAt}
      </div>

      <div>
        <strong>Started At:</strong>{" "}
        {experiment.startedAt ?? "N/A"}
      </div>

      <div>
        <strong>Completed At:</strong>{" "}
        {experiment.completedAt ?? "N/A"}
      </div>
    </section>
  );
}
