-- FIXME

--@type vim.lsp.Config
return {
  apex_jar_path = vim.fn.expand("$HOME/.local/bin/apex-jorje-lsp.jar"),
  apex_enable_semantic_errors = false, -- Whether to allow Apex Language Server to surface semantic errors
  apex_enable_completion_statistics = false, -- Whether to allow Apex Language Server to collect telemetry on code completion usage
  filetypes = { "apexcode", "apex" },
}
