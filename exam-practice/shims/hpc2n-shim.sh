# Imitation of the Lmod "module" command for the exam-practice image.
# It only knows the modules used in the course materials. It is not Lmod.
# Sourced for interactive shells (/etc/bash.bashrc) and for batch jobs (BASH_ENV).

__PRACTICE_MODULES="GCC/14.2.0 OpenMPI/5.0.7 BLAST+/2.17.0 GCCcore/14.3.0 git/2.50.1 cURL/8.14.1"
__BLAST_BIN="/opt/blast/bin"

__mod_known()  { case " $__PRACTICE_MODULES " in *" $1 "*) return 0;; esac; return 1; }
__mod_loaded() { case ":${LOADEDMODULES:-}:" in *":$1:"*) return 0;; esac; return 1; }

__mod_path_add() { case ":$PATH:" in *":$1:"*) ;; *) PATH="$1:$PATH";; esac; export PATH; }
__mod_path_del() { PATH=":$PATH:"; PATH="${PATH//:$1:/:}"; PATH="${PATH#:}"; PATH="${PATH%:}"; export PATH; }

__mod_load() {
    local m="$1" k req=""
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
    case "$m" in
        BLAST+/2.17.0) req="GCC/14.2.0 OpenMPI/5.0.7";;
    esac
    for k in $req; do
        if ! __mod_loaded "$k"; then
            echo "module (practice image): \"$m\" is not available to load yet." >&2
            echo "You will need to load all module(s) on any one of the lines below before the \"$m\" module is available to load." >&2
            echo "  $req" >&2
            return 1
        fi
    done
    LOADEDMODULES="${LOADEDMODULES:+$LOADEDMODULES:}$m"; export LOADEDMODULES
    case "$m" in BLAST+/2.17.0) __mod_path_add "$__BLAST_BIN";; esac
}

__mod_unload() {
    local m="$1" out="" x
    for x in ${LOADEDMODULES//:/ }; do [ "$x" = "$m" ] || out="${out:+$out:}$x"; done
    LOADEDMODULES="$out"; export LOADEDMODULES
    case "$m" in BLAST+/2.17.0) __mod_path_del "$__BLAST_BIN";; esac
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
        avail|av|spider)
            echo "Modules known to this practice image:"
            for x in $__PRACTICE_MODULES; do echo "  $x"; done
            echo "BLAST+/2.17.0 needs GCC/14.2.0 and OpenMPI/5.0.7 loaded first."
            echo "(Imitation of Lmod. On Kebnekaise use the real module system.)";;
        *)
            echo "module (practice image) supports: load, unload, purge, list, avail, spider" >&2
            return 1;;
    esac
}

ml() { if [ $# -eq 0 ]; then module list; else module load "$@"; fi; }

export -f module ml __mod_known __mod_loaded __mod_path_add __mod_path_del __mod_load __mod_unload 2>/dev/null
export __PRACTICE_MODULES __BLAST_BIN
