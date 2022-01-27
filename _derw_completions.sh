#!/bin/bash

_apply_no_space()
{
    type compopt &>/dev/null && compopt -o nospace
}

_suggest_files()
{
    local options cur file_ext actual_options word input_word seen
    cur=$1
    file_ext=$2

    if [[ "$cur" == "" ]]; then
        options=$(ls *.$file_ext 2>/dev/null)
        options+=" "
        options+=$(ls -d */ 2>/dev/null)
    else
        options=$(ls $cur*.$file_ext 2>/dev/null)
        options+=" "
        options+=$(ls -d $cur*/ 2>/dev/null)
    fi

    actual_options=""

    for word in $options; do
        seen=0
        for input_word in ${COMP_WORDS[@]}; do
            if [[ $word == $input_word ]]; then
                seen=1
                break;
            fi
        done

        if [[ "$seen" == "0" ]]; then
            actual_options+="$word "
        fi
    done

    COMPREPLY=( $(compgen -W "${actual_options}" -- $cur) )
    if [[ $COMPREPLY == */ ]]; then
        _apply_no_space
    fi
}

_suggest_bundle_flags()
{
    local flag_options cur
    flag_options="--output --entry --quiet --watch --help"
    cur=$1
    COMPREPLY=( $(compgen -W "${flag_options}" -- $cur) )
}

_suggest_compile_flags()
{
    local flag_options cur
    flag_options="--files --target --output --verify --debug --only --run --names --watch --quiet --help"
    cur=$1
    COMPREPLY=( $(compgen -W "${flag_options}" -- $cur) )
}

_suggest_compile_targets()
{
    local flag_options cur
    flag_options="ts js elm derw"
    cur=$1
    COMPREPLY=( $(compgen -W "${flag_options}" -- $cur) )
}

_suggest_info_flags()
{
    local flag_options cur
    flag_options="--file --help"
    cur=$1
    COMPREPLY=( $(compgen -W "${flag_options}" -- $cur) )
}

_suggest_init_flags()
{
    local flag_options cur
    flag_options="--dir --help"
    cur=$1
    COMPREPLY=( $(compgen -W "${flag_options}" -- $cur) )
}

_suggest_install_flags()
{
    local flag_options cur
    flag_options="--name --version --quiet --help"
    cur=$1
    COMPREPLY=( $(compgen -W "${flag_options}" -- $cur) )
}

_suggest_repl_flags()
{
    local flag_options cur
    flag_options=""
    cur=$1
    COMPREPLY=( $(compgen -W "${flag_options}" -- $cur) )
}

_suggest_test_flags()
{
    local flag_options cur
    flag_options="--watch --help"
    cur=$1
    COMPREPLY=( $(compgen -W "${flag_options}" -- $cur) )
}

_suggest_commands()
{
    local flag_options cur
    flag_options="bundle compile format info init install repl test"
    cur=$1
    COMPREPLY=( $(compgen -W "${flag_options}" -- $cur) )
}

_derw()
{
    local command_name cur prev
    COMPREPLY=()
    # this is the root command, e.g compile, info
    command_name="${COMP_WORDS[1]}"
    # this is the current word to be completed
    cur="${COMP_WORDS[COMP_CWORD]}"
    # this is the previous word
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    # for when we don't have a command yet
    if [[ $COMP_CWORD -eq 1 ]]; then
        _suggest_commands $cur
        return 0
    fi

    # main command parsing

    if [[ $command_name == "bundle" ]]; then
        if [[ $cur == -* ]]; then
            _suggest_bundle_flags $cur
            return 0
        elif [[ $prev == "--entry" ]]; then
            _suggest_files "$cur" "derw"
            return 0
        elif [[ $prev == "--output" ]]; then
            _suggest_files "$cur" "js"
            return 0
        fi
    elif [[ $command_name == "compile" ]]; then
        if [[ $cur == -* ]]; then
            _suggest_compile_flags $cur
            return 0
        elif [[ $prev == "--files" ]]; then
            _suggest_files "$cur" "derw"
            return 0
        elif [[ $prev == "--target" ]]; then
            _suggest_compile_targets "$cur"
            return 0
        elif [[ $prev == "--output" ]]; then
            _suggest_files "$cur" "*"
            return 0
        fi
    elif [[ $command_name == "info" ]]; then
        if [[ $cur == -* ]]; then
            _suggest_info_flags $cur
            return 0
        elif [[ $prev == "--file" ]]; then
            _suggest_files "$cur" "derw"
            return 0
        fi
    elif [[ $command_name == "init" ]]; then
        if [[ $cur == -* ]]; then
            _suggest_init_flags $cur
            return 0
        fi
    elif [[ $command_name == "install" ]]; then
        if [[ $cur == -* ]]; then
            _suggest_install_flags $cur
            return 0
        fi
    elif [[ $command_name == "repl" ]]; then
        if [[ $cur == -* ]]; then
            _suggest_repl_flags $cur
            return 0
        fi
    elif [[ $command_name == "test" ]]; then
        if [[ $cur == -* ]]; then
            _suggest_test_flags $cur
            return 0
        fi
    fi

    return 1
}

complete -F _derw "derw"