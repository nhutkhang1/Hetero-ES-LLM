export type AdmissionStatus =
  | "INELIGIBLE"
  | "ELIGIBLE_BUT_NOT_BENEFICIAL"
  | "ADMITTED_LIMITED"
  | "ADMITTED";

export interface WorkerProfile {
  gpuName: string;
  vramTotalMb: number;
  vramFreeMb?: number;

  throughputTokensPerSecond?: number;
  safeChunkSize?: number;
}

export interface Worker {
  workerId: string;

  status: string;
  admissionStatus: AdmissionStatus;
  admissionReason?: string;

  profile: WorkerProfile;

  lastHeartbeatAt?: string;
}
