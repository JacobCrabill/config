syntax keyword EosNamespace namespace
syntax keyword EosStruct struct enum
syntax keyword EosBuiltin uint8 uint16 uint32 uint64
syntax keyword EosBuiltin int8 int16 int32 int64
syntax keyword EosBuiltin float32 float64 bool string
syntax keyword EosBuiltin list oneof any optional map unordered_map time

syntax match EosOperator "[{}\(\)\[\]:;]"

syntax match EosDoxyString "(?<!;)$" contained " Match everything but a trailing ';'
syntax match EosDoxyTag "@[a-zA-z0-0]* "
syntax region EosDoxy start="@brief"hs=s+6 end=";" contains=EosDoxyTag,EosDoxyString,EosOperator keepend

syntax region EosComment start="//" skip="\\$" end="$" keepend

hi def link EosDoxyTag PreProc
hi def link EosDoxyString Comment
hi def link EosDoxy String
hi def link EosComment Comment
hi def link EosNamespace Statement
hi def link EosStruct Structure
hi def link EosBuiltin Constant
hi def link EosOperator Operator
