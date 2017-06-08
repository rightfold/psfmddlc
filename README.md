# psfmddlc

PureScript Free Monad DSL Definition Language Compiler. Write no more free
monad DSL boilerplate code!

Example usage:

```
$ cat example/Console.psfmddl
module System.Console.Algebra;

import Control.Monad.Eff.Exception (Error);
import Data.Either (Either);
import Prelude;

algebra Console {
  method readLine(): Either Error String;
  method writeLine(Int, String): Either Error Unit;
}
$ psfmddlc example/Console.psfmddl
module System.Console.Algebra where
import Control.Monad.Free (Free, liftF) as PSFMDDL
import Prelude (($)) as PSFMDDL
import Control.Monad.Eff.Exception (Error)
import Data.Either (Either)
import Prelude
data Console a
  = ReadLine
      ((Either Error String) -> a)
  | WriteLine
      (Int)
      (String)
      ((Either Error Unit) -> a)
readLine :: PSFMDDL.Free Console (Either Error String)
readLine = PSFMDDL.liftF PSFMDDL.$ ReadLine id
writeLine :: (Int) -> (String) -> PSFMDDL.Free Console (Either Error Unit)
writeLine var_a var_b = PSFMDDL.liftF PSFMDDL.$ WriteLine var_a var_b id
```
