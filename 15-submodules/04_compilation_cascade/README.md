# Compilation cascades

Without submodules, editing the body of any procedure in a module rewrites
the `.mod` file (on many compilers) and every file that `use`s the module —
directly or indirectly — must be recompiled. In large codes one edit can
trigger a rebuild of almost everything.

With submodules the module holds only interfaces. Implementation edits
touch the `.smod`/`.o` of the submodule only; users depend on the `.mod`,
which stays identical. `build.sh` proves this by checksumming
`geometry.mod` before and after switching algorithms.

Run it with `scripts/run.sh 15-submodules/04_compilation_cascade/`.
