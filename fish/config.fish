if status is-interactive
   set fish_greeting

   set -xg fish_color_autosuggestion '555'  'yellow'
   set -xg fish_color_cancel -r
   set -xg fish_color_command '005fd7'  'purple'
   set -xg fish_color_comment red
   set -xg fish_color_cwd green
   set -xg fish_color_cwd_root red
   set -xg fish_color_end 009900
   set -xg fish_color_error 'red'  '--bold'
   set -xg fish_color_escape cyan
   set -xg fish_color_history_current cyan
   set -xg fish_color_host '-o'  'cyan'
   set -xg fish_color_match cyan
   set -xg fish_color_normal normal
   set -xg fish_color_operator cyan
   set -xg fish_color_param '00afff'  'cyan'
   set -xg fish_color_quote brown
   set -xg fish_color_redirection normal
   set -xg fish_color_search_match --background=purple
   set -xg fish_color_selection --background=purple
   set -xg fish_color_status red
   set -xg fish_color_user '-o'  'green'
   set -xg fish_color_valid_path --underline

   set -xg fish_pager_color_completion normal
   set -xg fish_pager_color_description '555'  'yellow'
   set -xg fish_pager_color_prefix cyan
   set -xg fish_pager_color_progress cyan

   theme_gruvbox dark hard
end

if test -d ~/bin
   set -gx PATH ~/bin $PATH 
end

if test -d ~/.local/bin
   set -gx PATH ~/.local/bin $PATH 
end

if test -d ~/.dotfiles/bin
  set -gx PATH ~/.dotfiles/bin $PATH
end


set -gx TOKEN (cat "$HOME/.git-credentials" | grep traton | cut -d ":" -f3 | cut -d "@" -f1 | tr -d '\n')
set -gx CONAN_PASSWORD $TOKEN
set -gx GITLAB_PRIVATE_TOKEN $TOKEN

if status is-interactive
    if not set -q SSH_AUTH_SOCK
        eval (ssh-agent -c)
    end
    ssh-add ~/.ssh/id_rsa
end
