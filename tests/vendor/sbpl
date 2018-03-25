#!/bin/bash
set -eu

sbpl_name="Simple Bash Package Loader"
export sbpl_version="0.4.0"

export sbpl=$0
export sbpl_pkg="sbpl-pkg.sh"
export sbpl_dir_pkgs="vendor"
export sbpl_dir_bins="$sbpl_dir_pkgs/bin"
export sbpl_dir_tmps="$sbpl_dir_pkgs/tmp"

#######################################

function export_platform_info () {

    if [ -z ${OSTYPE+x} ] && [ ! -z ${OS+x} ]; then
        OSTYPE="$OS"
    fi

    case "$OSTYPE" in
        android*)   _sbpl_os="android"   ;;
        darwin*)    _sbpl_os="darwin"    ;;
        dragonfly*) _sbpl_os="dragonfly" ;;
        freebsd*)   _sbpl_os="freebsd"   ;;
        linux*)     _sbpl_os="linux"     ;;
        netbsd*)    _sbpl_os="netbsd"    ;;
        openbsd*)   _sbpl_os="openbsd"   ;;
        plan9*)     _sbpl_os="plan9"     ;;
        solaris*)   _sbpl_os="solaris"   ;;
        Windows*)   _sbpl_os="windows"   ;;
        *)          _sbpl_os="$OSTYPE"   ;;
    esac;

    export _sbpl_os

    if [ -z ${sbpl_os+x} ]; then
        export sbpl_os="$_sbpl_os"
    fi

    if [ "$sbpl_os" = "windows" ] && [ -z ${HOSTTYPE+x} ]; then
        if [ -z ${PROCESSOR_ARCHITEW6432+x} ]; then
            HOSTTYPE="$PROCESSOR_ARCHITEW6432"
        else
            case "$PROCESSOR_ARCHITECTURE" in
                x86)    HOSTTYPE="i386"                     ;;
                *)      HOSTTYPE="$PROCESSOR_ARCHITECTURE"  ;;
            esac;
        fi
    fi

    case "$HOSTTYPE" in
        arm64*)     _sbpl_arch="arm64"        ;;
        arm*)       _sbpl_arch="arm"          ;;
        i386*)      _sbpl_arch="368"          ;;
        x86_64*)    _sbpl_arch="amd64"        ;;
        ppc64le*)   _sbpl_arch="ppc64le"      ;;
        ppc64*)     _sbpl_arch="ppc64"        ;;
        mips64le*)  _sbpl_arch="mips64le"     ;;
        mips64*)    _sbpl_arch="mips64"       ;;
        mipsle*)    _sbpl_arch="mipsle"       ;;
        mips*)      _sbpl_arch="mips"         ;;
        *)          _sbpl_arch="$HOSTTYPE"    ;;
    esac;

    export _sbpl_arch

    if [ -z ${sbpl_arch+x} ]; then
        export sbpl_arch="$_sbpl_arch"
    fi
}

function sbpl_env () {

    export sbpl_dir_pkg="$sbpl_dir_pkgs/$sbpl_os/$sbpl_arch"
    export sbpl_dir_bin="$sbpl_dir_bins/$sbpl_os/$sbpl_arch"
    export sbpl_dir_tmp="$sbpl_dir_tmps/$sbpl_os/$sbpl_arch"
}

