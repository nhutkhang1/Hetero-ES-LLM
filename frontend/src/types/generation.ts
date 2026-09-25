export interface Generation {
  experimentId: string;
  generationId: string;

  modelVersion: string;

  status: string;

  candidateCount: number;
  committedCandidateCount: number;

  rewardMean?: number;
  rewardBest?: number;

  startedAt?: string;
  completedAt?: string;
}
