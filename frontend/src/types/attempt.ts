export interface Attempt {
  experimentId: string;
  generationId: string;
  candidateId: string;
  attemptId: string;

  workerId: string;
  modelVersion: string;

  leaseToken: string;

  status: string;

  startedAt?: string;
  completedAt?: string;

  errorType?: string;
}
