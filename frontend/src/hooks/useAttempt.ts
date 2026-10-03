import { useQuery } from "@tanstack/react-query";
import { getAttempt } from "../api/attempts";

export function useAttempt(
  attemptId: string,
  enabled: boolean,
) {
  return useQuery({
    queryKey: ["attempt", attemptId],
    queryFn: () => getAttempt(attemptId),
    enabled: Boolean(attemptId) && enabled,
    retry: false,
  });
}
