unit module PSFMDDLC::AST;

class Import is export {
  has Str $.text;
}

class Method is export {
  has Str $.name;
  has Str @.params;
  has Str $.return;
}

class Algebra is export {
  has Str $.name;
  has Method @.methods;
}

class Module is export {
  has Str $.name;
  has Import @.imports;
  has Algebra @.algebras;
}
