#!/usr/bin/env -S deno run --quiet --no-prompt --allow-read

import * as z from "jsr:@zod/zod@4/mini";
import * as dotenv from "jsr:@std/dotenv@0.225.5";

const zConfig = z.looseObject({
  name: z.optional(z.string()),
  envFile: z.optional(z.string()),
  env: z.optional(z.record(z.string(), z.string())),
});

type Config = z.infer<typeof zConfig>;

const zSettings = z.object({
  "java.test.defaultConfig": z.optional(z.string()),
  "java.test.config": z.optional(z.union([zConfig, z.array(zConfig)])),
});

async function tryReadTextFile(path: string): Promise<string | null> {
  try {
    return await Deno.readTextFile(path);
  } catch (e) {
    if ((e as { code?: unknown })["code"] !== "ENOENT") {
      throw e;
    }
    return null;
  }
}

function tryParseJson(text: string): unknown | null {
  try {
    return JSON.parse(text);
  } catch (e) {
    if (!(e instanceof SyntaxError)) {
      throw e;
    }
    return null;
  }
}

function isSingle<T>(items: T[]): items is [T] {
  return items.length === 1;
}

function select(configs: Config[], defaultConfig: string): Config | null {
  if (configs.length === 0) {
    return null;
  }

  if (isSingle(configs)) {
    return configs[0];
  }

  return configs.find((c) => c.name === defaultConfig) ?? configs[0] ?? null;
}

async function expandEnvFile(config: Config, root: string): Promise<void> {
  if (typeof config.envFile === "undefined") {
    return;
  }

  const envFile = config.envFile.replace("${workspaceFolder}", root);
  const content = await Deno.readTextFile(envFile);
  const env = dotenv.parse(content);

  if (typeof config.env === "undefined") {
    config.env = env;
    return;
  }

  config.env = Object.assign(env, config.env);
  delete config.envFile;
}

async function main(): Promise<void> {
  const [target, root] = Deno.args;
  if (typeof target === "undefined" || typeof root === "undefined") {
    throw new Error("Usage: %prog [target] [root]");
  }

  const raw = await tryReadTextFile(target);
  if (raw === null) {
    Deno.exit(-1);
  }
  const json = tryParseJson(raw);
  if (json === null) {
    Deno.exit(-1);
  }

  const result = zSettings.safeParse(json);
  if (!result.success) {
    Deno.exit(-1);
  }

  const maybeConfig = result.data["java.test.config"];
  if (typeof maybeConfig === "undefined") {
    Deno.exit(-1);
  }

  const configs = Array.isArray(maybeConfig) ? maybeConfig : [maybeConfig];
  const config = select(configs, result.data["java.test.defaultConfig"] ?? "default");
  if (config === null) {
    Deno.exit(-1);
  }

  await expandEnvFile(config, root);

  Deno.stdout.write(new TextEncoder().encode(JSON.stringify(config)));
}

await main();
