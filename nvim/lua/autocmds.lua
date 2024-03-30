-- Autocommand group for auto-formatters
vim.api.nvim_create_augroup('AutoFmt', {})
vim.api.nvim_create_augroup('OnOpen', {})

vim.g.fmt_enable_exclusions = true

-- Reset cursor to last location when opening file (marker '"')
vim.api.nvim_create_autocmd('BufReadpost', {
  pattern = { '*' },
  group = 'OnOpen',
  callback = [[if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif]],
})

-- Disable trailing whitespace highligting for Markdown previews
vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
  pattern = { '*.mdp' },
  group = 'OnOpen',
  callback = "DisableWhitespace",
})

-- enable syntax highligting for EOSLang files
vim.api.nvim_create_autocmd({'BufNewFile', 'BufNewFile'}, {
  pattern = { '*.eos' },
  group = 'OnOpen',
  callback = "set syntax=eos",
})


-- C/C++ auto-formatter (Clang-Format)
vim.api.nvim_create_autocmd('BufWritePre', {
  group = 'AutoFmt',
  callback = "StripWhitespace",
})

-- C/C++ auto-formatter (Clang-Format)
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = { '*.c', '*.cpp', '*.h', '*.hpp' },
  group = 'AutoFmt',
  callback = function()
    vim.api.nvim_command([[:ClangFormat]])
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

    if excluded == false then
      vim.api.nvim_command([[silent write | silent :execute '! cmake-format --in-place %' | edit! %]])
    end
  end
})

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
    vim.api.nvim_command([[silent write | silent :execute '! mdformat --wrap 100 --end-of-line keep %' | edit! %]])
  end
})
