export interface TimingBreakdown {
  loadMs?: number;
  perturbMs?: number;
  rolloutMs?: number;
  verifierMs?: number;
  restoreMs?: number;
  updateMs?: number;
  transferReloadMs?: number;
  coordinationMs?: number;
}

export interface NetworkMetric {
  bytesSent: number;
  bytesReceived: number;
}

export interface SyncMetric {
  mode: string;

  durationMs?: number;
  bytesTransferred?: number;
}

export interface GenerationMetric {
  experimentId: string;
  generationId: string;

  rewardMean?: number;
  rewardBest?: number;

  tokenCount?: number;
  promptCount?: number;

  timing: TimingBreakdown;
  network?: NetworkMetric;
  sync?: SyncMetric;
}
