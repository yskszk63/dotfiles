local jdtls = require('jdtls')
local mod = require("yskszk63.java")
local keymap = vim.keymap

keymap.set('n', '<A-o>', jdtls.organize_imports, { noremap = true, buffer = true })
keymap.set('n', 'crv', jdtls.extract_variable, { noremap = true, buffer = true })
keymap.set('n', 'crc', jdtls.extract_constant, { noremap = true, buffer = true })
keymap.set('n', 'crm', jdtls.extract_method, { noremap = true, buffer = true })

keymap.set('n', '<LEADER>df', mod.test_class_with_dotenv, { noremap = true, buffer = true })
keymap.set('n', '<LEADER>dn', mod.test_nearest_method_with_dotenv, { noremap = true, buffer = true })

