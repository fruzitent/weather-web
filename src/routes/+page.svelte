<script lang="ts">
  import { env } from "$env/dynamic/public";
  import type { Weather } from "$lib/openapi_gen";
  import { getWeather } from "$lib/openapi_gen";
  import { client as _client } from "$lib/openapi_gen/client.gen";
  import type { PageProps } from "./$types";

  let { form }: PageProps = $props();

  export const client = _client.setConfig({
    baseUrl: env.PUBLIC_API_URL,
  });

  let cityInput = $state<string>("");
  let city = $state<string>("");
  let weather = $state<Weather | undefined>(undefined);

  const handleWeather = async (e: Event) => {
    e.preventDefault();
    city = cityInput;
    const { data, error } = await getWeather({
      query: { city },
    });
    if (error) {
      console.error(error);
      weather = undefined;
      return;
    }
    weather = data;
  };
</script>

<form method="GET" onsubmit={handleWeather}>
  <label>
    City
    <input bind:value={cityInput} placeholder="Anytown" type="text" />
  </label>
  <button type="submit">Submit</button>
</form>

{#if weather}
  <p class="weather">
    <b>{city}</b>: {weather.description}, {weather.temperature}C, {weather.humidity}%
  </p>

  <hr />

  <form method="POST">
    <input value={city} name="city" placeholder="Search City" type="hidden" />
    <label>
      Email
      <input name="email" placeholder="example@example.org" type="email" />
    </label>
    <select name="frequency">
      <option value="hourly">Hourly</option>
      <option value="daily">Daily</option>
    </select>
    <button type="submit">Submit</button>
  </form>
{/if}

{#if form?.success}
  <p class="subscribe">Email sent!</p>
{/if}

<style>
  form {
    display: flex;
    flex-direction: column;
    gap: 1rem;
    margin-bottom: 1rem;
    margin: 0 auto;
    max-width: 1200px;
    min-width: 240px;
    padding: 1rem;
    text-align: center;
  }

  label {
    font-weight: medium;
  }

  input,
  select {
    background: whitesmoke;
    border-radius: 0.3rem;
    border: 1px solid wheat;
    color: black;
    font-size: 1rem;
    padding: 0.4rem 0.6rem;
  }

  button {
    background: mediumslateblue;
    border-radius: 0.3rem;
    border: none;
    color: white;
    cursor: pointer;
    font-size: 1rem;
    padding: 0.5rem 1rem;
  }

  hr {
    border: none;
    border-top: 1px solid wheat;
    margin: 1rem 0 0.7rem 0;
  }

  p {
    font-weight: bold;
    margin-top: 0.7rem;
    text-align: center;
  }

  .subscribe {
    color: greenyellow;
  }

  .weather {
    color: lightblue;
  }
</style>
