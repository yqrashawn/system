{ config, pkgs, lib, ... }: {
  programs.neovim = let inherit (lib.vimUtils ./.) readLuaSection pluginWithLua;
  in {
    plugins = with pkgs.vimPlugins; [
      (pluginWithLua {
        plugin = nvim-cmp;
        file = "nvim-cmp";
      })
      cmp-nvim-lsp
      cmp-buffer
      luasnip
      cmp_luasnip
      cmp-treesitter
    ];
  };
}
