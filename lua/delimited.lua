local api = vim.api
local severity = vim.diagnostic.severity
local M = {}

local function hlgroup(d)
	if d.severity == severity.ERROR then
		return "EphemeralError"
	elseif d.severity == severity.WARN then
		return "EphemeralWarn"
	elseif d.severity == severity.HINT then
		return "EphemeralHint"
	elseif d.severity == severity.INFO then
		return "EphemeralInfo"
	end
end

local function diagnostic_hl(d)
	vim.g.edh_tracker = vim.g.edh_tracker or 0

	local bufnr = api.nvim_get_current_buf()
	local ns = api.nvim_create_namespace("ephemeraldiagnostichighlight")

	local old_edh_tracker = vim.g.edh_tracker

	vim.g.edh_tracker = (vim.g.edh_tracker + 1) % 500

	api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
  vim.cmd [[IBLDisable]]
	vim.highlight.range(bufnr, ns, hlgroup(d), { d.lnum, d.col }, { d.end_lnum, d.end_col })

	return old_edh_tracker
end

local function diagnostic_hl_set_trigger(bufnr, old_tracker, old_cursor)
	local ns = api.nvim_create_namespace("ephemeraldiagnostichighlight")
	api.nvim_create_autocmd({ "CursorMoved" }, {
		callback = function()
			local cursor = api.nvim_win_get_cursor(0)
			if old_cursor[1] == cursor[1] and old_cursor[2] == cursor[2] then
				return
			end
			if vim.g.edh_tracker == (old_tracker + 1) % 500 then
				api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
        vim.cmd [[IBLEnable]]
			end
			return true
		end,
	})
end

function M.goto_next(opts)
	local bufnr = api.nvim_get_current_buf()
	local d = vim.diagnostic.get_next(opts)
	if not d then
		vim.diagnostic.goto_next(opts)
		return
	end
	local old_tracker = diagnostic_hl(d)
	vim.diagnostic.goto_next(opts)
	local old_cursor = api.nvim_win_get_cursor(0)
	diagnostic_hl_set_trigger(bufnr, old_tracker, old_cursor)
end

function M.goto_prev(opts)
	local bufnr = api.nvim_get_current_buf()
	local d = vim.diagnostic.get_prev(opts)
	if not d then
		vim.diagnostic.goto_prev(opts)
		return
	end
	local old_tracker = diagnostic_hl(d)
	vim.diagnostic.goto_prev(opts)
	local old_cursor = api.nvim_win_get_cursor(0)
	diagnostic_hl_set_trigger(bufnr, old_tracker, old_cursor)
end

return M
