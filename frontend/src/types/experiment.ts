export type SchedulerPolicy =
  | "B0_FASTEST"
  | "B1_STATIC_WAVE"
  | "B2_STATIC_PROPORTIONAL"
  | "B3_GREEDY_DYNAMIC"
  | "H0_FULL_SYSTEM";

export type SyncMode =
  | "FULL_SYNC_EVERY_GENERATION"
  | "REPLAY_ONLY"
  | "REPLAY_WITH_PERIODIC_RESYNC";

export interface Experiment {
  experimentId: string;
  name: string;

  status: string;

  modelName: string;
  modelVersion: string;

  schedulerPolicy: SchedulerPolicy;
  syncMode: SyncMode;

  currentGenerationId?: string;

  createdAt: string;
  startedAt?: string;
  completedAt?: string;
}
