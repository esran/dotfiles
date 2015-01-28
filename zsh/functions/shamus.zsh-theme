# Symbols
: ${is_a_git_repo_symbol:='❤'}
: ${has_untracked_files_symbol:='∿'}
: ${has_adds_symbol:='+'}
: ${has_deletions_symbol:='-'}
: ${has_deletions_cached_symbol:='✖'}
: ${has_modifications_symbol:='✎'}
: ${has_modifications_cached_symbol:='☲'}
: ${ready_to_commit_symbol:='→'}
: ${is_on_a_tag_symbol:='⌫'}
: ${needs_to_merge_symbol:='ᄉ'}
: ${has_upstream_symbol:='⇅'}
: ${detached_symbol:='⚯ '}
: ${can_fast_forward_symbol:='»'}
: ${has_diverged_symbol:='Ⴤ'}
: ${rebase_tracking_branch_symbol:='↶'}
: ${merge_tracking_branch_symbol:='ᄉ'}
: ${should_push_symbol:='↑'}
: ${has_stashes_symbol:='★'}

# Flags
: ${display_has_upstream:=false}
: ${display_tag:=false}
: ${display_tag_name:=true}
: ${two_lines:=false}
: ${finally:=''}
: ${use_color_off:=false}


# Colors
: ${on='\033[0;37m'}
: ${off='\033[1;30m'}
: ${red='\033[0;31m'}
: ${green='\033[0;32m'}
: ${yellow='\033[0;33m'}
: ${violet='\033[0;35m'}
: ${branch_color='\033[0;34m'}
: ${reset='\033[0m'}