function sbpl_get () {

    function has_command () {
        command -v "$1" &> /dev/null
    }

    function check_dependency () {
        if ! has_command $1; then
            printf "Dependency '$1' not found\n" 1>&2
            exit 127
        fi
    }

    function unpack () {
        src="$1"
        dst="$2"
        src="$([ "$src" != "${src#/}" ] && echo "$src" || echo "$PWD/$src")"

        if [ ! -f "$src" ] ; then
            printf "%s\bn" "file '$src' does not exist" 1>&2
            return 1
        fi

        # Try to unpack
        pushd "$dst" > /dev/null
            function extract () {
            # https://github.com/xvoland/Extract/blob/v0.7/extract.sh

                function run () {
                    cmd=$1; shift
                    if ! command -v "$cmd" > /dev/null; then exit 127; fi
                    $cmd $@
                }

                case "$src" in
                    *.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)
                                run tar xvf "$src"     ;;
                    *.lzma)     run unlzma "$src"      ;;
                    *.bz2)      run bunzip2 "$src"     ;;
                    *.rar)      run unrar x -ad "$sc"  ;;
                    *.gz)       run gunzip "$src"      ;;
                    *.zip)      run unzip "$src"       ;;
                    *.z)        run uncompress "$src"  ;;
                    *.7z|*.arj|*.cab|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.rpm|*.udf|*.wim|*.xar)
                                run 7z x "$src"        ;;
                    *.xz)       run unxz "$src"        ;;
                    *.exe)      run cabextract "$src"  ;;
                    *)          return 127             ;;
                esac
            }

            set +e
            (extract "$src")
            result="$?"
            set -e
        popd > /dev/null

        if [ "$result" -eq 127 ]; then # command not found | unknown archive method

            bin_name=''

            case "$src" in
                *.zip|*.tar|*.tar.gz|*.tgz|*.tar.bz2|*.tbz2|*.tar.xz|*.txz|*.tar.lz4|*.tlz4|*.tar.sz|*.tsz|*.rar)
                        bin_name='archiver'
                        bin_ver='2.0.1'
                        # currently there is a bug in archiver, that symlinks are not created correctly.
                        # bin_url="https://github.com/mholt/$bin_name/releases/download/v$bin_ver/${bin_name}_${bin_os}_${_sbpl_arch}"
                        bin_url='https://github.com/peterpostmann/${name}/releases/download/v${version}/${name}_${sbpl_os}_${sbpl_arch}'
                        bin_bin='./'
                        ;;
                *)      ;;
            esac

            if [ ! -z "$bin_name" ]; then
                set +e
                (
                    set -e

                    PATH="$PWD/$sbpl_dir_bins/current:$PATH"
                    sbpl_os="$_sbpl_os"
                    sbpl_arch="$_sbpl_arch"

                    if ! has_command archiver; then
                        get_pkg 'file' "$bin_name" "$bin_ver" "$bin_url" "$bin_bin"
                    fi

                    archiver open "$src" "$dst"
                )
                [ "$?" -eq 0 ] && result=0
                set -e
            fi
        fi

        if [ "$result" -ne 0 ]; then
            printf "No suitable tool to extract archive found\n" 1>&2
        fi

        exit $result
    }

    function sbpl_usage () {

        printf "Usage: sbpl_get 'target'\n" 1>&2
        printf "file    'name' 'version'    'url'\n" 1>&2
        printf "archive 'name' 'version'    'url' 'bin_dir'\n" 1>&2
        printf "git     'name' 'branch/tag' 'url' 'bin_dir'\n" 1>&2
    }

    function get_pkg () {

    # Check number of arguments
    if [ "$#" -lt 4 ]; then sbpl_usage; return 2; fi

    # Check how we fetch data
    if has_command "curl"; then
        function fetch () { curl -fSL# "$1" -o "$2"; }
    elif has_command "wget"; then
       function fetch () { wget --progress=bar -O "$2" "$1"; }
    else
        printf "Neither 'curl' nor 'wget' found\n" 1>&2
        exit 2
    fi

    # Check target
    target="$1"
    case "$target" in
        file)                                           ;;
        archive)                                        ;;
        git)        check_dependency git                ;;
        *)          printf "Unknown option $target\n" 1>&2
                    sbpl_usage; return 2;               ;;
    esac

    # Process arguments
    name=$2
    version=$3
    url=$(eval "printf \"$4\"")

    if [ "$#" -ge 5 ]; then
        pkg_dir_bin=$(eval "printf \"$5\"")
    else
        pkg_dir_bin=""
    fi

    # Update Locations
    sbpl_env

    pkg="${name}-${version}"
    pkg_dir="$sbpl_dir_pkg/$pkg"
    pkg_path="$PWD/$pkg_dir"

    result=0

    # Check if package is present
    if [ ! -d "$pkg_dir" ] ; then

        printf "Get package: $sbpl_os/$sbpl_arch/$pkg\n"

        mkdir -p "$pkg_dir"

        if [ "$target" = "file" ] || [ "$target" = "archive" ]; then

            filename="${url##*/}"
            extension="${filename##*.}"
            extension="$([ -z "$extension" ] && echo "" || echo ".$extension")"
            tmpfile="$sbpl_dir_tmp/${pkg}$extension"
            mkdir -p "$sbpl_dir_tmp"

            set +e
            (fetch "$url" "$tmpfile")
            result="$?"
            set -e

            if [ "$result" -ne 0 ]; then
                printf "Error while downloading '%s'\n" "$url" 1>&2
            else

                if [ "$target" = "archive" ]; then

                    set +e
                    (unpack "$tmpfile" "$pkg_dir")
                    result="$?"
                    set -e

                    if [ "$result" -ne 0 ]; then
                        printf "Error while extracting '%s'\n" "$tmpfile" 1>&2
                    fi

                    # If packeg is in dir "name-version", remove it
                    pkg_dir_sub=$pkg_dir/$pkg
                    if [ -d "$pkg_dir_sub" ] && [ "$(echo $pkg_dir/*/)" = "$pkg_dir_sub/" ]; then
                        printf "move %s -> %s\n" "$pkg_dir_sub" "$pkg_dir"
                        tmpdir=$sbpl_dir_tmp/$pkg
                        rm -rf $tmpdir
                        mv $pkg_dir_sub $tmpdir
                        mv $tmpdir $sbpl_dir_pkg
                    fi

                else
                    mkdir -p "$pkg_path"
                    chmod +x "$tmpfile"
                    mv "$tmpfile" "$pkg_path/$name"
                fi
            fi
        elif [ "$target" = "git" ]; then

            set +e
            (git clone "$url" "$pkg_dir")
            result=$?
            set -e

            if [ "$result" -ne 0 ]; then
                printf "Error while cloning repo '%s'\n" "$url" 1>&2
            else

                pushd "$pkg_dir" > /dev/null
                    set +e
                    (git checkout "$version")
                    result=$?
                    set -e
                popd  > /dev/null

                if [ "$result" -ne 0 ]; then
                    printf "Error while checking out branch/tag '%s'\n" "$version" 1>&2
                fi
            fi
        else
            printf "Unknown option $1\n"
            sbpl_usage
            result=2
        fi

        if [ "$result" -eq 0 ]; then
            mkdir -p "$sbpl_dir_bin"
            
            # if option is used
            if [ ! -z "$pkg_dir_bin" ]; then
                pkg_path_bin="$pkg_path/$pkg_dir_bin"

                # if "pkg_dir_bin" is a     select            and
                # file                      the file          add +x
                # dir                       executable files
                # search pattern            matching files    add +x
    
                if [ -d "$pkg_path_bin" ]; then
                    pkg_path_bin="$pkg_path_bin/*"
                    skip_x_filter=false
                else
                    skip_x_filter=true
                fi
    
                for f in $pkg_path_bin; do
                    if [ -f "$f" ] && ( [ -x "$f" ] || $skip_x_filter) ; then
                        ln -sf "$f" "$sbpl_dir_bin/."
                        if $skip_x_filter; then chmod +x "$f"; fi
                    fi
                done
            fi

            # Create current links
            current="$_sbpl_os/$_sbpl_arch"
            mkdir -p "$sbpl_dir_pkgs/$current"
            mkdir -p "$sbpl_dir_bins/$current"
            ln -fs "$current" "$sbpl_dir_pkgs/current"
            ln -fs "$current" "$sbpl_dir_bins/current"

            # Create Package link
            ln -fs "$pkg" "$sbpl_dir_pkg/$name"

            # Get sub packages
            if [ -z ${SBPL_NOSUBPKGS+x} ] || ! $SBPL_NOSUBPKGS; then
                pkg_pkgs="$pkg_dir/$sbpl_pkg"
                if [ -f "$pkg_pkgs" ]; then
                    source "$pkg_pkgs"
                fi
            fi

        else
            rm -rf $pkg_dir
        fi
    fi

    return $result

    }; get_pkg $@; return $?
}

