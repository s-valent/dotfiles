function setup_lazy()
    local path = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
    if not vim.loop.fs_stat(path) then
        vim.fn.system({
            'git',
            'clone',
            '--filter=blob:none',
            'https://github.com/folke/lazy.nvim.git',
            '--branch=stable',
            path,
        })
    end
    vim.opt.rtp:prepend(path)
    return path
end

function ls_config(dir)
    local fullpath = vim.fn.stdpath('config') .. '/lua/' .. dir
    local contents = vim.fn.system({'ls', fullpath})
    local get_contents = contents:gmatch("([^\n]*).lua\n")
    function iter()
        local value = get_contents()
        if value then
            return dir .. '/' .. value
        end
        return nil
    end
    return iter
end