function precmd {

    local TERMWIDTH
    (( TERMWIDTH = ${COLUMNS} ))

    ###
    # Truncate the path if it's too long.
    PR_FILLBAR=""
    PR_PWDLEN=""

	###
	# Reset PR_VCS
	PR_VCS="$(git_prompt_info)$(svn_prompt_info)"

    local promptsize=${#${(%):----(%n@%m:%l)---()--}}
    local pwdsize=${#${(%):-%~}}
    
    # See: http://stackoverflow.com/questions/10564314/count-length-of-user-visible-string-for-zsh-prompt
	local zero='%([BSUbfksu]|([FB]|){*})'
	local vcslength=${#${(S%%)PR_VCS//$~zero/}} 	
    
    if [[ "$promptsize + $vcslength + $pwdsize" -gt $TERMWIDTH ]]; then
	    ((PR_PWDLEN=$TERMWIDTH - $promptsize - $vcslength))
    # else
	# 	PR_FILLBAR="\${(l.(($TERMWIDTH - ($promptsize + $pwdsize + $vcslength)))..${PR_HBAR}.)}"
    fi


    ###
    # Get APM info.
    if which ibam > /dev/null; then
		PR_APM_RESULT=`ibam --percentbattery`
    elif which apm > /dev/null; then
		PR_APM_RESULT=`apm`
    fi
}


setopt extended_glob
preexec () {
    if [[ "$TERM" == "screen" ]]; then
		local CMD=${1[(wr)^(*=*|sudo|-*)]}
		echo -n "\ek$CMD\e\\"
    fi
}


setprompt () {
    ###
    # Need this so the prompt will work.
    setopt prompt_subst


    ###
    # See if we can use colors.
    autoload colors zsh/terminfo
    if [[ "$terminfo[colors]" -ge 8 ]]; then
		colors
    fi
    for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
		eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
		eval PR_LIGHT_$color='%{$fg[${(L)color}]%}'
		(( count = $count + 1 ))
    done
    PR_NO_COLOUR="%{$terminfo[sgr0]%}"

    ###
    # See if we can use extended characters to look nicer.
    typeset -A altchar
    set -A altchar ${(s..)terminfo[acsc]}
    PR_SET_CHARSET="%{$terminfo[enacs]%}"
    PR_SHIFT_IN="%{$terminfo[smacs]%}"
    PR_SHIFT_OUT="%{$terminfo[rmacs]%}"
    PR_HBAR=${altchar[q]:--}
    PR_ULCORNER=${altchar[l]:--}
    PR_LLCORNER=${altchar[m]:--}
    PR_LRCORNER=${altchar[j]:--}
    PR_URCORNER=${altchar[k]:--}

    
    ###
    # Decide if we need to set titlebar text.
    case $TERM in
	xterm*)
	    PR_TITLEBAR=$'%{\e]0;%(!.-=*[ROOT]*=- | .)%n@%m:%~ | ${COLUMNS}x${LINES} | %y\a%}'
	    ;;
	screen)
	    PR_TITLEBAR=$'%{\e_screen \005 (\005t) | %(!.-=[ROOT]=- | .)%n@%m:%~ | ${COLUMNS}x${LINES} | %y\e\\%}'
	    ;;
	*)
	    PR_TITLEBAR=''
	    ;;
    esac
    
    
    ###
    # Decide whether to set a screen title
    if [[ "$TERM" == "screen" ]]; then
		PR_STITLE=$'%{\ekzsh\e\\%}'
    else
		PR_STITLE=''
    fi
    
    
    ###
    # APM detection
    if which ibam > /dev/null; then
		PR_APM='$PR_RED${${PR_APM_RESULT[(f)1]}[(w)-2]}%%(${${PR_APM_RESULT[(f)3]}[(w)-1]})$PR_LIGHT_BLUE:'
    elif which apm > /dev/null; then
		PR_APM='$PR_RED${PR_APM_RESULT[(w)5,(w)6]/\% /%%}$PR_LIGHT_BLUE:'
    else
		PR_APM=''
    fi
    
    ###
    # oh-my-gosh VCS information (svn + git)
    PR_VCS=""
    
    ###
    # Finally, the prompt.
    PROMPT='$PR_SET_CHARSET$PR_STITLE${(e)PR_TITLEBAR}\
$PR_BLUE$PR_SHIFT_IN$PR_ULCORNER$PR_BLUE$PR_HBAR$PR_SHIFT_OUT(\
$PR_GREEN%(!.%SROOT%s.%n)$PR_GREEN@%m:%l\
$PR_BLUE)$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
$PR_BLUE($PR_MAGENTA%$PR_PWDLEN<...<%~%<<$PR_BLUE)\
$PR_BLUE$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
$PR_VCS\
$PR_SHIFT_IN$PR_BLUE$PR_HBAR$PR_SHIFT_OUT\

$PR_BLUE$PR_SHIFT_IN$PR_LLCORNER$PR_BLUE$PR_HBAR$PR_SHIFT_OUT(\
%(?..$PR_LIGHT_RED%?$PR_BLUE)\
${(e)PR_APM}$PR_GREEN\
$PR_LIGHT_BLUE%(!.$PR_RED.$PR_WHITE)%#$PR_BLUE)$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
$PR_BLUE$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
$PR_NO_COLOUR '

#     RPROMPT=' $PR_BLUE$PR_SHIFT_IN$PR_HBAR$PR_BLUE$PR_HBAR$PR_SHIFT_OUT\
# ($PR_GREEN%D{%a,%b%d}$PR_BLUE)$PR_SHIFT_IN$PR_HBAR$PR_BLUE$PR_LRCORNER$PR_SHIFT_OUT$PR_NO_COLOUR'

    PS2='$PR_CYAN$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
$PR_BLUE$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT(\
$PR_LIGHT_GREEN%_$PR_BLUE)$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
$PR_CYAN$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT$PR_NO_COLOUR '
}

setprompt

ZSH_PROMPT_BASE_COLOR="%{$fg_bold[blue]%}"

ZSH_THEME_REPO_NAME_COLOR="%{$fg_bold[red]%}"

ZSH_THEME_GIT_PROMPT_PREFIX="[%{$fg[magenta]%}git:(%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg_bold[blue]%}]"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[magenta]%})%{$fg[red]%} ✗ %{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[magenta]%})%{$reset_color%}"

ZSH_THEME_SVN_PROMPT_PREFIX="[%{$fg[magenta]%}svn:("
ZSH_THEME_SVN_PROMPT_SUFFIX="%{$fg[magenta]%})"
ZSH_THEME_SVN_PROMPT_DIRTY="%{$fg[red]%} ✘ %{$fg[blue]%}]%{$reset_color%}"
ZSH_THEME_SVN_PROMPT_CLEAN="%{$fg_bold[blue]%}]%{$reset_color%}"
ZSH_THEME_REPO_NAME_COLOR="%{$fg[green]%}"

local return_code="%(?..%{$fg[red]%}%? %{$reset_color%})"
