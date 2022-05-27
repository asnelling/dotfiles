prepend_to_path() {
    if [[ -d "${argv[1]}" ]]; then
        path=(
            "${argv[1]}"
            ${path}
        )
    fi
}

setup_android_sdk() {
    ANDROID_HOME=
    if [[ -d ~/Library/Android/sdk ]]; then
        ANDROID_HOME=~/Library/Android/sdk
    elif [[ -d ~/Android/Sdk ]]; then
        ANDROID_HOME=~/Android/Sdk
    fi

    if [[ -n "$ANDROID_HOME" ]]; then
        export ANDROID_HOME
        export ANDROID_SDK_ROOT="${ANDROID_HOME}"

        prepend_to_path "${ANDROID_HOME}/cmdline-tools/latest/bin"
        prepend_to_path "${ANDROID_HOME}/platform-tools"
    fi
}

setup_help() {
    # on-line help for ZSH builtins
    # key binding: ^[h (ESC h)

    if [[ -d "/usr/share/zsh/${ZSH_VERSION}/help" ]]; then
        HELPDIR="/usr/share/zsh/${ZSH_VERSION}/help"
    elif [[ -d "/usr/share/zsh/help" ]]; then
        HELPDIR="/usr/share/zsh/${ZSH_VERSION}/help"
    fi

    if [[ -n "${HELPDIR}" ]]; then
        unalias run-help 2>/dev/null
        autoload run-help
    fi
}

setup_java() {
    JAVA_HOME=
    if [[ -d "/usr/local/opt/openjdk@11" ]]; then
        JAVA_HOME="/usr/local/opt/openjdk@11"
    elif [[ -d "/usr/lib/jvm/default-java" ]]; then
        JAVA_HOME="/usr/lib/jvm/default-java"
    fi

    if [[ -n "${JAVA_HOME}" ]]; then
        export JAVA_HOME
        prepend_to_path "${JAVA_HOME}"
    fi
}

setup_terraform_completions() {
    if [[ -x "$(which terraform)" ]]; then
        autoload -U +X bashcompinit && bashcompinit
        complete -o nospace -C "$(which terraform)" terraform
    fi
}

setup_zkbd() {
    readonly keymap_file=~/.zkbd/$TERM-${${DISPLAY:t}:-$VENDOR-$OSTYPE}
    if [[ -f "${keymap_file}" ]]; then
        source "${keymap_file}"
        [[ -n ${key[Home]} ]] && bindkey "${key[Home]}" beginning-of-line
        [[ -n ${key[End]} ]] && bindkey "${key[End]}" end-of-line
    fi
}
