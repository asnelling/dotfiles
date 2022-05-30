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

setup_brew_guard() {
    BREW_CMD="$(which brew)"

    brew_guard() {
        if [[ -O "/usr/local/Cellar" ]]; then
            $BREW_CMD $@
        else
            print "ERROR: only run brew from the single user that installed it!" >&2
        fi
    }

    if [[ -x "${BREW_CMD}" ]]; then
        alias brew=brew_guard
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

setup_zsh_completions() {
    if [[ -d ~/.local/share/zsh-completions ]]; then
        fpath=(
            ~/.local/share/zsh-completions
            $fpath
        )
    elif [[ -d /usr/local/share/zsh-completions ]]; then
        fpath=(
            "/usr/local/share/zsh-completions"
            $fpath
        )
    else
        echo "WARN: zsh-completions not found. To install: run \"install_zsh_completions\"" >&2
    fi
}

install_zsh_completions() {
    echo "Getting latest tarball URL from: https://api.github.com/repos/zsh-users/zsh-completions/releases/latest"
    readonly tarball_url="$(curl https://api.github.com/repos/zsh-users/zsh-completions/releases/latest | jq --raw-output '.tarball_url')"
    readonly tmpd="$(mktemp -d)"
    readonly installdir=~/.local/share/zsh-completions

    pushd "$tmpd"
    echo "Downloading ${tarball_url}"
    wget -O zsh-completions.tar.gz "${tarball_url}"
    tar --strip-components=2 -xf zsh-completions.tar.gz '*/src'
    rm -rf "$installdir"
    mkdir -p "$installdir"
    mv _* "$installdir/"
    popd
    rm -rf "$tmpd"

    echo "Finished installing zsh-completions in: $installdir"
}

setup_zsh_fast_syntax_highlighting() {
    if [[ -d ~/.local/share/zsh-fast-syntax-highlighting ]]; then
        source ~/.local/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
    elif [[ -d /usr/local/opt/zsh-fast-syntax-highlighting ]]; then
        source /usr/local/opt/zsh-fast-syntax-highlighting/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
    else
        echo "WARN: zsh-fast-syntax-highlighting not found. To install: run \"install_zsh_fast_syntax_highlighting\"" >&2
    fi
}

install_zsh_fast_syntax_highlighting() {
    echo "Getting latest tarball URL from: https://api.github.com/repos/zdharma-continuum/fast-syntax-highlighting/tags"
    readonly tarball_url="$(curl https://api.github.com/repos/zdharma-continuum/fast-syntax-highlighting/tags | jq --raw-output '.[0].tarball_url')"
    readonly tmpd="$(mktemp -d)"
    readonly installdir=~/.local/share/zsh-fast-syntax-highlighting

    pushd "$tmpd"
    echo "Downloading ${tarball_url}"
    wget -O zsh-fast-syntax-highlighting.tar.gz "${tarball_url}"
    tar --strip-components=1 --exclude='.*' -xf zsh-fast-syntax-highlighting.tar.gz
    rm zsh-fast-syntax-highlighting.tar.gz
    rm -rf "$installdir"
    mkdir -p "$installdir"
    mv -- * "$installdir/"
    popd
    rm -rf "$tmpd"

    echo "Finished installing zsh-fast-syntax-highlighting in: $installdir"
}

# vim: sw=4