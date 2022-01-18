{ lib, ... }: {
  imports = [
    ./bash
    ./css
    ./go-lsp
    ./html
    ./json
    ./latex
    # ./lua-lsp # build failure
    ./lualine-nvim
    ./nvim-autopairs
    ./nvim-cmp
    ./nvim-lspconfig
    ./pyright-lsp
    ./rnix-lsp
    ./svelte-lsp
    ./typescript-lsp
    ./vimscript-lsp
    ./vue-lsp
    ./yaml-lsp
    # ./coc

    ./theme
    ./treesitter
    ./vim-closetag
    ./fzf
    # ./skim
  ];
}
