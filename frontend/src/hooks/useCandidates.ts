import { useQuery } from "@tanstack/react-query";

import { getCandidates } from "../api/candidates";

export function useCandidates(generationId: string) {
  return useQuery({
    queryKey: ["candidates", generationId],
    queryFn: () => getCandidates(generationId),
    enabled: Boolean(generationId),
  });
}
