import { subscribe, type Subscription } from "$lib/openapi_gen";
import type { Actions } from "./$types";

export const actions = {
  default: async ({ request }) => {
    const form = await request.formData()
    const { } = await subscribe({
      body: {
        city: form.get("city") as string,
        email: form.get("email") as string,
        frequency: form.get("frequency") as Subscription["frequency"],
      },
    });
    return { success: true }
  }
} satisfies Actions
