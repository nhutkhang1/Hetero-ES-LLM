import { useQuery } from "@tanstack/react-query";

import { getGenerations } from "../api/generations";

export function useGenerations(experimentId: string) {
  return useQuery({
    queryKey: ["generations", experimentId],
    queryFn: () => getGenerations(experimentId),
    enabled: Boolean(experimentId),
  });
}
