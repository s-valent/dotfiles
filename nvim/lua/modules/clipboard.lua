local M = {}

function M.setup()
    vim.cmd([[
    function SyncClipboard()
        if v:event.regname == ""
            exec "silent !printf '\\e]52;c;".system("echo -n ".shellescape(@")." \| openssl base64 -A")."\\a'"
            redraw
        endif
    endfunction

    exec "au TextYankPost * call SyncClipboard()"
    ]])
end

return M
