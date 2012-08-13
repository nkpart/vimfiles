" Scala {{{3
let type_scala = {}
let type_scala.ctagstype = 'Scala'
let type_scala.kinds     = [
  \ 'p:packages:1',
  \ 'V:values:0',
  \ 'v:variables:0',
  \ 'T:types:0',
  \ 't:traits:0',
  \ 'o:objects:0',
  \ 'a:aclasses:0',
  \ 'c:classes:0',
  \ 'r:cclasses:0',
  \ 'm:methods:0'
\ ]
let type_scala.sro        = '.'
let type_scala.kind2scope = {
  \ 'T' : 'type',
  \ 't' : 'trait',
  \ 'o' : 'object',
  \ 'a' : 'abstract class',
  \ 'c' : 'class',
  \ 'r' : 'case class'
\ }
let type_scala.scope2kind = {
  \ 'type'           : 'T',
  \ 'trait'          : 't',
  \ 'object'         : 'o',
  \ 'abstract class' : 'a',
  \ 'class'          : 'c',
  \ 'case class'     : 'r'
\ }

let g:tagbar_type_scala = type_scala
" 
" let s:known_types.scala = type_scala
"     let g:tagbar_type_haskell = {
"         \ 'ctagsbin' : 'lushtags',
"         \ 'ctagsargs' : '--ignore-parse-error --',
"         \ 'kinds' : [
"             \ 'm:module:0',
"             \ 'e:exports:1',
"             \ 'i:imports:1',
"             \ 't:declarations:0',
"             \ 'd:declarations:1',
"             \ 'n:declarations:1',
"             \ 'f:functions:0',
"             \ 'c:constructors:0'
"         \ ],
"         \ 'sro' : '.',
"         \ 'kind2scope' : {
"             \ 'd' : 'data',
"             \ 'n' : 'newtype',
"             \ 'c' : 'constructor',
"             \ 't' : 'type'
"         \ },
"         \ 'scope2kind' : {
"             \ 'data' : 'd',
"             \ 'newtype' : 'n',
"             \ 'constructor' : 'c',
"             \ 'type' : 't'
"         \ }
"     \ }
