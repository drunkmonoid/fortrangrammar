# Multi-file build

```
constants.f90  ──►  physics.f90  ──►  main.f90
```

A file that `use`s a module can only be compiled after that module, because
the compiler reads the module's `.mod` file. Build systems (Make, CMake,
fpm — chapter 30) work out this order automatically by scanning `use`
statements. Circular `use` between modules is impossible; break cycles with
submodules (chapter 15) or by moving shared parts into a lower module.

Run it with `scripts/run.sh 14-modules/08_multi_file/`.

`.mod` files are compiler-specific (and often compiler-*version*-specific):
never commit or ship them; ship sources or a library plus build recipe.
