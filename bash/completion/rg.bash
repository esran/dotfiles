_rg() {
    local i cur prev opts cmds
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    cmd=""
    opts=""

    for i in ${COMP_WORDS[@]}
    do
        case "${i}" in
            rg)
                cmd="rg"
                ;;
            
            *)
                ;;
        esac
    done

    case "${cmd}" in
        rg)
            opts=" -s -c -l -F -L -i -v -n -N -x -0 -o -p -q -z -S -a -u -H -w -h -V -A -B -C -E -f -g -M -m -e -r -j -t -T  --case-sensitive --column --count --debug --files --files-with-matches --files-without-match --fixed-strings --follow --no-follow --heading --no-heading --hidden --no-hidden --ignore-case --invert-match --line-number --no-line-number --line-regexp --mmap --no-mmap --no-config --no-ignore --ignore --no-ignore-parent --ignore-parent --no-ignore-vcs --ignore-vcs --no-messages --messages --null --only-matching --passthru --pretty --quiet --search-zip --no-search-zip --smart-case --sort-files --no-sort-files --text --no-text --type-list --unrestricted --vimgrep --with-filename --no-filename --word-regexp --help --version --after-context --before-context --color --colors --context --context-separator --dfa-size-limit --encoding --file --glob --iglob --ignore-file --line-number-width --max-columns --max-count --max-filesize --maxdepth --path-separator --regex-size-limit --regexp --replace --threads --type --type-add --type-clear --type-not  <PATTERN> <PATH>... "
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 1 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
                return 0
            fi
            case "${prev}" in
                
                --after-context)
                    COMPREPLY=("<NUM>")
                    return 0
                    ;;
                    -A)
                    COMPREPLY=("<NUM>")
                    return 0
                    ;;
                --before-context)
                    COMPREPLY=("<NUM>")
                    return 0
                    ;;
                    -B)
                    COMPREPLY=("<NUM>")
                    return 0
                    ;;
                --color)
                    COMPREPLY=($(compgen -W "never auto always ansi" -- ${cur}))
                    return 0
                    ;;
                --colors)
                    COMPREPLY=("<COLOR_SPEC>...")
                    return 0
                    ;;
                --context)
                    COMPREPLY=("<NUM>")
                    return 0
                    ;;
                    -C)
                    COMPREPLY=("<NUM>")
                    return 0
                    ;;
                --context-separator)
                    COMPREPLY=("<SEPARATOR>")
                    return 0
                    ;;
                --dfa-size-limit)
                    COMPREPLY=("<NUM+SUFFIX?>")
                    return 0
                    ;;
                --encoding)
                    COMPREPLY=("<ENCODING>")
                    return 0
                    ;;
                    -E)
                    COMPREPLY=("<ENCODING>")
                    return 0
                    ;;
                --file)
                    COMPREPLY=("<PATH>...")
                    return 0
                    ;;
                    -f)
                    COMPREPLY=("<PATH>...")
                    return 0
                    ;;
                --glob)
                    COMPREPLY=("<GLOB>...")
                    return 0
                    ;;
                    -g)
                    COMPREPLY=("<GLOB>...")
                    return 0
                    ;;
                --iglob)
                    COMPREPLY=("<GLOB>...")
                    return 0
                    ;;
                --ignore-file)
                    COMPREPLY=("<PATH>...")
                    return 0
                    ;;
                --line-number-width)
                    COMPREPLY=("<NUM>")
                    return 0
                    ;;
                --max-columns)
                    COMPREPLY=("<NUM>")
                    return 0
                    ;;
                    -M)
                    COMPREPLY=("<NUM>")
                    return 0
                    ;;
                --max-count)
                    COMPREPLY=("<NUM>")
                    return 0
                    ;;
                    -m)
                    COMPREPLY=("<NUM>")
                    return 0
                    ;;
                --max-filesize)
                    COMPREPLY=("<NUM+SUFFIX?>")
                    return 0
                    ;;
                --maxdepth)
                    COMPREPLY=("<NUM>")
                    return 0
                    ;;
                --path-separator)
                    COMPREPLY=("<SEPARATOR>")
                    return 0
                    ;;
                --regex-size-limit)
                    COMPREPLY=("<NUM+SUFFIX?>")
                    return 0
                    ;;
                --regexp)
                    COMPREPLY=("<PATTERN>...")
                    return 0
                    ;;
                    -e)
                    COMPREPLY=("<PATTERN>...")
                    return 0
                    ;;
                --replace)
                    COMPREPLY=("<REPLACEMENT_TEXT>")
                    return 0
                    ;;
                    -r)
                    COMPREPLY=("<REPLACEMENT_TEXT>")
                    return 0
                    ;;
                --threads)
                    COMPREPLY=("<NUM>")
                    return 0
                    ;;
                    -j)
                    COMPREPLY=("<NUM>")
                    return 0
                    ;;
                --type)
                    COMPREPLY=("<TYPE>...")
                    return 0
                    ;;
                    -t)
                    COMPREPLY=("<TYPE>...")
                    return 0
                    ;;
                --type-add)
                    COMPREPLY=("<TYPE_SPEC>...")
                    return 0
                    ;;
                --type-clear)
                    COMPREPLY=("<TYPE>...")
                    return 0
                    ;;
                --type-not)
                    COMPREPLY=("<TYPE>...")
                    return 0
                    ;;
                    -T)
                    COMPREPLY=("<TYPE>...")
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
            return 0
            ;;
        
    esac
}

complete -F _rg -o bashdefault -o default rg
