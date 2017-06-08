unit module PSFMDDLC::Parse;

use PSFMDDLC::AST;

grammar Grammar {
  rule TOP {
    'module' $<name>=<verbatim> ';'
    $<imports>=<import>*
    $<algebras>=<algebra>*
  }

  rule import {
    'import' $<text>=<verbatim> ';'
  }

  rule algebra {
    'algebra' $<name>=<ident>
    '{' $<methods>=<method>* '}'
  }

  rule method {
    'method' $<name>=<ident>
    '(' [$<params>=<verbatim>]* %% ',' ')'
    ':' $<return>=<verbatim>
    ';'
  }

  token ident {
    <[A .. Z a .. z 0 .. 9]>+
  }

  token verbatim {
    [ <-[,;()]> | '(' <verbatim-inner> ')' ]+
  }

  token verbatim-inner {
    [ <-[()]> | '(' <verbatim-inner> ')' ]+
  }
}

class Actions {
  method TOP($/) {
    make Module.new(
      name => ~$<name>,
      imports => $<imports>».made,
      algebras => $<algebras>».made,
    );
  }

  method import($/) {
    make Import.new(
      text => ~$<text>,
    );
  }

  method algebra($/) {
    make Algebra.new(
      name => ~$<name>,
      methods => $<methods>».made,
    );
  }

  method method($/) {
    make Method.new(
      name => ~$<name>,
      params => $<params>».Str,
      return => ~$<return>,
    );
  }
}

sub parse($target) is export {
  Grammar.parse($target, actions => Actions).made;
}
