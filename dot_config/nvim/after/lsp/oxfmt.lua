return {
  -- https://github.com/neovim/nvim-lspconfig/blob/bff1bd61cb1455040533201ca1edf1e84efa578f/lsp/oxfmt.lua#L20
  cmd = function(dispatchers, config)
    local cmd = 'oxfmt'
    if (config or {}).root_dir then
      local local_cmd = vim.fs.joinpath(config.root_dir, 'node_modules/.bin', cmd)
      if vim.fn.executable(local_cmd) == 1 then
        cmd = local_cmd
        return vim.lsp.rpc.start({ cmd, '--lsp' }, dispatchers)
      end
    end
    return vim.lsp.rpc.start({ 'bunx', cmd, '--lsp' }, dispatchers)
  end,
}
