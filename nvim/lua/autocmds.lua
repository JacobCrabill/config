-- Autocommand group for auto-formatters
vim.api.nvim_create_augroup('AutoFmt', {})

vim.g.fmt_enable_exclusions = true

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
