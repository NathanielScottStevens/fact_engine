# FactEngine

## Development Notes
* I debated between designing this project as an application or an escript.
Ultimately, it felt like using a genserver was a little much for such a 
simple application.
* My parser is a little hacky doing things like just removing all parens instead
of using traditional parsing algorithms. But I think the simplicity makes sense in
this scenario.
