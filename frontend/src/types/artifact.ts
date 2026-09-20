export type ArtifactType =
  | "CONFIG"
  | "MODEL_MANIFEST"
  | "DATA_MANIFEST"
  | "ENVIRONMENT_MANIFEST"
  | "HARDWARE_MANIFEST"
  | "EVENTS"
  | "CANDIDATES"
  | "WORKERS"
  | "GENERATIONS"
  | "CHECKPOINT"
  | "EVALUATION_OUTPUT";

export interface Artifact {
  artifactId: string;

  experimentId: string;

  type: ArtifactType;
  name: string;

  path: string;

  createdAt: string;

  sizeBytes?: number;
}
