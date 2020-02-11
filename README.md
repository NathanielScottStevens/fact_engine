# FactEngine

## Development Notes
* I debated between designing this project as an application or an escript.
Ultimately, it felt like using a genserver was a little much for such a 
simple application.
* My parser is a little hacky doing things like just removing all parens instead
of using traditional parsing algorithms. But I think the simplicity makes sense in
this scenario.
* Are the arguments given order dependent? Such that:
`INPUT are_friends (alex, sam)`
`QUERY are_friends (alex, X)`
would return sam but
`QUERY are_friends (X, alex)`
would return false?
I assumed that they were not, however, after seeing example 4
it seems like it would be quite difficult to complete this in a sane
way otherwise.
* If the queries are order dependent you could a macro with pattern matching
to see whether a query was true and easily return the matches
