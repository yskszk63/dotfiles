local jdtls = require('jdtls')
local keymap = vim.keymap

keymap.set('n', '<A-o>', jdtls.organize_imports, { noremap = true, buffer = true })
keymap.set('n', 'crv', jdtls.extract_variable, { noremap = true, buffer = true })
keymap.set('n', 'crc', jdtls.extract_constant, { noremap = true, buffer = true })
keymap.set('n', 'crm', jdtls.extract_method, { noremap = true, buffer = true })

keymap.set('n', '<LEADER>df', jdtls.test_class, { noremap = true, buffer = true })
keymap.set('n', '<LEADER>dn', jdtls.test_nearest_method, { noremap = true, buffer = true })

local bufnr = vim.api.nvim_get_current_buf()
vim.api.nvim_buf_create_user_command(bufnr, 'JdtTestClass', jdtls.test_class, {})
vim.api.nvim_buf_create_user_command(bufnr, 'JdtTestNearestMethod', jdtls.test_nearest_method, {})
