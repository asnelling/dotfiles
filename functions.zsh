prepend_to_path() {
    if [[ -d "${argv[1]}" ]]; then
        path=(
            "${argv[1]}"
            ${path}
        )
    fi
}

# usage: try_source <file> [file]...
# For each file given, source the first one that exists, skipping the rest.
try_source() {
    for x in "$@"; do
        if [[ -f "${x}" ]]; then
            source "${x}"
            return
        fi
    done
}

setup_android_sdk() {
    if [[ ! -z "$ANDROID_HOME" && -d "$ANDROID_HOME" ]]; then
        return
    fi
    ANDROID_HOME=
    if [[ -d ~/Library/Android/sdk ]]; then
        ANDROID_HOME=~/Library/Android/sdk
    elif [[ -d ~/Android/Sdk ]]; then
        ANDROID_HOME=~/Android/Sdk
    elif [[ -d ~/.local/share/android-sdk ]]; then
        ANDROID_HOME=~/.local/share/android-sdk
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
    if [[ ! -z "$JAVA_HOME" && -d "$JAVA_HOME" ]]; then
        return
    fi
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
    else
        echo "NOTICE: zkbd keymap not found: ${keymap_file}" >&2
        echo "To configure: autoload -U zkbd; zkbd" >&2
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
    elif [[ -d /usr/share/zsh/site-functions ]]; then
        fpath=(
            "/usr/share/zsh/site-functions"
            $fpath
        )
    else
        echo "WARN: zsh-completions not found. To install: run \"install_zsh_completions\"" >&2
    fi
}

install_zsh_completions() {
    typeset -h tmpd="$(mktemp -d)"
    typeset -h installdir="${HOME}/.local/share/zsh-completions"
    typeset -h tarball_sha256="8d42ca6b40c30cad6a746ab883b01415424c6ca4528e306d314fcf9cbf680e58"
    typeset -h tarball_name="zsh-completions.tar.gz"
    typeset -h tarball_url="https://api.github.com/repos/zsh-users/zsh-completions/tarball/0.34.0"

    trap "popd; [[ ! -d \"$tmpd\" ]] || rm -rf \"$tmpd\"" EXIT
    setopt err_return
    pushd "${tmpd}"

    echo "Downloading ${tarball_url}"
    curl -LsSf -o "${tarball_name}" "${tarball_url}"
    echo "${tarball_sha256}  ${tarball_name}" | sha256sum -c -
    tar --strip-components=1 -xf "${tarball_name}"
    rm -rf "$installdir"
    mkdir -p "$installdir"
    mv ./src/* "$installdir/"

    echo "Finished installing zsh-completions in: $installdir"
}
