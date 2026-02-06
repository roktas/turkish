local Turkish = {}

local group = vim.api.nvim_create_augroup("Turkish", { clear = true })

Turkish.setup = function(options)
  Turkish.use(options)
end

Turkish.use = function(options)
  if options.abbreviate then
    vim.api.nvim_create_autocmd( "FileType", {
      pattern  = options.abbreviate,
      callback = function () Turkish.use_abbreviations() end,
      group    = group,
    })
  end

  if options.map then
    Turkish.use_mappings()
  end
end

Turkish.defaults = function()
  Turkish.use({ abbreviate = { "markdown", "text", "tex" }, map = true })
end

local function load_data()
  local info = debug.getinfo(1, "S")
  local source = info.source:sub(2)
  local plugin_root = vim.fn.fnamemodify(source, ":h:h")
  local data_file = plugin_root .. "/data/abbreviations.lua"

  -- Check if file exists to prevent errors
  if vim.fn.filereadable(data_file) == 1 then
    return dofile(data_file)
  else
    vim.notify("turkish.nvim: Abbreviation data file not found at " .. data_file, vim.log.levels.WARN)
    return {}
  end
end

local abbreviations = load_data()

Turkish.use_abbreviations = function()
  for _, pair in ipairs(abbreviations) do
    vim.cmd.iabbrev(pair)
  end
end

local mappings = {
  { 'n', '<Char-305>', '@q',                                                   },  -- ı → Dotless i: execute content of register 'q' (useful for macro recordings)

  { 'n', '<Char-252>', ']'                                                     },  -- ü → udiaeresis: ]
  { 'v', '<Char-252>', ']'                                                     },  -- ü → udiaeresis: ]
  { 'n', '<Char-220>', '}'                                                     },  -- Ü → Udiaeresis: }
  { 'v', '<Char-220>', '}'                                                     },  -- Ü → Udiaeresis: }

  { 'n', '<Char-246>', '<c-]>'                                                 },  -- ö → odiaeresis: <c-]>
  { 'n', '<Char-214>', '<Nop>'                                                 },  -- Ö → Odiaeresis: <Nop>

  { '',  '<Char-231>', '<Leader>'                                              },  -- ç → ccedilla: <Leader>
  { '',  '<Char-199>', '<LocalLeader>'                                         },  -- Ç → Ccedilla: <LocalLeader>

  { 'n', '<Char-287>', '['                                                     },  -- ğ → gbreve: [
  { 'v', '<Char-287>', '['                                                     },  -- ğ → gbreve: [
  { 'n', '<Char-286>', '{'                                                     },  -- Ğ → Gbreve {
  { 'v', '<Char-286>', '{'                                                     },  -- Ğ → Gbreve {

  { 'n', '<Char-351>', ':%s/<c-r>=expand("<cword>")<cr>//gc<left><left><left>' }, -- ş → scedilla: Search/replace word under cursor
  { 'v', '<Char-351>', ':s/<c-r>=expand("<cword>")<cr>//gc<left><left><left>'  }, -- ş → scedilla: Search/replace word under cursor

  { 'n', '<Char-350>', ':%s///gc<left><left><left><left>'                      }, -- Ş → Scedilla: Switch to search/replace prompt
  { 'v', '<Char-350>', ':s///gc<left><left><left><left>'                       }, -- Ş → Scedilla: Switch to search/replace prompt
}

Turkish.use_mappings = function()
  for _, mapping in ipairs(mappings) do
    local mode = mapping[1]
    local lhs  = mapping[2]
    local rhs  = mapping[3]

    -- User has not mapped (a keyseq starting with) `lhs` to something else.
    -- User has not already mapped something to the <Plug> key.
    if vim.fn.mapcheck(lhs, mode) == "" and vim.fn.hasmapto(rhs, mode) == 0 then
      vim.api.nvim_set_keymap(mode, lhs, rhs, {})
    end
  end
end

return Turkish
