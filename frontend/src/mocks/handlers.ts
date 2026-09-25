import { http, HttpResponse } from "msw";
import { mockCandidates } from "./data/candidates";
import { mockExperiments } from "./data/experiments";
import { mockGenerations } from "./data/generations";
import { mockWorkers } from "./data/workers";

export const handlers = [
  http.get("/api/v1/workers", () => {
    return HttpResponse.json(mockWorkers);
  }),

  http.get("/api/v1/experiments", () => {
    return HttpResponse.json(mockExperiments);
  }),

  http.get(
    "/api/v1/experiments/:experimentId/generations",
    ({ params }) => {
      const generations = mockGenerations.filter(
        (generation) => generation.experimentId === params.experimentId,
      );

      return HttpResponse.json(generations);
    },
  ),

  http.get(
    "/api/v1/generations/:generationId/candidates",
    ({ params }) => {
      const candidates = mockCandidates.filter(
        (candidate) => candidate.generationId === params.generationId,
      );

      return HttpResponse.json(candidates);
    },
  ),
http.get("/api/v1/workers/:workerId", ({ params }) => {
  const worker = mockWorkers.find(
    (item) => item.workerId === params.workerId,
  );

  if (!worker) {
    return HttpResponse.json(
      { message: "Worker not found" },
      { status: 404 },
    );
  }

  return HttpResponse.json(worker);
}),
http.get("/api/v1/experiments/:experimentId", ({ params }) => {
  const experiment = mockExperiments.find(
    (item) => item.experimentId === params.experimentId,
  );

  if (!experiment) {
    return HttpResponse.json(
      { message: "Experiment not found" },
      { status: 404 },
    );
  }

  return HttpResponse.json(experiment);
}),
];

