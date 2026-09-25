import { useQuery } from "@tanstack/react-query";

import { getWorkers } from "../api/workers";

export function useWorkers() {
  return useQuery({
    queryKey: ["workers"],
    queryFn: getWorkers,
  });
}
