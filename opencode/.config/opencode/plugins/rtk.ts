import { execFile } from "node:child_process"
import type { Plugin } from "@opencode/plugin"

// Keep rewrite rules in the RTK binary; this plugin only adapts OpenCode's shell tool.
const REWRITE_TIMEOUT_MS = 2_000
const MAX_REWRITE_OUTPUT_BYTES = 64 * 1024

function hasRtk(): Promise<boolean> {
  return new Promise((resolve) => {
    execFile("rtk", ["--version"], { timeout: REWRITE_TIMEOUT_MS }, (error) => resolve(!error))
  })
}

function rewrite(command: string, workdir?: string): Promise<string | undefined> {
  return new Promise((resolve) => {
    execFile(
      "rtk",
      ["rewrite", command],
      {
        cwd: workdir,
        encoding: "utf8",
        maxBuffer: MAX_REWRITE_OUTPUT_BYTES,
        timeout: REWRITE_TIMEOUT_MS,
      },
      (error, stdout) => {
        // RTK uses exit 3 for a valid rewrite that requires host-side permission handling.
        if (error && error.code !== 3) {
          resolve(undefined)
          return
        }

        const rewritten = stdout.replace(/\r?\n$/, "")
        resolve(rewritten && rewritten !== command ? rewritten : undefined)
      },
    )
  })
}

export default {
  id: "rtk",
  async setup(ctx) {
    if (!(await hasRtk())) {
      console.warn("[rtk] rtk binary not found in PATH — plugin disabled")
      return
    }

    await ctx.tool.hook("execute.before", async (event) => {
      if (event.tool !== "shell") return

      const input = event.input
      if (typeof input !== "object" || input === null || Array.isArray(input)) return

      const args = input as Record<string, unknown>
      const command = args.command
      if (typeof command !== "string" || command.length === 0) return

      const workdir = typeof args.workdir === "string" && args.workdir ? args.workdir : undefined
      const rewritten = await rewrite(command, workdir)

      if (rewritten) event.input = { ...args, command: rewritten }
    })
  },
} satisfies Plugin.Plugin
