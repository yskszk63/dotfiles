return {
  "vim-skk/skkeleton",
  enabled = vim.fn.executable "deno" == 1,
  dependencies = {
    { 'vim-denops/denops.vim' },
  },
  event = { 'InsertEnter' },
  keys = {
    { "<C-j>", "<Plug>(skkeleton-enable)", mode = { "i", "c" } },
  },
  config = function()
    local skkeleton_init = function()
      vim.fn["skkeleton#config"] {
        acceptIllegalResult = true,
        --usePopup = true,
        eggLikeNewline = true,
        --markerHenkan = "﬍ ",
        --markerHenkanSelect = "ﳳ ",
        globalDictionaries = {
          "/usr/share/skk/SKK-JISYO.L",
        },
      }
    end

    vim.api.nvim_create_augroup("skkeleton-initialize-pre", {})
    vim.api.nvim_create_autocmd("User", {
      pattern = "skkeleton-initialize-pre",
      callback = skkeleton_init,
      group = "skkeleton-initialize-pre",
    })
  end,
}
