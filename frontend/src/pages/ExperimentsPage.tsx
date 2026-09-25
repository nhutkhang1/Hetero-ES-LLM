import { useCandidates } from "../hooks/useCandidates";
import { useExperiments } from "../hooks/useExperiments";
import { useGenerations } from "../hooks/useGenerations";

export function ExperimentsPage() {
  const experimentsQuery = useExperiments();

  const experimentId =
    experimentsQuery.data?.[0]?.experimentId ?? "";

  const generationsQuery = useGenerations(experimentId);

  const generationId =
    generationsQuery.data?.find(
      (generation) => generation.status === "RUNNING",
    )?.generationId ??
    generationsQuery.data?.[0]?.generationId ??
    "";

  const candidatesQuery = useCandidates(generationId);

  if (experimentsQuery.isPending) {
    return <p>Loading experiments...</p>;
  }

  if (experimentsQuery.isError) {
    return (
      <p>
        Failed to load experiments:{" "}
        {experimentsQuery.error.message}
      </p>
    );
  }

  return (
    <section>
      <h2>Experiments</h2>

      <h3>Experiments</h3>

      {experimentsQuery.data.length === 0 ? (
        <p>No experiments available.</p>
      ) : (
        <ul>
          {experimentsQuery.data.map((experiment) => (
            <li key={experiment.experimentId}>
              <strong>{experiment.name}</strong>
              {" — "}
              {experiment.status}
              {" — "}
              {experiment.modelName}
            </li>
          ))}
        </ul>
      )}

      <h3>Generations</h3>

      {generationsQuery.isPending && experimentId && (
        <p>Loading generations...</p>
      )}

      {generationsQuery.isError && (
        <p>
          Failed to load generations:{" "}
          {generationsQuery.error.message}
        </p>
      )}

      {generationsQuery.data && (
        <ul>
          {generationsQuery.data.map((generation) => (
            <li key={generation.generationId}>
              {generation.generationId}
              {" — "}
              {generation.status}
              {" — "}
              {generation.committedCandidateCount}/
              {generation.candidateCount} committed
            </li>
          ))}
        </ul>
      )}

      <h3>Candidates</h3>

      {candidatesQuery.isPending && generationId && (
        <p>Loading candidates...</p>
      )}

      {candidatesQuery.isError && (
        <p>
          Failed to load candidates:{" "}
          {candidatesQuery.error.message}
        </p>
      )}

      {candidatesQuery.data && (
        <table>
          <thead>
            <tr>
              <th>Candidate</th>
              <th>Attempt</th>
              <th>Worker</th>
              <th>Status</th>
            </tr>
          </thead>

          <tbody>
            {candidatesQuery.data.map((candidate) => (
              <tr key={candidate.candidateId}>
                <td>{candidate.candidateId}</td>
                <td>{candidate.attemptId}</td>
                <td>{candidate.workerId ?? "-"}</td>
                <td>{candidate.status}</td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
    </section>
  );
}
