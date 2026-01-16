# Neovim

Türkçe'ye özgü ayar ve araçlar içeren eklenti.

### Kurulum (LazyVim / lazy.nvim)

Eklentiyi `lazy.nvim` paket yöneticisi ile kurmak için yapılandırmanıza aşağıdaki bloğu ekleyebilirsiniz. Eklenti bu
deponun `opt/nvim` alt dizininde yer aldığı için `rtp` ayarını belirtmemiz gerekir:

```lua
{
	"roktas/turkish",

	branch = "main",
	lazy = false,

	config = function(plugin)
		vim.opt.rtp:prepend(plugin.dir .. "/opt/nvim")
		require("turkish").defaults()
	end,
},
```

### Yapılandırma

Kısaltmaların (`iabbrev`) sadece Markdown dosyalarına kullanılması için:

```lua
require("turkish").setup({
	abbreviate = { "markdown" },
	map = true,
})
```
