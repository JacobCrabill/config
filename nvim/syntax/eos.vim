syntax keyword EosNamespace namespace
syntax keyword EosStruct struct enum
syntax keyword EosBuiltin uint8 uint16 uint32 uint64
syntax keyword EosBuiltin int8 int16 int32 int64
syntax keyword EosBuiltin float32 float64 bool string
syntax keyword EosBuiltin list oneof any optional map unordered_map time

syntax match EosOperator "[{}\(\)\[\]:;<>]"

syntax region EosComment start="//" skip="\\$" end="$" keepend

" Doc-comments start with '@tag' and end with ';'
syntax match EosDoxyString "(?<!;)$" contained " Match everything but a trailing ';'
syntax match EosDoxyTag "@[a-zA-z0-0]*"
syntax match EosDoxyEnd ";$"
syntax region EosDoxy start="@"hs=s+1 end=";" contains=EosDoxyTag,EosDoxyString,EosDoxyEnd keepend

" Include directives
syntax match EosIncludeKw "#include"
syntax match EosIncludeFile "^<.*>$"
syntax region EosInclude start="#include"hs=s+8 end="$" contains=EosIncludeKw,EosIncludeFile keepend

" syntax match EosFieldDecl "^[a-zA-Z][a-zA-Z0-9]*(?<!:)"
" syntax region EosFieldDeclStmt start="[a-zA-Z]" end="(: )" contains=EosFieldDecl keepend

" Link EOS syntax groups to Vim highlight groups

hi def link EosDoxyTag PreProc
hi def link EosDoxyString Comment
hi def link EosDoxyEnd PreProc
hi def link EosDoxy String

hi def link EosComment Comment

hi def link EosBuiltin Type
hi def link EosOperator Operator

hi def link EosNamespace Statement
hi def link EosStruct Structure

hi def link EosIncludeKw PreProc
hi def link EosIncludeFile String
hi def link EosInclude String

" hi def link EosFieldDecl Type
" hi def link EosFieldDeclStmt Type
