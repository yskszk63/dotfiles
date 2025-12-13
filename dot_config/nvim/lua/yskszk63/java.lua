local M = {}

local dir = vim.fn.fnamemodify(
  debug.getinfo(1, "S").source:sub(2),
  ":p:h"
)

local extra_dir = vim.fn.stdpath('data') .. '/my-jdtls-extra'
local bindings_dir = extra_dir .. "/bindings"

local function download_java_debug()
  local outputdir = bindings_dir .. "/java_debug"
  if vim.fn.isdirectory(outputdir) == 1 then
    return
  end

  vim.notify("Downloading vscode-java-debug ...")

  vim.fn.mkdir(bindings_dir, "p")

  local zip = bindings_dir .. "/java_debug.zip"
  -- https://open-vsx.org/extension/vscjava/vscode-java-debug
  local url = "https://open-vsx.org/api/vscjava/vscode-java-debug/0.58.3/file/vscjava.vscode-java-debug-0.58.3.vsix"
  local curl_cmd = {
    "curl",
    "-LsSf",
    url,
    "-o",
    zip,
  }
  if vim.system(curl_cmd):wait().code ~= 0 then
    vim.notify("Failed to download java-debug.")
    return
  end

  local unzip_cmd = {
    "unzip",
    "-qn",
    zip,
    "-d",
    outputdir,
    "extension/server/*.jar",
  }
  if vim.system(unzip_cmd):wait().code ~= 0 then
    vim.notify("Failed to unzip java-debug.")
    return
  end
end

local function download_java_test()
  local outputdir = bindings_dir .. "/java_test"
  if vim.fn.isdirectory(outputdir) == 1 then
    return
  end

  vim.notify("Downloading vscode-java-test ...")

  vim.fn.mkdir(bindings_dir, "p")

  local zip = bindings_dir .. "/java_test.zip"
  -- https://open-vsx.org/extension/vscjava/vscode-java-test
  local url = "https://open-vsx.org/api/vscjava/vscode-java-test/0.43.2/file/vscjava.vscode-java-test-0.43.2.vsix"
  local curl_cmd = {
    "curl",
    "-LsSf",
    url,
    "-o",
    zip,
  }
  if vim.system(curl_cmd):wait().code ~= 0 then
    vim.notify("Failed to download java-test.")
    return
  end

  local unzip_cmd = {
    "unzip",
    "-qn",
    zip,
    "-d",
    outputdir,
    "extension/server/*.jar",
    "-x",
    "extension/server/com.microsoft.java.test.runner-jar-with-dependencies.jar",
    "extension/server/jacocoagent.jar",
  }
  if vim.system(unzip_cmd):wait().code ~= 0 then
    vim.notify("Failed to unzip java-test.")
    return
  end
end

---@param file string
---@return boolean
function M.check_lombok(file)
  local bin = dir .. "/check-lombok.ts"
  local result = vim.system({bin, file}):wait()
  return result.code == 0
end

-- GET lombok.jar
---@return string?
function M.get_lombok()
  local path = extra_dir .. "/lombok.jar"
  if vim.fn.filereadable(path) == 1 then
    return path
  end

  vim.notify("Downloading lombok ...")

  -- https://projectlombok.org/all-versions
  local url = "https://projectlombok.org/downloads/lombok-1.18.42.jar"
  local cmd = {
    "curl",
    "-LsSf",
    url,
    "-o",
    path,
  }
  local result = vim.system(cmd):wait()
  if result.code ~= 0 then
    vim.notify("Failed to download lombok.")
    return nil
  end
  return path
end

---@return string[]
function M.get_jdtls_bindings()
  download_java_debug()
  download_java_test()
  return vim.split(vim.fn.glob(bindings_dir .. "/*/extension/server/*.jar", true), "\n")
end

return M
