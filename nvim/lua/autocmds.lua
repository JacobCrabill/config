-- Autocommand group for auto-formatters
vim.api.nvim_create_augroup('AutoFmt', {})

-- CMake auto-formatter
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = { 'CMakeLists.txt', '*.cmake' },
  group = 'AutoFmt',
  callback = function()
    -- Paths listed here will be excluded from cmake-format
    local exclude_paths = { '/home/jacob/Codes/VBAT' }

    local path = vim.fn.expand('%:p')
    local excluded = false
    for _, exclusion in ipairs(exclude_paths) do
      if string.find(path, exclusion, 1) then
        excluded = true
        break
      end
    end

    if excluded == false then
      vim.api.nvim_command([[silent write | silent :execute '! cmake-format --in-place %' | edit! %]])
    end
  end
})
