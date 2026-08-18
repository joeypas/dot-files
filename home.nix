{ config, lib, pkgs, ... }:

{
  home.username = "josephliotta";
  home.homeDirectory = "/Users/josephliotta";

  home.packages = [
    pkgs.vim
    pkgs.pure-prompt
    pkgs.lua51Packages.lua
    pkgs.lua51Packages.luarocks
    pkgs.tree-sitter
    pkgs.tmux
    pkgs.git
    pkgs.gh
    pkgs.eza
    pkgs.zsh-autosuggestions
    pkgs.fzf
      #pkgs.fzf-zsh
    pkgs.wget
    pkgs.bat
    pkgs.nmap
    pkgs.ripgrep
    pkgs.tlrc
    pkgs.lazygit
    pkgs.zstd
    pkgs.uv
    pkgs.markdownlint-cli
    pkgs.zsh-fzf-tab
    pkgs.zsh-fast-syntax-highlighting
    pkgs.zsh-nix-shell
    pkgs.zig-shell-completions
  ];

  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Joe Liotta";
        email = "jliotta03@gmail.com";
      };
      init.defaultBranch = "main";
    };
  };

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "https";
      aliases.co = "pr checkout";
    };
  };

  programs.zsh = {
    enable = true;
    autocd = true;
    autosuggestion.enable = true;
    enableCompletion = true;

    plugins = [
      {
        name = "fzf-tab";
        src = pkgs.zsh-fzf-tab;
        file = "share/fzf-tab/fzf-tab.plugin.zsh";
      }
      {
        name = "fast-syntax-highlighting";
        src = pkgs.zsh-fast-syntax-highlighting;
        file = "share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh";
      }
      {
        name = "simple-zsh-nix-shell";
        src = pkgs.zsh-nix-shell;
        file = "share/zsh-nix-shell/nix-shell.plugin.zsh";
      }
    ];

    initContent = ''
      bindkey -v
      bindkey '^R' history-incremental-search-backward

      alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
      alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'

      fpath+=(${pkgs.pure-prompt}/share/zsh/site-functions)
      autoload -Uz promptinit
      promptinit
      zstyle :prompt:pure:path color '#89a498'
      zstyle :prompt:pure:execution_time color '#f0bf4f'
      prompt pure

      if [[ -n $SSH_CONNECTION ]]; then
        export EDITOR=vim
      else
        export EDITOR=nvim
      fi

      export MANPATH="$HOME/.opam/default/man:$MANPATH"

      source "$HOME/.orbstack/shell/init.zsh" 2>/dev/null || :
    '';

    sessionVariables = {
      MANPAGER = "nvim +Man!";
      GHOSTTY_CONFIG = "${config.xdg.configHome}/ghostty/config";
      HOMEBREW_PREFIX = "/opt/homebrew";
      HOMEBREW_CELLAR = "/opt/homebrew/Cellar";
      HOMEBREW_REPOSITORY = "/opt/homebrew";
      INFOPATH = "/opt/homebrew/share/info";
    };

    shellAliases = {
      ls = "eza";
      homesize = "sudo du -h -x -I Library -d 1 ~ | sort -rh";
      lg = "eza -la --git";
    };
  };

  home.sessionPath = [
    "/etc/profiles/per-user/${config.home.username}/bin"
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"
    "/usr/local/texlive/2025/bin/universal-darwin"
    "/usr/local/MacGPG2/bin"
  ];

  programs.tmux = {
    enable = true;
    mouse = true;
    keyMode = "vi";
    terminal = "xterm-256color";
    plugins = with pkgs.tmuxPlugins; [
      sensible
      {
        plugin = gruvbox;
        extraConfig = "set -g @tmux-gruvbox 'dark'";
      }
    ];
    extraConfig = builtins.readFile ./dotfiles/tmux.conf;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  xdg.configFile."nvim".source = ./dotfiles/nvim;
  xdg.configFile."ghostty/config".source = ./dotfiles/ghostty/config;
  xdg.configFile."ghostty/themes/gruvbox-dark".source =
    ./dotfiles/ghostty/gruvbox-dark;

}
