import type { Experiment } from "../../types/experiment";

export const mockExperiments: Experiment[] = [
  {
    experimentId: "exp-001",
    name: "Qwen Countdown Baseline",
    status: "RUNNING",
    modelName: "Qwen2.5-0.5B-Instruct",
    modelVersion: "model-v1",
    schedulerPolicy: "B3_GREEDY_DYNAMIC",
    syncMode: "FULL_SYNC_EVERY_GENERATION",
    currentGenerationId: "gen-003",
    createdAt: "2026-09-20T08:00:00Z",
    startedAt: "2026-09-20T08:05:00Z",
  },
];
