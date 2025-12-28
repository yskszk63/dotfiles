return {
  "sainnhe/sonokai",
  lazy = false,
  priority = 1000,
  config = function()
    --vim.g.sonokai_style = 'andromeda'
    vim.g.sonokai_style = "default"
    vim.g.sonokai_enable_italic = 1
    vim.g.sonokai_transparent_background = 1
    vim.g.sonokai_diagnostic_text_highlight = 1
    vim.g.sonokai_diagnostic_line_highlight = 1
    vim.g.sonokai_diagnostic_virtual_text = "colored"
    vim.g.sonokai_menu_selection_background = "green"

    vim.cmd.colorscheme("sonokai")
  end,
}
