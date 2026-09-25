import type { Candidate } from "../types/candidate";
import { apiGet } from "./client";

export function getCandidates(
  generationId: string,
): Promise<Candidate[]> {
  return apiGet<Candidate[]>(
    `/api/v1/generations/${generationId}/candidates`,
  );
}
