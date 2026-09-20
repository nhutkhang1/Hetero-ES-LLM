import type { Worker } from "../../types/worker";

export const mockWorkers: Worker[] = [
  {
    workerId: "worker-01",
    status: "ONLINE",
    admissionStatus: "ADMITTED",
    admissionReason: "Worker satisfies profiling requirements.",
    profile: {
      gpuName: "NVIDIA GeForce RTX 5070 Ti",
      vramTotalMb: 16384,
      vramFreeMb: 12288,
      throughputTokensPerSecond: 118,
      safeChunkSize: 8,
    },
    lastHeartbeatAt: "2026-09-20T09:30:00Z",
  },
  {
    workerId: "worker-02",
    status: "ONLINE",
    admissionStatus: "ADMITTED_LIMITED",
    admissionReason: "Worker admitted with reduced workload size.",
    profile: {
      gpuName: "NVIDIA GeForce GTX 1660 SUPER",
      vramTotalMb: 6144,
      vramFreeMb: 4096,
      throughputTokensPerSecond: 42,
      safeChunkSize: 2,
    },
    lastHeartbeatAt: "2026-09-20T09:30:02Z",
  },
];
