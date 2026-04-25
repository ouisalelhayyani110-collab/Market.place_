import { defineConfig } from "cypress";

export default defineConfig({
  e2e: {
    setupNodeEvents(on, config) {},
    allowCypressEnv: false,
    baseUrl: process.env.CYPRESS_BASE_URL || "http://localhost:3000"
  },
  component: {
    devServer: {
      framework: "next",
      bundler: "webpack",
    },
  },
});