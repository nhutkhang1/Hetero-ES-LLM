import { useQuery } from "@tanstack/react-query";

import { getExperiments } from "../api/experiments";

export function useExperiments() {
  return useQuery({
    queryKey: ["experiments"],
    queryFn: getExperiments,
  });
}
