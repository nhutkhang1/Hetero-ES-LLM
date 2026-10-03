import { useQuery } from "@tanstack/react-query";
import { getCandidate } from "../api/candidates";

export function useCandidate(candidateId: string) {
  return useQuery({
    queryKey: ["candidate", candidateId],
    queryFn: () => getCandidate(candidateId),
    enabled: Boolean(candidateId),
    retry: false,
  });
}
