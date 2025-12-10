local jdtls = require('jdtls')
local keymap = vim.keymap

keymap.set('n', '<A-o>', jdtls.organize_imports, { noremap = true, buffer = true })
keymap.set('n', 'crv', jdtls.extract_variable, { noremap = true, buffer = true })
keymap.set('n', 'crc', jdtls.extract_constant, { noremap = true, buffer = true })
keymap.set('n', 'crm', jdtls.extract_method, { noremap = true, buffer = true })

--keymap.set('n', '<LEADER>df', jdtls.test_class, { noremap = true, buffer = true })
--keymap.set('n', '<LEADER>dn', jdtls.test_nearest_method, { noremap = true, buffer = true })

local bufnr = vim.api.nvim_get_current_buf()
vim.api.nvim_buf_create_user_command(bufnr, 'JdtTestClass', jdtls.test_class, {})
vim.api.nvim_buf_create_user_command(bufnr, 'JdtTestNearestMethod', jdtls.test_nearest_method, {})

-----

---@param root_dir string
---@return table
local load_settings_json = function(root_dir)
  local settingsjson = root_dir .. "/.vscode/settings.json"
  local ok, lines = pcall(vim.fn.readfile, settingsjson)
  if not ok then
    return {}
  end
  local ok2, settings = pcall(vim.fn.json_decode, table.concat(lines, "\n"))
  if not ok2 then
    vim.notify("failed to parse json: " .. settingsjson)
    return {}
  end

  if type(settings) ~= "table" then
    vim.notify("failed to parse json: " .. settingsjson)
    return {}
  end

  local config = settings["java.test.config"]
  if config == nil or type(config) ~= "table" then
    return {}
  end

  -- if it is array
  -- FIXME current first item only
  local maybeHead = config[1]
  if maybeHead ~= nil and type(maybeHead) == "table" then
    return maybeHead
  end

  return config
end

---@param config table
---@param root_dir string
local expand_envfile = function (config, root_dir)
  if type(config["envFile"]) ~= "string" then
    return
  end

  local envfile = config["envFile"]:gsub("%$%{workspaceFolder%}", root_dir)

  local result = vim.system({
    "deno",
    "eval",
    "--env-file=" .. envfile,
    "console.log(JSON.stringify(Deno.env.toObject()))",
  }, {
    env = {},
    clear_env = true,
    text = true,
  }):wait()

  local ok, env = pcall(vim.fn.json_decode, result.stdout)
  if not ok then
    vim.notify("failed to parse envFile: " .. envfile)
    return
  end

  if type(config["env"]) == "table" then
    -- FIXME `key found in more than one map:`
    config["env"] = vim.tbl_extend("error", env, config["env"])
  end
  if config["env"] == nil then
    config["env"] = env
  end
end

---@return table
local load_config_from_settingsjson = function ()
  local client = vim.lsp.get_clients({ name = "jdtls", bufnr = 0 })[1]
  if not client or client.config.root_dir == nil then
    return {}
  end
  local root_dir = client.config.root_dir
  if type(root_dir) ~= "string" then
    return {}
  end

  local config = load_settings_json(root_dir)
  expand_envfile(config, root_dir)

  return config
end

-- Like vscode-java-test
local test_class_with_dotenv = function()
  local config = load_config_from_settingsjson()
  jdtls.test_class({ config_overrides = config })
end

-- Like vscode-java-test
local test_nearest_method_with_dotenv = function ()
  local config = load_config_from_settingsjson()
  jdtls.test_nearest_method({ config_overrides = config })
end

vim.api.nvim_buf_create_user_command(bufnr, "JdtTestClassWithDotenv", test_class_with_dotenv, {})
vim.api.nvim_buf_create_user_command(bufnr, "JdtTestNearestMethodWithDotenv", test_nearest_method_with_dotenv, {})

keymap.set('n', '<LEADER>df', test_class_with_dotenv, { noremap = true, buffer = true })
keymap.set('n', '<LEADER>dn', test_nearest_method_with_dotenv, { noremap = true, buffer = true })

