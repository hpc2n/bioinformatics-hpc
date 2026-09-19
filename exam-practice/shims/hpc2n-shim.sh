# Imitation of the Lmod "module" command for the exam-practice image.
# It only knows the modules used in the course materials. It is not Lmod.
# Sourced for interactive shells (/etc/bash.bashrc) and for batch jobs (BASH_ENV).

__PRACTICE_MODULES="GCC/13.2.0 GCC/13.3.0 GCC/14.2.0 GCC/14.3.0 GCCcore/14.3.0 OpenMPI/5.0.7 BLAST+/2.17.0 SAMtools/1.22 BCFtools/1.19 BEDTools/2.31.1 git/2.50.1 cURL/8.14.1"

# Modules that must already be loaded. Alternatives are separated by "|" (any one line is enough).
# These prerequisites were read from "module spider" on Kebnekaise.
__mod_needs() {
    case "$1" in
        BLAST+/2.17.0)   echo "GCC/14.2.0 OpenMPI/5.0.7";;
        SAMtools/1.22)   echo "GCC/14.2.0";;
        BCFtools/1.19)   echo "GCC/13.2.0";;
        BEDTools/2.31.1) echo "GCC/13.3.0|GCC/14.3.0";;
    esac
}

# The directory a module adds to PATH
__mod_bin() {
    case "$1" in
        BLAST+/2.17.0)   echo "/opt/blast/bin";;
        SAMtools/1.22)   echo "/opt/tools/samtools/bin";;
        BCFtools/1.19)   echo "/opt/tools/bcftools/bin";;
        BEDTools/2.31.1) echo "/opt/tools/bedtools/bin";;
    esac
}

__mod_known()  { case " $__PRACTICE_MODULES " in *" $1 "*) return 0;; esac; return 1; }
__mod_loaded() { case ":${LOADEDMODULES:-}:" in *":$1:"*) return 0;; esac; return 1; }

__mod_path_add() { case ":$PATH:" in *":$1:"*) ;; *) PATH="$1:$PATH";; esac; export PATH; }
__mod_path_del() { PATH=":$PATH:"; PATH="${PATH//:$1:/:}"; PATH="${PATH#:}"; PATH="${PATH%:}"; export PATH; }

__mod_load() {
    local m="$1" k alt ok=0 needs bin
    if ! __mod_known "$m"; then
        for k in $__PRACTICE_MODULES; do
            if [ "${k%%/*}" = "$m" ]; then
                echo "module (practice image): give the full name, for example: module load $k" >&2
                return 1
            fi
        done
        echo "module (practice image): unknown module \"$m\"." >&2
        echo "This image only knows the modules used in the course materials:" >&2
        echo "  $__PRACTICE_MODULES" >&2
        return 1
    fi
    __mod_loaded "$m" && return 0
    needs=$(__mod_needs "$m")
    if [ -n "$needs" ]; then
        local alts r all
        IFS='|' read -ra alts <<<"$needs"
        for alt in "${alts[@]}"; do
            all=1
            for r in $alt; do __mod_loaded "$r" || all=0; done
            [ $all -eq 1 ] && ok=1
        done
        if [ $ok -eq 0 ]; then
            echo "module (practice image): \"$m\" is not available to load yet." >&2
            echo "You will need to load all module(s) on any one of the lines below before the \"$m\" module is available to load." >&2
            printf '  %s\n' "${alts[@]}" >&2
            return 1
        fi
    fi
    LOADEDMODULES="${LOADEDMODULES:+$LOADEDMODULES:}$m"; export LOADEDMODULES
    bin=$(__mod_bin "$m"); [ -n "$bin" ] && __mod_path_add "$bin"
    return 0
}

