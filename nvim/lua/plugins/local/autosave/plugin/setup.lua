if not vim.g.vscode then
  vim.cmd [[ autocmd FocusLost * nested silent! w ]]
end
