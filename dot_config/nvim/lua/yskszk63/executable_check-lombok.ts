#!/usr/bin/env -S deno --no-prompt --quiet --allow-read

import { parse } from "jsr:@libs/xml@7";
import type { ReaderSync } from "jsr:@libs/xml@7";
import * as z from "jsr:@zod/zod@4/mini";

const zDependency = z.object({
  groupId: z.string(),
  artifactId: z.string(),
});

const zProject = z.object({
  project: z.object({
    dependencies: z.optional(z.object({
      dependency: z.union([zDependency, z.array(zDependency)]),
    })),
  }),
});

const [target] = Deno.args;
if (typeof target === "undefined") {
  throw new Error("Usage: prog [target]");
}

async function tryOpen(path: string): Promise<Deno.FsFile | null> {
  try {
    return await Deno.open(path);
  } catch (e) {
    if ((e as { code?: unknown })["code"] !== "ENOENT") {
      throw e;
    }
    return null;
  }
}

function tryParse(file: ReaderSync): ReturnType<typeof parse> | null {
  try {
    return parse(file);
  } catch (e) {
    if (!(e instanceof SyntaxError)) {
      throw e;
    }
    return null;
  }
}

await using pom = await tryOpen(target);
if (pom === null) {
  Deno.exit(1);
}
const doc = tryParse(pom);
if (doc === null) {
  Deno.exit(1);
}
const result = zProject.safeParse(doc);
if (!result.success) {
  Deno.exit(1);
}
const dependency = result.data.project.dependencies?.dependency;
if (typeof dependency === "undefined") {
  Deno.exit(1);
}
for (const dep of Array.isArray(dependency) ? dependency : [dependency]) {
  if (dep.groupId !== "org.projectlombok" && dep.artifactId !== "lombok") {
    continue;
  }
  Deno.exit(0);
}
Deno.exit(1);