function get_packages () {

    sbpl_pkg_lock="$sbpl_dir_pkgs/$sbpl_pkg.lock-$sbpl_os-$sbpl_arch"

    # Check pkg file
    if [ -f "$sbpl_pkg" ]; then

        # Check lock file & skip update if no changes
        if [ -f "$sbpl_pkg_lock" ] && [ "$(< "$sbpl_pkg")" = "$(< "$sbpl_pkg_lock")" ]; then
            return 0
        fi

        # Run pkg script
        "$PWD/$sbpl_pkg" | cat
        result=${PIPESTATUS[0]}

        # Clear tmp
        rm -rf "$sbpl_dir_tmps/*"

        # Update lock file
        if [ $result -eq 0 ]; then
            mkdir -p "$sbpl_dir_pkgs"
            cp -p "$sbpl_pkg" "$sbpl_pkg_lock"
        else
            rm -f "$sbpl_pkg_lock"
            printf "'sbpl-pkg.sh' failed with status $result\n"
            return $result
        fi
    else
        printf "'$sbpl_pkg' not found\n" 1>&2
        return 1
    fi

    return 0
}

function sbpl_test () {

    [ -z ${1+x} ] && testdir="." || testdir="$1"
    testdir="$([ "$testdir" != "${testdir#/}" ] && echo "$testdir" || echo "$PWD/$testdir")"

    PATH="$PWD/$sbpl_dir_bins/current:$testdir:$PATH"

    if [ -z ${2+x} ]; then
        if ! command -v bats &> /dev/null; then
            sbpl_get 'archive' 'bats' '0.4.0' 'https://github.com/sstephenson/bats/archive/v${version}.zip' 'bin'
        fi
        cmd="bats --tap ."
    else
        shift
        cmd="$@"
    fi

    pushd "$testdir" > /dev/null

    bin=${cmd%% *}
    if ! command -v $bin &> /dev/null; then
        printf "unknown command '$bin'\n"
        exit 2
    fi

    # Loop through test folders
    for subdir in test*/; do

        if [ ! -d "$subdir" ]; then continue; fi

        printf "[${subdir%/}]\n"

        pushd "./$subdir" > /dev/null
            $cmd
        popd > /dev/null

        printf "\n"
        done

    popd > /dev/null
}

function show_version () {

    printf "$sbpl_name - $sbpl_version\n"
    return 0
}

function usage () {

    printf "help    - print usage information\n"
    printf "update  - download packages\n"
    printf "upgrade - upgrade to latest sbpl version\n"
    printf "clean   - clear package dir\n"
    printf "version - print sbpl version information\n"
    printf "envvars - print vars used by sbpl. Pass a var name to filter the list\n"
    printf "get     - download package\n"
    printf "test    - run bats test in test folder\n"

    return 0
}

function unknown_option () {

    printf "$sbpl: Unknown option $1\n"
    printf "Use $sbpl help for help with command-line options,\n"
    printf "or see the online docs at https://github.com/octocraft/sbpl\n"
    return 2
}

function clean () {

    rm -rf $sbpl_dir_pkgs && mkdir -p $sbpl_dir_pkgs
    return $?
}

function upgrade () {

    # Update Locations
    sbpl_env

    sbpl_get 'file' 'sbpl' 'master' 'https://raw.githubusercontent.com/octocraft/${name}/${version}/sbpl.sh' './'

    mkdir -p "$sbpl_dir_tmp"
    cp "$sbpl_dir_bin/sbpl" "$sbpl_dir_tmp/sbpl.sh"
    mv "$sbpl_dir_tmp/sbpl.sh" "$sbpl"

    return 0
}

function init () {

    if [ -f "$sbpl_pkg" ]; then
        printf "$sbpl_pkg already exists\n"
        return 1
    fi

    printf "#!/bin/bash\nset -eu\n\n" > $sbpl_pkg
    printf "%s\n" '# Call sbpl_get to add dependencies, e.g:' >> $sbpl_pkg
    printf "%s\n" '#   sbpl_get '"'"'archive'"'"' '"'"'sbpl'"'"' '"'"'master'"'"' '"'"'https://github.com/octocraft/${name}/archive/${version}.zip'"'"'                '"'"'./${name}-${version}/bin/'"'" >> $sbpl_pkg
    printf "%s\n" '#   sbpl_get '"'"'file'"'"'    '"'"'sbpl'"'"' '"'"'master'"'"' '"'"'https://raw.githubusercontent.com/octocraft/${name}/${version}/${name}.sh'"'" >> $sbpl_pkg
    printf "%s\n" '#   sbpl_get '"'"'git'"'"'     '"'"'sbpl'"'"' '"'"'master'"'"' '"'"'https://github.com/octocraft/${name}.git'"'"'                                   '"'"'./bin/'"'" >> $sbpl_pkg
    printf "\n\n" >> $sbpl_pkg

    chmod u+x $sbpl_pkg

    return 0
}

function envvars () {

    function print_var () {
        var_name="$1"
        var_data="$(eval 'echo $'"$var_name")"

        if [ "$var_filter" = "$var_name" ]; then
            printf "%s\n" "$var_data"
        elif [ "$var_filter" = "*" ]; then
            printf "%s=\"%s\"\n" "$var_name" "$var_data"
        fi
    }

    # Update Locations
    sbpl_env

    if ! [ -z ${1+x} ]; then
        export var_filter="$1"
    else
        export var_filter="*"
    fi

    print_var "sbpl_os"
    print_var "_sbpl_os"
    print_var "sbpl_arch"
    print_var "_sbpl_arch"
    print_var "sbpl_version"

    print_var "sbpl_dir_pkgs"
    print_var "sbpl_dir_bins"
    print_var "sbpl_dir_tmps"

    print_var "sbpl_dir_pkg"
    print_var "sbpl_dir_bin"
    print_var "sbpl_dir_tmp"

    export sbpl_path_pkg="$PWD/$sbpl_dir_pkg"
    export sbpl_path_bin="$PWD/$sbpl_dir_bin"
    export sbpl_path_tmp="$PWD/$sbpl_dir_tmp"

    print_var "sbpl_path_pkg"
    print_var "sbpl_path_bin"
    print_var "sbpl_path_tmp"

    return 0
}

######################################

# Setup environment
export_platform_info

export -f sbpl_env
export -f sbpl_get

# Parse command line arguments
if ! [ -z ${1+x} ]; then

    cmd=$1
    shift;

    case "$cmd" in
        help*)      usage $@;           result=$?; ;;
        update*)    get_packages $@;    result=$?; ;;
        upgrade*)   upgrade $@;         result=$?; ;;
        clean*)     clean $@;           result=$?; ;;
        version*)   show_version $@;    result=$?; ;;
        init*)      init $@;            result=$?; ;;
        envvars*)   envvars $@;         result=$?; ;;
        get*)       sbpl_get $@;        result=$?; ;;
        test*)      sbpl_test $@;       result=$?; ;;
        *)   unknown_option $cmd $@;    result=$?; ;;
    esac;
else
                    get_packages $@;    result=$?;
fi

# Return
exit $result
