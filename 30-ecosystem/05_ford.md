# Documentation with FORD

[FORD](https://github.com/Fortran-FOSS-Programmers/ford) generates HTML
documentation (procedure pages, call graphs, module dependency graphs,
source listings, search) from Fortran sources and doc comments.

```sh
pip install ford
ford project.md          # writes ./doc/index.html
```

`project.md` holds the settings as YAML front matter, followed by a
Markdown front page:

```markdown
---
project: Geometry
author: Drunk Monoid
src_dir: ./src
output_dir: ./doc
docmark: !          # `!!` comments document the entity above
predocmark: >       # `!>` comments document the entity below
display: public
         protected
graph: true
search: true
---

Geometry utilities. See the module pages for details.
```

Doc-comment conventions (see [05_ford_documented.f90](05_ford_documented.f90)):

| Comment | Documents |
|---|---|
| `!> text` before an entity | the entity that follows |
| `!! text` after an entity | the entity just declared |
| Markdown, `$\LaTeX$` math, `@note`, `@warning`, `@todo` | inside doc comments |

fpm users can run FORD on the `src/` directory directly; CMake projects
usually add a custom `doc` target that calls `ford`.
