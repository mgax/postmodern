local M = {}

local MONTH = {
  ian = 1, feb = 2, mar = 3, apr = 4, mai = 5, iun = 6,
  iul = 7, aug = 8, sep = 9, oct = 10, nov = 11, dec = 12,
}
local MONTH_REV = {}
for k, v in pairs(MONTH) do MONTH_REV[v] = k end

local function calculate_next_day(year, month, day, unit, count)
  if unit == 'zi' or unit == 'zile' then
    local t = os.time({ year = year, month = month, day = day + count })
    return os.date('*t', t)
  end

  if unit == 'an' or unit == 'ani' then
    unit = 'luni'
    count = count * 12
  end

  if unit == 'lună' or unit == 'luni' then
    local total = (month - 1) + count
    local new_month = total % 12 + 1
    local new_year = year + math.floor(total / 12)
    return { year = new_year, month = new_month, day = day }
  end

  error('Unknown unit: ' .. unit)
end

function M.recur()
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_get_current_buf()
  local row = vim.api.nvim_win_get_cursor(win)[1]
  local col = vim.api.nvim_win_get_cursor(win)[2]
  local line = vim.api.nvim_buf_get_lines(buf, row - 1, row, false)[1]

  local before_date, bracket_open, day_str, month_str, bracket_close, after_date =
    line:match('^(.-)([(%[])(%d+) (%a+)([%)%]])(.+)$')

  if not before_date then
    print('Line does not match (no date found)')
    return
  end

  local recur_count, recur_unit = after_date:match('!recur (%d+) (%S+)$')
  if not recur_count then
    print('Line does not match (no !recur found)')
    return
  end

  local year = os.date('*t').year
  local next = calculate_next_day(year, MONTH[month_str], tonumber(day_str), recur_unit, tonumber(recur_count))

  local next_day_txt = next.day .. ' ' .. MONTH_REV[next.month]
  if next.year ~= year then
    next_day_txt = next_day_txt .. ' ' .. next.year
  end

  local next_line = before_date .. bracket_open .. next_day_txt .. bracket_close .. after_date

  local changed_line = before_date .. bracket_open .. day_str .. ' ' .. month_str .. bracket_close
    .. after_date:gsub('%s*#?%s*!recur %d+ %S+$', '')
  if changed_line:sub(-2) == ' #' then
    changed_line = changed_line:sub(1, -3)
  end

  vim.api.nvim_buf_set_lines(buf, row - 1, row, false, { changed_line, next_line })
  vim.api.nvim_win_set_cursor(win, { row + 1, col })
end

return M
