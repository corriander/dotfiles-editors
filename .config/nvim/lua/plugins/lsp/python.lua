local fmap = {}

local find_file = function(filename)
    local opts_d = { stop = vim.loop.cwd(), type = "file" }
    local opts_u = vim.tbl_extend("force", opts_d, { upward = true })

    return vim.fs.find(filename, opts_d)[1] or vim.fs.find(filename, opts_u)[1]
end

fmap.ruff_config = function()
    -- Derive ruff config from pyproject.toml
    local config = {}
--    local config_file = find_file("setup.cfg")
    local pyproject = find_file("pyproject.toml")

    if pyproject ~= nil then
        config["config"] = pyproject
    --elseif config_file ~= nil and vim.loop.fs_stat(config_file) ~= nil then
    --    local matches = {
    --        ["^max%-line%-length"] = "lineLength",
    --        ["^ignore%s*="] = "ignore",
    --        ["^extend%-ignore%s*="] = "extendIgnore",
    --    }

    --    for line in io.lines(config_file) do
    --        for pattern, key in pairs(matches) do
    --            if line:match(pattern) then
    --                config[key] = line:match("%s*=%s*(.*)")
    --            end
    --        end
    --    end
    end

    return config
end

fmap.mason_post_install = function(pkg)
    -- after updating pylsp automatically install pylsp plugins/extensions
    if pkg.name == "python-lsp-server" then
        return
    end

    local venv_path = vim.fn.stdpath("data") .. "/mason/packages/python-lsp-server/venv"
    local job = require("plenary.job")

    job:new({
       x = 1
    }):start()
end

return fmap