__mod_unload() {
    local m="$1" out="" x bin
    for x in ${LOADEDMODULES//:/ }; do [ "$x" = "$m" ] || out="${out:+$out:}$x"; done
    LOADEDMODULES="$out"; export LOADEDMODULES
    bin=$(__mod_bin "$m"); [ -n "$bin" ] && __mod_path_del "$bin"
    return 0
}

__mod_spider() {
    local q="$1" k name n found=0
    for k in $__PRACTICE_MODULES; do
        name="${k%%/*}"
        if [ "$q" = "$k" ] || [ "$q" = "$name" ]; then
            found=1
            echo "----------------------------------------------------------------------------"
            echo "  $name: $k"
            echo "----------------------------------------------------------------------------"
            n=$(__mod_needs "$k")
            if [ -n "$n" ]; then
                echo "    You will need to load all module(s) on any one of the lines below before the \"$k\" module is available to load."
                echo
                echo "$n" | tr '|' '\n' | sed 's/^/      /'
            fi
            echo
        fi
    done
    [ $found -eq 1 ] || { echo "module (practice image): unable to find \"$q\". Known modules: $__PRACTICE_MODULES" >&2; return 1; }
}

__mod_show() {
    local m="$1" n b
    __mod_known "$m" || { echo "module (practice image): unknown module \"$m\"" >&2; return 1; }
    n=$(__mod_needs "$m"); b=$(__mod_bin "$m")
    echo "Practice image module: $m"
    [ -n "$n" ] && echo "  Load first: $(echo "$n" | sed 's/|/  or  /g')"
    [ -n "$b" ] && echo "  prepend_path(\"PATH\", \"$b\")"
    return 0
}

module() {
    local cmd="${1:-help}" m rc=0 i=1 x
    [ $# -gt 0 ] && shift
    case "$cmd" in
        load|add)
            for m in "$@"; do __mod_load "$m" || rc=1; done
            return $rc;;
        unload|rm|del)
            for m in "$@"; do __mod_unload "$m"; done;;
        purge)
            for m in ${LOADEDMODULES//:/ }; do __mod_unload "$m"; done;;
        list)
            if [ -z "${LOADEDMODULES:-}" ]; then
                echo "No modules loaded"
            else
                echo "Currently Loaded Modules:"
                for x in ${LOADEDMODULES//:/ }; do printf '  %d) %s\n' "$i" "$x"; i=$((i+1)); done
            fi;;
        spider)
            if [ $# -gt 0 ]; then __mod_spider "$1"; return $?; fi
            module avail;;
        show|display)
            for m in "$@"; do __mod_show "$m" || rc=1; done
            return $rc;;
        save)
            mkdir -p "$HOME/.module_collections"; echo "${LOADEDMODULES:-}" > "$HOME/.module_collections/${1:-default}"
            echo "Saved the loaded modules as \"${1:-default}\"";;
        restore)
            [ -f "$HOME/.module_collections/${1:-default}" ] || { echo "module (practice image): no saved collection \"${1:-default}\"" >&2; return 1; }
            module purge
            for m in $(tr ':' ' ' < "$HOME/.module_collections/${1:-default}"); do module load "$m" || rc=1; done
            return $rc;;
        avail|av)
            echo "Modules known to this practice image:"
            for x in $__PRACTICE_MODULES; do
                local n; n=$(__mod_needs "$x")
                if [ -n "$n" ]; then echo "  $x   (load first: $(echo "$n" | sed 's/|/  or  /g'))"; else echo "  $x"; fi
            done
            echo "(Imitation of Lmod. On Kebnekaise use the real module system.)";;
        *)
            echo "module (practice image) supports: load, unload, purge, list, avail, spider, show, save, restore" >&2
            return 1;;
    esac
}

ml() {
    case "${1:-}" in
        "") module list;;
        purge|list|av|avail|spider|show|save|restore|unload|rm) module "$@";;
        -?*) local m; for m in "$@"; do module unload "${m#-}"; done;;
        *) module load "$@";;
    esac
}

export -f module ml __mod_spider __mod_show __mod_needs __mod_bin __mod_known __mod_loaded __mod_path_add __mod_path_del __mod_load __mod_unload 2>/dev/null
export __PRACTICE_MODULES
