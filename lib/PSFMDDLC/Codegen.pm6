unit module PSFMDDLC::Codegen;

use PSFMDDLC::AST;

sub vars(Int:D $n) {
  ('a' .. *)[^$n].map('var_' ~ *);
}

proto codegen(Any $node) is export {*}

multi codegen(Module:D $node) {
  say 'module ', $node.name, ' where';
  say 'import Control.Monad.Free (Free, liftF) as PSFMDDL';
  say 'import Prelude (($)) as PSFMDDL';
  codegen($_) for $node.imports;
  codegen($_) for $node.algebras;
}

multi codegen(Import:D $node) {
  say 'import ', $node.text;
}

multi codegen(Algebra:D $node) {
  my $*algebra = $node;
  say 'data ', $node.name, ' a';
  for $node.methods.kv -> $i, $method {
    say '  ', <| =>[$i == 0], ' ', $method.name.tc;
    say '      (', $_, ')' for $method.params;
    say '      ((', $method.return, ') -> a)';
  }
  codegen($_) for $node.methods;
}

multi codegen(Method:D $node) {
  say $node.name, ' :: ',
      $node.params.map('(' ~ * ~ ') -> ').join,
      'PSFMDDL.Free ', $*algebra.name, ' (', $node.return, ')';
  say $node.name, vars($node.params.elems).map(' ' ~ *).join, ' = ',
      'PSFMDDL.liftF PSFMDDL.$ ',
      $node.name.tc, vars($node.params.elems).map(' ' ~ *).join, ' id';
}
