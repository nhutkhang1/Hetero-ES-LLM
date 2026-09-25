import type { Generation } from "../../types/generation";

export const mockGenerations: Generation[] = [
  {
    experimentId: "exp-001",
    generationId: "gen-001",
    modelVersion: "model-v1",
    status: "COMPLETED",
    candidateCount: 16,
    committedCandidateCount: 16,
    rewardMean: 0.42,
    rewardBest: 0.67,
    startedAt: "2026-09-20T08:05:00Z",
    completedAt: "2026-09-20T08:12:00Z",
  },
  {
    experimentId: "exp-001",
    generationId: "gen-003",
    modelVersion: "model-v3",
    status: "RUNNING",
    candidateCount: 16,
    committedCandidateCount: 11,
    rewardMean: 0.56,
    rewardBest: 0.74,
    startedAt: "2026-09-20T08:25:00Z",
  },
];
