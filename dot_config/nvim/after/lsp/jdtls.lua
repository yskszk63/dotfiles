-- https://github.com/neovim/nvim-lspconfig/blob/9c923997123ff9071198ea3b594d4c1931fab169/lsp/jdtls.lua#L35-L41
local function get_jdtls_cache_dir()
  return vim.fn.stdpath('cache') .. '/jdtls'
end

local function get_jdtls_workspace_dir()
  return get_jdtls_cache_dir() .. '/workspace'
end

-- download java-debug, vscode-java-test
local extra_dir = vim.fn.stdpath('data') .. '/my-jdtls-extra/'
vim.fn.mkdir(extra_dir, 'p')

local java_debug_url = 'https://open-vsx.org/api/vscjava/vscode-java-debug/0.58.3/file/vscjava.vscode-java-debug-0.58.3.vsix'
local java_test_url = 'https://open-vsx.org/api/vscjava/vscode-java-test/0.43.2/file/vscjava.vscode-java-test-0.43.2.vsix'

if vim.fn.isdirectory(extra_dir .. 'java_debug') == 0 then
  vim.fn.system({ 'curl', '-LsSf', java_debug_url, '-o', extra_dir .. 'java_debug.zip' })
  if vim.v.shell_error ~= 0 then
    vim.notify('Failed to download: ' .. java_debug_url)
    return
  end

  vim.fn.system({ 'unzip', '-qn', extra_dir .. 'java_debug.zip', '-d', extra_dir .. 'java_debug/', 'extension/server/*.jar' })
  if vim.v.shell_error ~= 0 then
    vim.notify('Failed to unzip: ' .. 'java_debug')
    return
  end
end

if vim.fn.isdirectory(extra_dir .. 'java_test') == 0 then
  vim.fn.system({ 'curl', '-LsSf', java_test_url, '-o', extra_dir .. 'java_test.zip' })
  if vim.v.shell_error ~= 0 then
    vim.notify('Failed to download: ' .. java_test_url)
    return
  end

  vim.fn.system({ 'unzip', '-qn', extra_dir .. 'java_test.zip', '-d', extra_dir .. 'java_test/', 'extension/server/*.jar', '-x', 'extension/server/com.microsoft.java.test.runner-jar-with-dependencies.jar', 'extension/server/jacocoagent.jar' })
  if vim.v.shell_error ~= 0 then
    vim.notify('Failed to unzip: ' .. 'java_test')
    return
  end
end

local bundles = vim.split(vim.fn.glob(extra_dir .. '*/extension/server/*.jar', true), '\n')

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

  init_options = {
    bundles = bundles,
  },
}
