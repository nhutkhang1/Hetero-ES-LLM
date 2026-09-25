import type { Experiment } from "../../types/experiment";

interface ExperimentSummaryProps {
  experiments: Experiment[];
}

export function ExperimentSummary({
  experiments,
}: ExperimentSummaryProps) {
  const totalExperiments = experiments.length;

  const runningExperiments = experiments.filter(
    (experiment) => experiment.status === "RUNNING",
  ).length;

  const completedExperiments = experiments.filter(
    (experiment) => experiment.status === "COMPLETED",
  ).length;

  const activeModelVersion =
    experiments.find((experiment) => experiment.status === "RUNNING")
      ?.modelVersion ?? "N/A";

  return (
    <section>
      <h3>Experiment Summary</h3>

      <div className="cluster-summary">
        <div>
          <strong>{totalExperiments}</strong>
          <span>Total Experiments</span>
        </div>

        <div>
          <strong>{runningExperiments}</strong>
          <span>Running</span>
        </div>

        <div>
          <strong>{completedExperiments}</strong>
          <span>Completed</span>
        </div>

        <div>
          <strong>{activeModelVersion}</strong>
          <span>Active Model Version</span>
        </div>
      </div>
    </section>
  );
}
