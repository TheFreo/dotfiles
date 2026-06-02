Header:children_add(function()
	if ya.target_family() ~= "unix" then
		return ""
	end
	return ui.Span(ya.user_name() .. "@" .. ya.host_name() .. ":"):fg("blue")
end, 500, Header.LEFT)

require("kdeconnect-send"):setup({
    auto_select_single = false,
})

require("bunny"):setup({
  hops = {
    { key = "~",          path = "~",              desc = "Home"         },
    { key = "n",          path = "~/Nextcloud/",   desc = "Nextcloud"    },
    { key = "m",          path = "~/Music",        desc = "Music"        },
    { key = "d",          path = "~/Downloads",    desc = "Downloads"    },
    { key = "p",          path = "~/Pictures",      desc = "Pictures"    },
    { key = "c",          path = "~/.config",      desc = "Config files" },
    { key = "t",          path = "~/.local/share/Trash/files",      desc = "Trash files" },
    -- key and path attributes are required, desc is optional
  },
  desc_strategy = "path", -- If desc isn't present, use "path" or "filename", default is "path"
  ephemeral = true, -- Enable ephemeral hops, default is true
  tabs = true, -- Enable tab hops, default is true
  notify = false, -- Notify after hopping, default is false
  fuzzy_cmd = "fzf", -- Fuzzy searching command, default is "fzf"
})
