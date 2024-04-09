-- Autocommand group for auto-formatters
vim.api.nvim_create_augroup('AutoFmt', {})
vim.api.nvim_create_augroup('OnOpen', {})
vim.api.nvim_create_augroup('vimrc', {})

vim.g.fmt_enable_exclusions = true
vim.g.autoformat_enabled = true
vim.g.cue_fmt_on_save = true

vim.g["clang_format#detect_style_file"] = 1
vim.g["clang_format#enable_fallback_style"] = 0

-- Reset cursor to last location when opening file (marker '"')
vim.api.nvim_create_autocmd('BufReadpost', {
  pattern = { '*' },
  group = 'OnOpen',
  callback = function()
    vim.api.nvim_command([[if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif]])
  end
})

-- Disable trailing whitespace highligting for Markdown previews
vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
  pattern = { '*.mdp' },
  group = 'OnOpen',
  callback = "DisableWhitespace",
})

-- enable syntax highligting for EOSLang files
vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
  pattern = { '*.eos' },
  group = 'OnOpen',
  callback = function()
    vim.api.nvim_command([[set syntax=eos]])
  end
})

-- C/C++ auto-formatter (Clang-Format)
vim.api.nvim_create_autocmd('BufWritePre', {
  group = 'AutoFmt',
  callback = function()
    if vim.g.autoformat_enabled then
      vim.api.nvim_command([[:StripWhitespace]])
    end
  end
})

-- C/C++ auto-formatter (Clang-Format)
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = { '*.c', '*.cpp', '*.h', '*.hpp' },
  group = 'AutoFmt',
  callback = function()
    if vim.g.autoformat_enabled then
      vim.api.nvim_command([[:ClangFormat]])
    end
  end
})

-- CMake auto-formatter
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = { 'CMakeLists.txt', '*.cmake' },
  group = 'AutoFmt',
  callback = function()
    -- Paths listed here will be excluded from cmake-format
    local exclude_paths = { '/home/jacob/Codes/VBAT', '/home/jacob/Codes/COPY/VBAT' }

    local path = vim.fn.expand('%:p')
    local excluded = false
    if vim.g.fmt_enable_exclusions then
      for _, exclusion in ipairs(exclude_paths) do
        if string.find(path, exclusion, 1) then
          excluded = true
          break
        end
      end
    end

    if vim.g.autoformat_enabled and excluded == false then
      vim.api.nvim_command([[silent write | silent :execute '! cmake-format --in-place %' | edit! %]])
    end
  end
})

-- Enable/Disable auto-formatting of CMake files in specific folders
function ToggleCMakeExclusions()
  vim.g.fmt_enable_exclusions = not vim.g.fmt_enable_exclusions
  vim.api.nvim_command([[ echo printf("CMake-format exclusions enabled set to: %d", g:fmt_enable_exclusions) ]])
end
vim.keymap.set('n', '<Leader>ex', ToggleCMakeExclusions)
vim.api.nvim_create_user_command('CMakeFmtToggleExclude', ToggleCMakeExclusions, {})

-- Markdown auto-formatter
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = { '*.md' },
  group = 'AutoFmt',
  callback = function()
    if vim.g.autoformat_enabled then
      vim.api.nvim_command([[silent write | silent :execute '! mdformat --wrap 100 --end-of-line keep %' | edit! %]])
    end
  end
})

-- Enable/Disable format-on-save for all languages
function DisableAutoFmt()
  vim.g.autoformat_enabled = false
  vim.g.cue_fmt_on_save = false -- CUE Format is handled separately
end
function EnableAutoFmt()
  vim.g.autoformat_enabled = true
  vim.g.cue_fmt_on_save = true
end
vim.api.nvim_create_user_command('DisableAutoFmt', DisableAutoFmt, {})
vim.api.nvim_create_user_command('EnableAutoFmt', EnableAutoFmt, {})

-- Create a new Floaterm on startup, hide it, then setup ctrl+t to toggle it
vim.api.nvim_create_autocmd('VimEnter', {
  pattern = { '*' },
  group = 'vimrc',
  callback = function()
    vim.cmd([[:FloatermKill!]])
    vim.cmd([[:FloatermNew]])
    vim.cmd([[:stopinsert]])
    vim.cmd([[:FloatermHide]])
  end
})
