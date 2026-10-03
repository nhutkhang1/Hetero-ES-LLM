import { useQuery } from "@tanstack/react-query";
import { getExperiment } from "../api/experiments";

export function useExperiment(experimentId: string) {
  return useQuery({
    queryKey: ["experiment", experimentId],
    queryFn: () => getExperiment(experimentId),
    enabled: Boolean(experimentId),
    retry: false,
  });
}
