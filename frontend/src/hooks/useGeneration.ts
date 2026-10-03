import { useQuery } from "@tanstack/react-query";

import { getGeneration } from "../api/generations";

export function useGeneration(
  experimentId: string,
  generationId: string,
) {
  return useQuery({
    queryKey: ["generation", experimentId, generationId],
    queryFn: () => getGeneration(experimentId, generationId),
    enabled: Boolean(experimentId && generationId),
    retry: false,
  });
}
