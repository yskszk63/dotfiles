local mod = require("yskszk63.java")

-- https://github.com/neovim/nvim-lspconfig/blob/9c923997123ff9071198ea3b594d4c1931fab169/lsp/jdtls.lua#L35-L41
local function get_jdtls_cache_dir()
  return vim.fn.stdpath('cache') .. '/jdtls'
end

local function get_jdtls_workspace_dir()
  return get_jdtls_cache_dir() .. '/workspace'
end

local bundles = mod.get_jdtls_bindings()

---@type vim.lsp.Config
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

      -- -- https://github.com/redhat-developer/vscode-java/blob/c6f1f3a190bc4868927f837dacd683672905d9ce/src/javaServerStarter.ts#L120
      -- '--jvm-arg=--add-opens',
      -- '--jvm-arg=jdk.compiler/com.sun.tools.javac.main=ALL-UNNAMED',
      -- '--jvm-arg=--add-opens',
      -- '--jvm-arg=jdk.compiler/com.sun.tools.javac.util=ALL-UNNAMED',
      -- '--jvm-arg=--add-opens',
      -- '--jvm-arg=jdk.compiler/com.sun.tools.javac.tree=ALL-UNNAMED',
      -- '--jvm-arg=--add-opens',
      -- '--jvm-arg=jdk.compiler/com.sun.tools.javac.api=ALL-UNNAMED',
      -- '--jvm-arg=--add-opens',
      -- '--jvm-arg=jdk.compiler/com.sun.tools.javac.file=ALL-UNNAMED',
      -- '--jvm-arg=--add-opens',
      -- '--jvm-arg=jdk.compiler/com.sun.tools.javac.parser=ALL-UNNAMED',
      -- '--jvm-arg=--add-opens',
      -- '--jvm-arg=jdk.compiler/com.sun.tools.javac.comp=ALL-UNNAMED',
      -- '--jvm-arg=--add-opens',
      -- '--jvm-arg=jdk.compiler/com.sun.tools.javac.code=ALL-UNNAMED',
      -- '--jvm-arg=--add-opens',
      -- '--jvm-arg=jdk.javadoc/jdk.javadoc.internal.doclets.formats.html.taglets.snippet=ALL-UNNAMED',
      -- '--jvm-arg=--add-opens',
      -- '--jvm-arg=jdk.javadoc/jdk.javadoc.internal.doclets.formats.html.taglets=ALL-UNNAMED',
      -- '--jvm-arg=--add-opens',
      -- '--jvm-arg=jdk.compiler/com.sun.tools.javac.processing=ALL-UNNAMED',
      -- '--jvm-arg=--add-opens',
      -- '--jvm-arg=jdk.compiler/com.sun.tools.javac.jvm=ALL-UNNAMED',
      -- '--jvm-arg=--add-opens',
      -- '--jvm-arg=jdk.compiler/com.sun.tools.javac.model=ALL-UNNAMED',
      -- '--jvm-arg=--add-opens',
      -- '--jvm-arg=jdk.compiler/com.sun.tools.javac.platform=ALL-UNNAMED',
      -- '--jvm-arg=--add-opens',
      -- '--jvm-arg=jdk.compiler/com.sun.tools.javac.resources=ALL-UNNAMED',
      -- '--jvm-arg=--add-opens',
      -- '--jvm-arg=java.base/sun.nio.ch=ALL-UNNAMED',
      -- '--jvm-arg=--add-opens',
      -- '--jvm-arg=jdk.zipfs/jdk.nio.zipfs=ALL-UNNAMED',
      -- '--jvm-arg=--add-opens',
      -- '--jvm-arg=java.compiler/javax.tools=ALL-UNNAMED',
      -- '--jvm-arg=--add-opens',
      -- '--jvm-arg=java.base/java.nio.channels=ALL-UNNAMED',
      -- '--jvm-arg=-DICompilationUnitResolver=org.eclipse.jdt.core.dom.JavacCompilationUnitResolver',
      -- '--jvm-arg=-DAbstractImageBuilder.compilerFactory=org.eclipse.jdt.internal.javac.JavacCompilerFactory',
      -- '--jvm-arg=-DCompilationUnit.DOM_BASED_OPERATIONS=true',
      -- '--jvm-arg=-DSourceIndexer.DOM_BASED_INDEXER=true',
      -- '--jvm-arg=-DMatchLocator.DOM_BASED_MATCH=true',
      -- '--jvm-arg=-DIJavaSearchDelegate=org.eclipse.jdt.internal.core.search.DOMJavaSearchDelegate',
      -- -- https://github.com/redhat-developer/vscode-java/blob/c6f1f3a190bc4868927f837dacd683672905d9ce/src/javaServerStarter.ts#L170
      -- '--jvm-arg=-DCompilationUnit.codeComplete.DOM_BASED_OPERATIONS=true',
    }

    if config.root_dir ~= nil and mod.check_lombok(config.root_dir .. "/pom.xml") then
      local lombokjar = mod.get_lombok()
      if lombokjar ~= nil then
        table.insert(config_cmd, "--jvm-arg=-javaagent:" .. lombokjar)
      end
    end

    return vim.lsp.rpc.start(config_cmd, dispatchers, {
      cwd = config.cmd_cwd,
      env = config.cmd_env,
      detached = config.detached,
    })
  end,

  init_options = {
    bundles = bundles,
  },

  before_init = function (_, config)
    require('codesettings').with_local_settings(config.name, config)

    local root_dir = config.root_dir
    if root_dir == nil then
      root_dir = vim.fn.getcwd()
    end

    config.settings = vim.tbl_extend("force", config.settings, {
      java = {
        configuration = {
          runtimes = mod.load_runtimes(root_dir),
        },
      },
    })
  end
}
