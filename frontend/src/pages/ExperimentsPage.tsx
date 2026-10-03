import { ErrorState } from "../components/common/ErrorState";
import { LoadingState } from "../components/common/LoadingState";
import { ExperimentSummary } from "../components/experiments/ExperimentSummary";
import { ExperimentTable } from "../components/experiments/ExperimentTable";
import { useExperiments } from "../hooks/useExperiments";

export function ExperimentsPage() {
  const {
    data: experiments,
    isPending,
    isError,
    error,
  } = useExperiments();

  if (isPending) {
    return <LoadingState message="Loading experiments..." />;
  }

  if (isError) {
    return (
      <ErrorState
        message={`Failed to load experiments: ${error.message}`}
      />
    );
  }

  return (
    <section>
      <h2>Experiments</h2>

      <ExperimentSummary experiments={experiments} />

      <ExperimentTable experiments={experiments} />
    </section>
  );
}
