-- https://github.com/neovim/nvim-lspconfig/blob/9c923997123ff9071198ea3b594d4c1931fab169/lsp/jdtls.lua#L35-L41
local function get_jdtls_cache_dir()
  return vim.fn.stdpath('cache') .. '/jdtls'
end

local function get_jdtls_workspace_dir()
  return get_jdtls_cache_dir() .. '/workspace'
end

--@type vim.lsp.Config
return {

  -- https://github.com/neovim/nvim-lspconfig/blob/9c923997123ff9071198ea3b594d4c1931fab169/lsp/jdtls.lua#L77-L97
  cmd = function(dispatchers, config)
    local workspace_dir = get_jdtls_workspace_dir()
    local data_dir = workspace_dir

    if config.root_dir then
      data_dir = data_dir .. '/' .. vim.fn.fnamemodify(config.root_dir, ':p:h:t')
    end

    local config_cmd = {
      'jdtls',
      '-data',
      data_dir,
      -- MODIFY
      --get_jdtls_jvm_args(),
      '--java-executable',
      '/usr/bin/java',
      '--jvm-arg=-Djava.import.generatesMetadataFilesAtProjectRoot=false',
    }

    return vim.lsp.rpc.start(config_cmd, dispatchers, {
      cwd = config.cmd_cwd,
      env = config.cmd_env,
      detached = config.detached,
    })
  end,

}
