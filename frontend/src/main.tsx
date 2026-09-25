import { StrictMode } from "react";
import { createRoot } from "react-dom/client";
import { BrowserRouter } from "react-router";
import { AppProviders } from "./app/providers";

import { AppRouter } from "./app/router";
import "./index.css";

async function enableMocking() {
  if (!import.meta.env.DEV) {
    return;
  }

  const { worker } = await import("./mocks/browser");

  await worker.start({
    onUnhandledRequest: "bypass",
  });
}

enableMocking().then(() => {
  createRoot(document.getElementById("root")!).render(
    <StrictMode>
      <AppProviders>
        <BrowserRouter>
          <AppRouter />
        </BrowserRouter>
      </AppProviders>
    </StrictMode>,
  );
});
