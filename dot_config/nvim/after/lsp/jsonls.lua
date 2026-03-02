--@type vim.lsp.Config
return {
  settings = {
    json = {
      schemas = {
          {
            fileMatch = { "package.json" },
            url = "https://json.schemastore.org/package.json",
          },
          {
            fileMatch = { "tsconfig*.json" },
            url = "https://json.schemastore.org/tsconfig.json",
          },
          {
            fileMatch = { "devcontainer.json" },
            url = "https://raw.githubusercontent.com/devcontainers/spec/main/schemas/devContainerFeature.schema.json",
          },
          {
            fileMatch = { "devcontainer.json" },
            url = "https://raw.githubusercontent.com/devcontainers/spec/main/schemas/devContainerFeature.schema.json",
          },
          {
            fileMatch = { "devcontainer-feature.json" },
            url = "https://raw.githubusercontent.com/devcontainers/spec/refs/heads/main/schemas/devContainerFeature.schema.json",
          },
      }
    }
  },
}
