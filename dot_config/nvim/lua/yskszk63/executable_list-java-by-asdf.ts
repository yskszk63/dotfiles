#!/usr/bin/env -S deno --no-prompt --quiet --allow-run=asdf --allow-env=HOME

// https://github.com/eclipse-jdtls/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request

type ExecutionEnvironment =
  | "J2SE-1.5"
  | "JavaSE-1.6"
  | "JavaSE-1.7"
  | "JavaSE-1.8"
  | `JavaSE-${number}`

type RuntimeOption = {
  name: ExecutionEnvironment;
  path: string;
  sources?: string | undefined;
  javadoc?: string | undefined;
  default?: boolean | undefined;
};

async function resolvePath(name: string): Promise<string> {
  const { code, stdout } = await new Deno.Command("asdf", {
    args: ["where", "java", name],
    stdin: "null",
    stderr: "inherit",
  }).output();
  if (code !== 0) {
    throw new Error(`Failed to run asdf where java ${name}`);
  }
  return new TextDecoder().decode(stdout);
}

function assumeName(asdfname: string): ExecutionEnvironment | null {
  const [_, m] = /(\d+)\.\d+\.\d+/.exec(asdfname) ?? [];
  switch (m) {
    case "5":
      return "J2SE-1.5";
    case "6":
      return "JavaSE-1.6";
    case "7":
      return "JavaSE-1.7";
    case "8":
      return "JavaSE-1.8";
    default: {
      // inclues undefined
      // FIXME maybe NaN
      const v = Number.parseInt(m);
      return `JavaSE-${v}`;
    }
  }
}

async function tryParse(line: string, resolve: (name: string) => Promise<string>): Promise<RuntimeOption | null> {
  const head = line.slice(0, 2);
  const asdfname = line.slice(2);

  const name = assumeName(asdfname);
  if (name === null) {
    return null;
  }

  let dflt: boolean;
  switch (head) {
    case "  ":
      dflt = false;
      break;

    case " *":
      dflt = true;
      break;

    default:
      return null;
  }

  const path = await resolve(asdfname);
  let sources: string;
  switch (name) {
    case "J2SE-1.5":
    case "JavaSE-1.6":
    case "JavaSE-1.7":
    case "JavaSE-1.8":
      sources = `${path}/src.zip`
      break;
    default:
      sources = `${path}/lib/src.zip`
      break;
  }

  return {
    name,
    path,
    sources,
    default: dflt,
  };
}

async function main() {
  const home = Deno.env.get("HOME");
  if (typeof home === "undefined") {
    throw new Error("No HOME");
  }

  const { code, stdout } = await new Deno.Command("asdf", {
    args: ["list", "java"],
    clearEnv: true,
    env: {
      HOME: home,
    },
    stdin: "null",
    stderr: "inherit",
  }).output();
  if (code !== 0) {
    throw new Error("Failed to execute asdf.");
  }

  const runtimes: Record<string, RuntimeOption> = {};
  const lines = new TextDecoder()
    .decode(stdout)
    .split(/\r?\n/)
    .filter((v, i, array) => v !== "" || i > array.length - 1);
  for (const line of lines) {
    const rt = await tryParse(line, resolvePath);
    if (rt === null) {
      continue;
    }

    runtimes[rt.name] = rt;
  }

  Deno.stdout.write(new TextEncoder().encode(JSON.stringify(Object.values(runtimes))));
}

await main();
