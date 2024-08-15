local maputil = require 'util.map'
local map = maputil.map

-- Disable C-z suspend
map('nvo', '<C-z>', '<Nop>')
map('nvo', '<C-\\>', '<Nop>')

-- Disable arrow keys
map('nvo', '<Up>', '<Nop>')
map('nvo', '<Down>', '<Nop>')
map('nvo', '<Left>', '<Nop>')
map('nvo', '<Right>', '<Nop>')

-- Center half page
map('nvo', '<C-d>', '<C-d>zz')
map('nvo', '<C-u>', '<C-u>zz')

-- Center search
map('nvo', 'n', 'nzzzv')
map('nvo', 'N', 'Nzzzv')
