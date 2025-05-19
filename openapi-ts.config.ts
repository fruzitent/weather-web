import { defineConfig } from "@hey-api/openapi-ts";

export default defineConfig({
  input: "./src/lib/openapi/openapi.yml",
  output: "./src/lib/openapi_gen/",
  plugins: [
    "@hey-api/client-fetch",
    { name: "@hey-api/sdk", validator: true },
    { name: "@hey-api/transformers", dates: true },
    "zod",
  ],
});
