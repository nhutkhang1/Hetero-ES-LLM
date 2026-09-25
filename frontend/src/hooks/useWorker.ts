import { useQuery } from "@tanstack/react-query";

import { getWorker } from "../api/workers";

export function useWorker(workerId: string) {
  return useQuery({
    queryKey: ["worker", workerId],
    queryFn: () => getWorker(workerId),
    enabled: Boolean(workerId),
    retry: false,
  });
}
