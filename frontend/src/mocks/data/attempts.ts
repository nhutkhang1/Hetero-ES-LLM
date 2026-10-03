import type { Attempt } from "../../types/attempt";

export const mockAttempts: Attempt[] = [
  {
    experimentId: "exp-001",
    generationId: "gen-003",
    candidateId: "candidate-001",
    attemptId: "attempt-001",

    workerId: "worker-01",
    modelVersion: "model-v3",

    leaseToken: "lease-001",

    status: "COMPLETED",

    startedAt: "2026-09-20T09:30:00Z",
    completedAt: "2026-09-20T09:32:00Z",
  },

  {
    experimentId: "exp-001",
    generationId: "gen-003",
    candidateId: "candidate-002",
    attemptId: "attempt-002",

    workerId: "worker-02",
    modelVersion: "model-v3",

    leaseToken: "lease-002",

    status: "RUNNING",

    startedAt: "2026-09-20T09:31:00Z",
  },
];
