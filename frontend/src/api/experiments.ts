import type { Experiment } from "../types/experiment";
import { apiGet } from "./client";

export function getExperiments(): Promise<Experiment[]> {
  return apiGet<Experiment[]>("/api/v1/experiments");
}
