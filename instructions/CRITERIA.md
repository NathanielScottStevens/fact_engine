# Marking Criteria

## Overall

1. Were you able to run the candidate's code on your computer?
1. Did their code produce the expected output? (things like newlines
   or minor formatting, while nice to get exactly right, don't need to
   be dealbreakers, especially for more junior candidates)
1. How does their code handle things like:
   1. Blank lines
   1. Unparseable lines
   1. Queries on undefined relations
   1. Unsatisfiable queries with variables
   1. Queries that feature the same variable more than once (eg
      `foo (X, bar, X)` vs `foo (X, bar, Y)`)

## API Design

1. (required) Does the application accept a text file as input?
1. (optional) Does the application accept input from stdin? Interactive mode?
1. How does the application handle being called with the wrong arguments?
1. Does the application display a help message?

## Performance

1. How performant is the solution? Were any attempts made to improve
   performance?
1. What are the main data structures used? Are there any polynomial-time
   calls involved?

## Code Quality (Structure / Readability / Maintainability)

1. Did the candidate structure their code for the problem well? Was
   there a separation between input handling and core business logic?
1. How long are the methods / functions defined? Are there are places
   where the candidate should have taken a more modular approach to their
   code?
1. Did the candidate implement tests for their approach? If so, do the
   tests given adequately test the solution?
1. In the case that the candidate used an OO language, is there a good understanding
   of classes and heirarchy? Did they use any specific OO patterns?
1. In the case that the candidate used Elixir, is there a good understand
   of pattern matching and multiple function heads? Did they use recursion?
1. Is the code documented in anyway? If so, is it documentation that
   helps you understand the solution or
   points out the obvious?
1. Is it easy for you (modulo your understanding of the target language)
   to read through the application source?
