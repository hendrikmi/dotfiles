local setup, gitsigns = pcall(require, "gitsigns")
if not setup then
	return
end

gitsigns.setup()
