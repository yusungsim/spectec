# Preview

```sh
$ for v in 1 2 3; do ( \
>   echo "Generating prose for Wasm $v.0..." && \
>   cd ../spec/wasm-$v.0 && \
>   ../../src/exe-watsup/main.exe *.watsup -v -l --prose \
> ) done
Generating prose for Wasm 1.0...
watsup 0.4 generator
== Parsing...
== Elaboration...
== IL Validation...
== Running pass sideconditions...
== IL Validation after pass sideconditions...
== Running pass animate...
== IL Validation after pass animate...
== Translating to AL...
== Prose Generation...
=================
 Generated prose
=================
validation_of_UNREACHABLE
- The instruction is valid with type (t_1* -> t_2*).

validation_of_NOP
- The instruction is valid with type ([] -> []).

validation_of_DROP
- The instruction is valid with type ([t] -> []).

validation_of_SELECT ?()
- The instruction is valid with type ([t, t, I32] -> [t]).

validation_of_BLOCK t? instr*
- Under the context C with .LABEL prepended by [t?], instr* must be valid with type ([] -> t?).
- The instruction is valid with type ([] -> t?).

validation_of_LOOP t? instr*
- Under the context C with .LABEL prepended by [?()], instr* must be valid with type ([] -> []).
- The instruction is valid with type ([] -> t?).

validation_of_IF t? instr_1* instr_2*
- Under the context C with .LABEL prepended by [t?], instr_1* must be valid with type ([] -> t?).
- Under the context C with .LABEL prepended by [t?], instr_2* must be valid with type ([] -> t?).
- The instruction is valid with type ([I32] -> t?).

validation_of_BR l
- |C.LABEL| must be greater than l.
- Let t? be C.LABEL[l].
- The instruction is valid with type (t_1* ++ t? -> t_2*).

validation_of_BR_IF l
- |C.LABEL| must be greater than l.
- Let t? be C.LABEL[l].
- The instruction is valid with type (t? ++ [I32] -> t?).

validation_of_BR_TABLE l* l'
- |C.LABEL| must be greater than l'.
- For all l in l*,
  - |C.LABEL| must be greater than l.
- For all l in l*,
  - Let t? be C.LABEL[l].
- t? must be equal to C.LABEL[l'].
- The instruction is valid with type (t_1* ++ t? -> t_2*).

validation_of_RETURN
- Let ?(t?) be C.RETURN.
- The instruction is valid with type (t_1* ++ t? -> t_2*).

validation_of_CALL x
- |C.FUNC| must be greater than x.
- Let (t_1* -> t_2?) be C.FUNC[x].
- The instruction is valid with type (t_1* -> t_2?).

validation_of_CALL_INDIRECT x
- |C.TYPE| must be greater than x.
- Let (t_1* -> t_2?) be C.TYPE[x].
- The instruction is valid with type (t_1* ++ [I32] -> t_2?).

validation_of_CONST t c_t
- The instruction is valid with type ([] -> [t]).

validation_of_UNOP t unop_t
- The instruction is valid with type ([t] -> [t]).

validation_of_BINOP t binop_t
- The instruction is valid with type ([t, t] -> [t]).

validation_of_TESTOP t testop_t
- The instruction is valid with type ([t] -> [I32]).

validation_of_RELOP t relop_t
- The instruction is valid with type ([t, t] -> [I32]).

validation_of_CVTOP t_1 REINTERPRET t_2 ?()
- t_1 must be different with t_2.
- $size(t_1) must be equal to $size(t_2).
- The instruction is valid with type ([t_2] -> [t_1]).

validation_of_CVTOP inn_1 CONVERT inn_2 sx?
- inn_1 must be different with inn_2.
- (($size(inn_1) > $size(inn_2))) and ((sx? is ?())) are equivalent.
- The instruction is valid with type ([inn_2] -> [inn_1]).

validation_of_LOCAL.GET x
- |C.LOCAL| must be greater than x.
- Let t be C.LOCAL[x].
- The instruction is valid with type ([] -> [t]).

validation_of_LOCAL.SET x
- |C.LOCAL| must be greater than x.
- Let t be C.LOCAL[x].
- The instruction is valid with type ([t] -> []).

validation_of_LOCAL.TEE x
- |C.LOCAL| must be greater than x.
- Let t be C.LOCAL[x].
- The instruction is valid with type ([t] -> [t]).

validation_of_GLOBAL.GET x
- |C.GLOBAL| must be greater than x.
- Let (mut, t) be C.GLOBAL[x].
- The instruction is valid with type ([] -> [t]).

validation_of_GLOBAL.SET x
- |C.GLOBAL| must be greater than x.
- Let ((MUT ?(())), t) be C.GLOBAL[x].
- The instruction is valid with type ([t] -> []).

validation_of_MEMORY.SIZE
- |C.MEM| must be greater than 0.
- Let mt be C.MEM[0].
- The instruction is valid with type ([] -> [I32]).

validation_of_MEMORY.GROW
- |C.MEM| must be greater than 0.
- Let mt be C.MEM[0].
- The instruction is valid with type ([I32] -> [I32]).

validation_of_LOAD t (n, sx)? { ALIGN: n_A; OFFSET: n_O; }
- |C.MEM| must be greater than 0.
- ((sx? is ?())) and ((n? is ?())) are equivalent.
- (2 ^ n_A) must be less than or equal to ($size(t) / 8).
- If n is defined,
  - (2 ^ n_A) must be less than or equal to (n / 8).
  - (n / 8) must be less than ($size(t) / 8).
- n? must be equal to ?().
- Let mt be C.MEM[0].
- The instruction is valid with type ([I32] -> [t]).

validation_of_STORE t n? { ALIGN: n_A; OFFSET: n_O; }
- |C.MEM| must be greater than 0.
- (2 ^ n_A) must be less than or equal to ($size(t) / 8).
- If n is defined,
  - (2 ^ n_A) must be less than or equal to (n / 8).
  - (n / 8) must be less than ($size(t) / 8).
- n? must be equal to ?().
- Let mt be C.MEM[0].
- The instruction is valid with type ([I32, t] -> []).

Ki
1. Return 1024.

min n_u0 n_u1
1. If (n_u0 is 0), then:
  a. Return 0.
2. If (n_u1 is 0), then:
  a. Return 0.
3. Assert: Due to validation, (n_u0 ≥ 1).
4. Let i be (n_u0 - 1).
5. Assert: Due to validation, (n_u1 ≥ 1).
6. Let j be (n_u1 - 1).
7. Return $min(i, j).

sum n_u0*
1. If (n_u0* is []), then:
  a. Return 0.
2. Let [n] ++ n'* be n_u0*.
3. Return (n + $sum(n'*)).

concat_ X_u0*
1. If (X_u0* is []), then:
  a. Return [].
2. Let [w*] ++ w'** be X_u0*.
3. Return w* ++ $concat_(w'**).

signif N_u0
1. If (N_u0 is 32), then:
  a. Return 23.
2. Assert: Due to validation, (N_u0 is 64).
3. Return 52.

expon N_u0
1. If (N_u0 is 32), then:
  a. Return 8.
2. Assert: Due to validation, (N_u0 is 64).
3. Return 11.

M N
1. Return $signif(N).

E N
1. Return $expon(N).

fzero N
1. Return (POS (SUBNORM 0)).

fone N
1. Return (POS (NORM 1 0)).

canon_ N
1. Return (2 ^ ($signif(N) - 1)).

size valty_u0
1. If (valty_u0 is I32), then:
  a. Return 32.
2. If (valty_u0 is I64), then:
  a. Return 64.
3. If (valty_u0 is F32), then:
  a. Return 32.
4. If (valty_u0 is F64), then:
  a. Return 64.

memop0
1. Return { ALIGN: 0; OFFSET: 0; }.

signed N i
1. If (0 ≤ (2 ^ (N - 1))), then:
  a. Return i.
2. Assert: Due to validation, ((2 ^ (N - 1)) ≤ i).
3. Assert: Due to validation, (i < (2 ^ N)).
4. Return (i - (2 ^ N)).

invsigned N ii
1. Let j be $inverse_of_signed(N, ii).
2. Return j.

unop valty_u1 unop__u0 val__u2
1. If (unop__u0 is CLZ), then:
  a. Let iN be val__u2.
  b. If the type of valty_u1 is inn, then:
    1) Let inn be valty_u1.
    2) Return [$iclz($size(inn), iN)].
2. If (unop__u0 is CTZ), then:
  a. Let iN be val__u2.
  b. If the type of valty_u1 is inn, then:
    1) Let inn be valty_u1.
    2) Return [$ictz($size(inn), iN)].
3. If (unop__u0 is POPCNT), then:
  a. Let iN be val__u2.
  b. If the type of valty_u1 is inn, then:
    1) Let inn be valty_u1.
    2) Return [$ipopcnt($size(inn), iN)].
4. If (unop__u0 is ABS), then:
  a. Let fN be val__u2.
  b. If the type of valty_u1 is fnn, then:
    1) Let fnn be valty_u1.
    2) Return [$fabs($size(fnn), fN)].
5. If (unop__u0 is NEG), then:
  a. Let fN be val__u2.
  b. If the type of valty_u1 is fnn, then:
    1) Let fnn be valty_u1.
    2) Return [$fneg($size(fnn), fN)].
6. If (unop__u0 is SQRT), then:
  a. Let fN be val__u2.
  b. If the type of valty_u1 is fnn, then:
    1) Let fnn be valty_u1.
    2) Return [$fsqrt($size(fnn), fN)].
7. If (unop__u0 is CEIL), then:
  a. Let fN be val__u2.
  b. If the type of valty_u1 is fnn, then:
    1) Let fnn be valty_u1.
    2) Return [$fceil($size(fnn), fN)].
8. If (unop__u0 is FLOOR), then:
  a. Let fN be val__u2.
  b. If the type of valty_u1 is fnn, then:
    1) Let fnn be valty_u1.
    2) Return [$ffloor($size(fnn), fN)].
9. If (unop__u0 is TRUNC), then:
  a. Let fN be val__u2.
  b. If the type of valty_u1 is fnn, then:
    1) Let fnn be valty_u1.
    2) Return [$ftrunc($size(fnn), fN)].
10. Assert: Due to validation, (unop__u0 is NEAREST).
11. Let fN be val__u2.
12. Assert: Due to validation, the type of valty_u1 is fnn.
13. Let fnn be valty_u1.
14. Return [$fnearest($size(fnn), fN)].

binop valty_u1 binop_u0 val__u2 val__u3
1. If (binop_u0 is ADD), then:
  a. Let iN_1 be val__u2.
  b. Let iN_2 be val__u3.
  c. If the type of valty_u1 is inn, then:
    1) Let inn be valty_u1.
    2) Return [$iadd($size(inn), iN_1, iN_2)].
2. If (binop_u0 is SUB), then:
  a. Let iN_1 be val__u2.
  b. Let iN_2 be val__u3.
  c. If the type of valty_u1 is inn, then:
    1) Let inn be valty_u1.
    2) Return [$isub($size(inn), iN_1, iN_2)].
3. If (binop_u0 is MUL), then:
  a. Let iN_1 be val__u2.
  b. Let iN_2 be val__u3.
  c. If the type of valty_u1 is inn, then:
    1) Let inn be valty_u1.
    2) Return [$imul($size(inn), iN_1, iN_2)].
4. Let iN_1 be val__u2.
5. Let iN_2 be val__u3.
6. If the type of valty_u1 is inn, then:
  a. Let inn be valty_u1.
  b. If binop_u0 is of the case DIV, then:
    1) Let (DIV sx) be binop_u0.
    2) Return [$idiv($size(inn), sx, iN_1, iN_2)].
  c. If binop_u0 is of the case REM, then:
    1) Let (REM sx) be binop_u0.
    2) Return [$irem($size(inn), sx, iN_1, iN_2)].
7. If (binop_u0 is AND), then:
  a. Let iN_1 be val__u2.
  b. Let iN_2 be val__u3.
  c. If the type of valty_u1 is inn, then:
    1) Let inn be valty_u1.
    2) Return [$iand($size(inn), iN_1, iN_2)].
8. If (binop_u0 is OR), then:
  a. Let iN_1 be val__u2.
  b. Let iN_2 be val__u3.
  c. If the type of valty_u1 is inn, then:
    1) Let inn be valty_u1.
    2) Return [$ior($size(inn), iN_1, iN_2)].
9. If (binop_u0 is XOR), then:
  a. Let iN_1 be val__u2.
  b. Let iN_2 be val__u3.
  c. If the type of valty_u1 is inn, then:
    1) Let inn be valty_u1.
    2) Return [$ixor($size(inn), iN_1, iN_2)].
10. If (binop_u0 is SHL), then:
  a. Let iN_1 be val__u2.
  b. Let iN_2 be val__u3.
  c. If the type of valty_u1 is inn, then:
    1) Let inn be valty_u1.
    2) Return [$ishl($size(inn), iN_1, iN_2)].
11. Let iN_1 be val__u2.
12. Let iN_2 be val__u3.
13. If the type of valty_u1 is inn, then:
  a. Let inn be valty_u1.
  b. If binop_u0 is of the case SHR, then:
    1) Let (SHR sx) be binop_u0.
    2) Return [$ishr($size(inn), sx, iN_1, iN_2)].
14. If (binop_u0 is ROTL), then:
  a. Let iN_1 be val__u2.
  b. Let iN_2 be val__u3.
  c. If the type of valty_u1 is inn, then:
    1) Let inn be valty_u1.
    2) Return [$irotl($size(inn), iN_1, iN_2)].
15. If (binop_u0 is ROTR), then:
  a. Let iN_1 be val__u2.
  b. Let iN_2 be val__u3.
  c. If the type of valty_u1 is inn, then:
    1) Let inn be valty_u1.
    2) Return [$irotr($size(inn), iN_1, iN_2)].
16. If (binop_u0 is ADD), then:
  a. Let fN_1 be val__u2.
  b. Let fN_2 be val__u3.
  c. If the type of valty_u1 is fnn, then:
    1) Let fnn be valty_u1.
    2) Return [$fadd($size(fnn), fN_1, fN_2)].
17. If (binop_u0 is SUB), then:
  a. Let fN_1 be val__u2.
  b. Let fN_2 be val__u3.
  c. If the type of valty_u1 is fnn, then:
    1) Let fnn be valty_u1.
    2) Return [$fsub($size(fnn), fN_1, fN_2)].
18. If (binop_u0 is MUL), then:
  a. Let fN_1 be val__u2.
  b. Let fN_2 be val__u3.
  c. If the type of valty_u1 is fnn, then:
    1) Let fnn be valty_u1.
    2) Return [$fmul($size(fnn), fN_1, fN_2)].
19. If (binop_u0 is DIV), then:
  a. Let fN_1 be val__u2.
  b. Let fN_2 be val__u3.
  c. If the type of valty_u1 is fnn, then:
    1) Let fnn be valty_u1.
    2) Return [$fdiv($size(fnn), fN_1, fN_2)].
20. If (binop_u0 is MIN), then:
  a. Let fN_1 be val__u2.
  b. Let fN_2 be val__u3.
  c. If the type of valty_u1 is fnn, then:
    1) Let fnn be valty_u1.
    2) Return [$fmin($size(fnn), fN_1, fN_2)].
21. If (binop_u0 is MAX), then:
  a. Let fN_1 be val__u2.
  b. Let fN_2 be val__u3.
  c. If the type of valty_u1 is fnn, then:
    1) Let fnn be valty_u1.
    2) Return [$fmax($size(fnn), fN_1, fN_2)].
22. Assert: Due to validation, (binop_u0 is COPYSIGN).
23. Let fN_1 be val__u2.
24. Let fN_2 be val__u3.
25. Assert: Due to validation, the type of valty_u1 is fnn.
26. Let fnn be valty_u1.
27. Return [$fcopysign($size(fnn), fN_1, fN_2)].

testop inn EQZ iN
1. Return $ieqz($size(inn), iN).

relop valty_u1 relop_u0 val__u2 val__u3
1. If (relop_u0 is EQ), then:
  a. Let iN_1 be val__u2.
  b. Let iN_2 be val__u3.
  c. If the type of valty_u1 is inn, then:
    1) Let inn be valty_u1.
    2) Return $ieq($size(inn), iN_1, iN_2).
2. If (relop_u0 is NE), then:
  a. Let iN_1 be val__u2.
  b. Let iN_2 be val__u3.
  c. If the type of valty_u1 is inn, then:
    1) Let inn be valty_u1.
    2) Return $ine($size(inn), iN_1, iN_2).
3. Let iN_1 be val__u2.
4. Let iN_2 be val__u3.
5. If the type of valty_u1 is inn, then:
  a. Let inn be valty_u1.
  b. If relop_u0 is of the case LT, then:
    1) Let (LT sx) be relop_u0.
    2) Return $ilt($size(inn), sx, iN_1, iN_2).
  c. If relop_u0 is of the case GT, then:
    1) Let (GT sx) be relop_u0.
    2) Return $igt($size(inn), sx, iN_1, iN_2).
  d. If relop_u0 is of the case LE, then:
    1) Let (LE sx) be relop_u0.
    2) Return $ile($size(inn), sx, iN_1, iN_2).
  e. If relop_u0 is of the case GE, then:
    1) Let (GE sx) be relop_u0.
    2) Return $ige($size(inn), sx, iN_1, iN_2).
6. If (relop_u0 is EQ), then:
  a. Let fN_1 be val__u2.
  b. Let fN_2 be val__u3.
  c. If the type of valty_u1 is fnn, then:
    1) Let fnn be valty_u1.
    2) Return $feq($size(fnn), fN_1, fN_2).
7. If (relop_u0 is NE), then:
  a. Let fN_1 be val__u2.
  b. Let fN_2 be val__u3.
  c. If the type of valty_u1 is fnn, then:
    1) Let fnn be valty_u1.
    2) Return $fne($size(fnn), fN_1, fN_2).
8. If (relop_u0 is LT), then:
  a. Let fN_1 be val__u2.
  b. Let fN_2 be val__u3.
  c. If the type of valty_u1 is fnn, then:
    1) Let fnn be valty_u1.
    2) Return $flt($size(fnn), fN_1, fN_2).
9. If (relop_u0 is GT), then:
  a. Let fN_1 be val__u2.
  b. Let fN_2 be val__u3.
  c. If the type of valty_u1 is fnn, then:
    1) Let fnn be valty_u1.
    2) Return $fgt($size(fnn), fN_1, fN_2).
10. If (relop_u0 is LE), then:
  a. Let fN_1 be val__u2.
  b. Let fN_2 be val__u3.
  c. If the type of valty_u1 is fnn, then:
    1) Let fnn be valty_u1.
    2) Return $fle($size(fnn), fN_1, fN_2).
11. Assert: Due to validation, (relop_u0 is GE).
12. Let fN_1 be val__u2.
13. Let fN_2 be val__u3.
14. Assert: Due to validation, the type of valty_u1 is fnn.
15. Let fnn be valty_u1.
16. Return $fge($size(fnn), fN_1, fN_2).

cvtop valty_u0 valty_u1 cvtop_u4 sx_u2? val__u3
1. If ((valty_u0 is I32) and ((valty_u1 is I64) and (cvtop_u4 is CONVERT))), then:
  a. Let iN be val__u3.
  b. If sx_u2? is defined, then:
    1) Let ?(sx) be sx_u2?.
    2) Return [$ext(32, 64, sx, iN)].
2. If ((valty_u0 is I64) and ((valty_u1 is I32) and (cvtop_u4 is CONVERT))), then:
  a. Let iN be val__u3.
  b. Return [$wrap(64, 32, iN)].
3. If (cvtop_u4 is CONVERT), then:
  a. Let fN be val__u3.
  b. If the type of valty_u0 is fnn, then:
    1) Let fnn be valty_u0.
    2) If the type of valty_u1 is inn, then:
      a) Let inn be valty_u1.
      b) If sx_u2? is defined, then:
        1. Let ?(sx) be sx_u2?.
        2. Return [$trunc($size(fnn), $size(inn), sx, fN)].
4. If ((valty_u0 is F32) and ((valty_u1 is F64) and (cvtop_u4 is CONVERT))), then:
  a. Let fN be val__u3.
  b. Return [$promote(32, 64, fN)].
5. If ((valty_u0 is F64) and ((valty_u1 is F32) and (cvtop_u4 is CONVERT))), then:
  a. Let fN be val__u3.
  b. Return [$demote(64, 32, fN)].
6. If ((cvtop_u4 is CONVERT) and the type of valty_u1 is fnn), then:
  a. Let fnn be valty_u1.
  b. Let iN be val__u3.
  c. If the type of valty_u0 is inn, then:
    1) Let inn be valty_u0.
    2) If sx_u2? is defined, then:
      a) Let ?(sx) be sx_u2?.
      b) Return [$convert($size(inn), $size(fnn), sx, iN)].
7. Assert: Due to validation, (cvtop_u4 is REINTERPRET).
8. If the type of valty_u1 is fnn, then:
  a. Let fnn be valty_u1.
  b. Let iN be val__u3.
  c. If the type of valty_u0 is inn, then:
    1) Let inn be valty_u0.
    2) If ($size(inn) is $size(fnn)), then:
      a) Return [$reinterpret(inn, fnn, iN)].
9. Let fN be val__u3.
10. Assert: Due to validation, the type of valty_u0 is fnn.
11. Let fnn be valty_u0.
12. Assert: Due to validation, the type of valty_u1 is inn.
13. Let inn be valty_u1.
14. Assert: Due to validation, ($size(inn) is $size(fnn)).
15. Return [$reinterpret(fnn, inn, fN)].

invibytes N b*
1. Let n be $inverse_of_ibytes(N, b*).
2. Return n.

invfbytes N b*
1. Let p be $inverse_of_fbytes(N, b*).
2. Return p.

default valty_u0
1. If (valty_u0 is I32), then:
  a. Return (I32.CONST 0).
2. If (valty_u0 is I64), then:
  a. Return (I64.CONST 0).
3. If (valty_u0 is F32), then:
  a. Return (F32.CONST $fzero(32)).
4. Assert: Due to validation, (valty_u0 is F64).
5. Return (F64.CONST $fzero(64)).

funcsxv exter_u0*
1. If (exter_u0* is []), then:
  a. Return [].
2. Let [y_0] ++ xv* be exter_u0*.
3. If y_0 is of the case FUNC, then:
  a. Let (FUNC fa) be y_0.
  b. Return [fa] ++ $funcsxv(xv*).
4. Let [externval] ++ xv* be exter_u0*.
5. Return $funcsxv(xv*).

globalsxv exter_u0*
1. If (exter_u0* is []), then:
  a. Return [].
2. Let [y_0] ++ xv* be exter_u0*.
3. If y_0 is of the case GLOBAL, then:
  a. Let (GLOBAL ga) be y_0.
  b. Return [ga] ++ $globalsxv(xv*).
4. Let [externval] ++ xv* be exter_u0*.
5. Return $globalsxv(xv*).

tablesxv exter_u0*
1. If (exter_u0* is []), then:
  a. Return [].
2. Let [y_0] ++ xv* be exter_u0*.
3. If y_0 is of the case TABLE, then:
  a. Let (TABLE ta) be y_0.
  b. Return [ta] ++ $tablesxv(xv*).
4. Let [externval] ++ xv* be exter_u0*.
5. Return $tablesxv(xv*).

memsxv exter_u0*
1. If (exter_u0* is []), then:
  a. Return [].
2. Let [y_0] ++ xv* be exter_u0*.
3. If y_0 is of the case MEM, then:
  a. Let (MEM ma) be y_0.
  b. Return [ma] ++ $memsxv(xv*).
4. Let [externval] ++ xv* be exter_u0*.
5. Return $memsxv(xv*).

store
1. Return.

frame
1. Let f be the current frame.
2. Return f.

funcaddr
1. Let f be the current frame.
2. Return f.MODULE.FUNC.

funcinst
1. Return s.FUNC.

globalinst
1. Return s.GLOBAL.

tableinst
1. Return s.TABLE.

meminst
1. Return s.MEM.

moduleinst
1. Let f be the current frame.
2. Return f.MODULE.

type x
1. Let f be the current frame.
2. Return f.MODULE.TYPE[x].

func x
1. Let f be the current frame.
2. Return s.FUNC[f.MODULE.FUNC[x]].

global x
1. Let f be the current frame.
2. Return s.GLOBAL[f.MODULE.GLOBAL[x]].

table x
1. Let f be the current frame.
2. Return s.TABLE[f.MODULE.TABLE[x]].

mem x
1. Let f be the current frame.
2. Return s.MEM[f.MODULE.MEM[x]].

local x
1. Let f be the current frame.
2. Return f.LOCAL[x].

with_local x v
1. Let f be the current frame.
2. Replace f.LOCAL[x] with v.

with_global x v
1. Let f be the current frame.
2. Replace s.GLOBAL[f.MODULE.GLOBAL[x]].VALUE with v.

with_table x i a
1. Let f be the current frame.
2. Replace s.TABLE[f.MODULE.TABLE[x]].ELEM[i] with ?(a).

with_tableinst x ti
1. Let f be the current frame.
2. Replace s.TABLE[f.MODULE.TABLE[x]] with ti.

with_mem x i j b*
1. Let f be the current frame.
2. Replace s.MEM[f.MODULE.MEM[x]].DATA[i : j] with b*.

with_meminst x mi
1. Let f be the current frame.
2. Replace s.MEM[f.MODULE.MEM[x]] with mi.

growtable ti n
1. Let { TYPE: (i, j); ELEM: ?(a)*; } be ti.
2. Let i' be (|a*| + n).
3. If (i' ≤ j), then:
  a. Let ti' be { TYPE: (i', j); ELEM: ?(a)* ++ ?()^n; }.
  b. Return ti'.

growmemory mi n
1. Let { TYPE: (i, j); DATA: b*; } be mi.
2. Let i' be ((|b*| / (64 · $Ki())) + n).
3. If (i' ≤ j), then:
  a. Let mi' be { TYPE: (i', j); DATA: b* ++ 0^((n · 64) · $Ki()); }.
  b. Return mi'.

funcs exter_u0*
1. If (exter_u0* is []), then:
  a. Return [].
2. Let [y_0] ++ externval'* be exter_u0*.
3. If y_0 is of the case FUNC, then:
  a. Let (FUNC fa) be y_0.
  b. Return [fa] ++ $funcs(externval'*).
4. Let [externval] ++ externval'* be exter_u0*.
5. Return $funcs(externval'*).

globals exter_u0*
1. If (exter_u0* is []), then:
  a. Return [].
2. Let [y_0] ++ externval'* be exter_u0*.
3. If y_0 is of the case GLOBAL, then:
  a. Let (GLOBAL ga) be y_0.
  b. Return [ga] ++ $globals(externval'*).
4. Let [externval] ++ externval'* be exter_u0*.
5. Return $globals(externval'*).

tables exter_u0*
1. If (exter_u0* is []), then:
  a. Return [].
2. Let [y_0] ++ externval'* be exter_u0*.
3. If y_0 is of the case TABLE, then:
  a. Let (TABLE ta) be y_0.
  b. Return [ta] ++ $tables(externval'*).
4. Let [externval] ++ externval'* be exter_u0*.
5. Return $tables(externval'*).

mems exter_u0*
1. If (exter_u0* is []), then:
  a. Return [].
2. Let [y_0] ++ externval'* be exter_u0*.
3. If y_0 is of the case MEM, then:
  a. Let (MEM ma) be y_0.
  b. Return [ma] ++ $mems(externval'*).
4. Let [externval] ++ externval'* be exter_u0*.
5. Return $mems(externval'*).

allocfunc mm func
1. Assert: Due to validation, func is of the case FUNC.
2. Let (FUNC x local* expr) be func.
3. Let fi be { TYPE: mm.TYPE[x]; MODULE: mm; CODE: func; }.
4. Let a be |s.FUNC|.
5. Append fi to the s.FUNC.
6. Return a.

allocfuncs mm func_u0*
1. If (func_u0* is []), then:
  a. Return [].
2. Let [func] ++ func'* be func_u0*.
3. Let fa be $allocfunc(mm, func).
4. Let fa'* be $allocfuncs(mm, func'*).
5. Return [fa] ++ fa'*.

allocglobal globaltype val
1. Let gi be { TYPE: globaltype; VALUE: val; }.
2. Let a be |s.GLOBAL|.
3. Append gi to the s.GLOBAL.
4. Return a.

allocglobals globa_u0* val_u1*
1. If (globa_u0* is []), then:
  a. Assert: Due to validation, (val_u1* is []).
  b. Return [].
2. Else:
  a. Let [globaltype] ++ globaltype'* be globa_u0*.
  b. Assert: Due to validation, (|val_u1*| ≥ 1).
  c. Let [val] ++ val'* be val_u1*.
  d. Let ga be $allocglobal(globaltype, val).
  e. Let ga'* be $allocglobals(globaltype'*, val'*).
  f. Return [ga] ++ ga'*.

alloctable (i, j)
1. Let ti be { TYPE: (i, j); ELEM: ?()^i; }.
2. Let a be |s.TABLE|.
3. Append ti to the s.TABLE.
4. Return a.

alloctables table_u0*
1. If (table_u0* is []), then:
  a. Return [].
2. Let [tabletype] ++ tabletype'* be table_u0*.
3. Let ta be $alloctable(tabletype).
4. Let ta'* be $alloctables(tabletype'*).
5. Return [ta] ++ ta'*.

allocmem (i, j)
1. Let mi be { TYPE: (i, j); DATA: 0^((i · 64) · $Ki()); }.
2. Let a be |s.MEM|.
3. Append mi to the s.MEM.
4. Return a.

allocmems memty_u0*
1. If (memty_u0* is []), then:
  a. Return [].
2. Let [memtype] ++ memtype'* be memty_u0*.
3. Let ma be $allocmem(memtype).
4. Let ma'* be $allocmems(memtype'*).
5. Return [ma] ++ ma'*.

instexport fa* ga* ta* ma* (EXPORT name exter_u0)
1. If exter_u0 is of the case FUNC, then:
  a. Let (FUNC x) be exter_u0.
  b. Return { NAME: name; VALUE: (FUNC fa*[x]); }.
2. If exter_u0 is of the case GLOBAL, then:
  a. Let (GLOBAL x) be exter_u0.
  b. Return { NAME: name; VALUE: (GLOBAL ga*[x]); }.
3. If exter_u0 is of the case TABLE, then:
  a. Let (TABLE x) be exter_u0.
  b. Return { NAME: name; VALUE: (TABLE ta*[x]); }.
4. Assert: Due to validation, exter_u0 is of the case MEM.
5. Let (MEM x) be exter_u0.
6. Return { NAME: name; VALUE: (MEM ma*[x]); }.

allocmodule module externval* val*
1. Let fa_ex* be $funcs(externval*).
2. Let ga_ex* be $globals(externval*).
3. Let ma_ex* be $mems(externval*).
4. Let ta_ex* be $tables(externval*).
5. Assert: Due to validation, module is of the case MODULE.
6. Let (MODULE y_0 import* func^n_func y_1 y_2 y_3 elem* data* start? export*) be module.
7. Let (MEMORY memtype)^n_mem be y_3.
8. Let (TABLE tabletype)^n_table be y_2.
9. Let (GLOBAL globaltype expr_1)^n_global be y_1.
10. Let (TYPE ft)* be y_0.
11. Let fa* be (|s.FUNC| + i_func)^(i_func<n_func).
12. Let ga* be (|s.GLOBAL| + i_global)^(i_global<n_global).
13. Let ta* be (|s.TABLE| + i_table)^(i_table<n_table).
14. Let ma* be (|s.MEM| + i_mem)^(i_mem<n_mem).
15. Let xi* be $instexport(fa_ex* ++ fa*, ga_ex* ++ ga*, ta_ex* ++ ta*, ma_ex* ++ ma*, export)*.
16. Let mm be { TYPE: ft*; FUNC: fa_ex* ++ fa*; GLOBAL: ga_ex* ++ ga*; TABLE: ta_ex* ++ ta*; MEM: ma_ex* ++ ma*; EXPORT: xi*; }.
17. Let y_0 be $allocfuncs(mm, func^n_func).
18. Assert: Due to validation, (y_0 is fa*).
19. Let y_0 be $allocglobals(globaltype^n_global, val*).
20. Assert: Due to validation, (y_0 is ga*).
21. Let y_0 be $alloctables(tabletype^n_table).
22. Assert: Due to validation, (y_0 is ta*).
23. Let y_0 be $allocmems(memtype^n_mem).
24. Assert: Due to validation, (y_0 is ma*).
25. Return mm.

initelem mm u32_u0* funca_u1*
1. If ((u32_u0* is []) and (funca_u1* is [])), then:
  a. Return.
2. Assert: Due to validation, (|funca_u1*| ≥ 1).
3. Let [a*] ++ a'** be funca_u1*.
4. Assert: Due to validation, (|u32_u0*| ≥ 1).
5. Let [i] ++ i'* be u32_u0*.
6. Replace s.TABLE[mm.TABLE[0]].ELEM[i : |a*|] with ?(a)*.
7. Perform $initelem(mm, i'*, a'**).
8. Return.

initdata mm u32_u0* byte_u1*
1. If ((u32_u0* is []) and (byte_u1* is [])), then:
  a. Return.
2. Assert: Due to validation, (|byte_u1*| ≥ 1).
3. Let [b*] ++ b'** be byte_u1*.
4. Assert: Due to validation, (|u32_u0*| ≥ 1).
5. Let [i] ++ i'* be u32_u0*.
6. Replace s.MEM[mm.MEM[0]].DATA[i : |b*|] with b*.
7. Perform $initdata(mm, i'*, b'**).
8. Return.

instantiate module externval*
1. Assert: Due to validation, module is of the case MODULE.
2. Let (MODULE type* import* func* global* table* mem* elem* data* start? export*) be module.
3. Let (TYPE functype)* be type*.
4. Let n_F be |func*|.
5. Let (START x')? be start?.
6. Let (DATA expr_D b*)* be data*.
7. Let (ELEM expr_E x*)* be elem*.
8. Let (GLOBAL globaltype expr_G)* be global*.
9. Let mm_init be { TYPE: functype*; FUNC: $funcs(externval*) ++ (|s.FUNC| + i_F)^(i_F<n_F); GLOBAL: $globals(externval*); TABLE: []; MEM: []; EXPORT: []; }.
10. Let f_init be { LOCAL: []; MODULE: mm_init; }.
11. Let z be f_init.
12. Push the activation of z to the stack.
13. Let [(I32.CONST i_D)]* be $eval_expr(expr_D)*.
14. Pop the activation of z from the stack.
15. Push the activation of z to the stack.
16. Let [(I32.CONST i_E)]* be $eval_expr(expr_E)*.
17. Pop the activation of z from the stack.
18. Push the activation of z to the stack.
19. Let [val]* be $eval_expr(expr_G)*.
20. Pop the activation of z from the stack.
21. Let mm be $allocmodule(module, externval*, val*).
22. Let f be { LOCAL: []; MODULE: mm; }.
23. Perform $initelem(mm, i_E*, mm.FUNC[x]**).
24. Perform $initdata(mm, i_D*, b**).
25. Enter the activation of f with arity 0 with label [FRAME_]:
  a. If x' is defined, then:
    1) Let ?(x'_0) be x'.
    2) Execute (CALL x'_0).
26. Return mm.

invoke fa val^n
1. Let f be { LOCAL: []; MODULE: { TYPE: []; FUNC: []; GLOBAL: []; TABLE: []; MEM: []; EXPORT: []; }; }.
2. Let (t_1^n -> t_2*) be $funcinst()[fa].TYPE.
3. Let k be |t_2*|.
4. Enter the activation of f with arity k with label [FRAME_]:
  a. Push val^n to the stack.
  b. Execute (CALL_ADDR fa).
5. Pop val^k from the stack.
6. Return val^k.

utf8 name_u0
1. If (|name_u0| is 1), then:
  a. Let [ch] be name_u0.
  b. If ((ch < 128) and the type of ch is byte), then:
    1) Let b be ch.
    2) Return [b].
  c. If ((128 ≤ ch) and ((ch < 2048) and (ch ≥ (b_2 - 128)))), then:
    1) Let ((2 ^ 6) · (b_1 - 192)) be (ch - (b_2 - 128)).
    2) Return [b_1, b_2].
  d. If ((((2048 ≤ ch) and (ch < 55296)) or ((57344 ≤ ch) and (ch < 65536))) and (ch ≥ (b_3 - 128))), then:
    1) Let (((2 ^ 12) · (b_1 - 224)) + ((2 ^ 6) · (b_2 - 128))) be (ch - (b_3 - 128)).
    2) Return [b_1, b_2, b_3].
  e. If ((65536 ≤ ch) and ((ch < 69632) and (ch ≥ (b_4 - 128)))), then:
    1) Let ((((2 ^ 18) · (b_1 - 240)) + ((2 ^ 12) · (b_2 - 128))) + ((2 ^ 6) · (b_3 - 128))) be (ch - (b_4 - 128)).
    2) Return [b_1, b_2, b_3, b_4].
2. Let ch* be name_u0.
3. Return $concat_($utf8([ch])*).

execution_of_UNREACHABLE
1. Trap.

execution_of_NOP
1. Do nothing.

execution_of_DROP
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop val from the stack.
3. Do nothing.

execution_of_SELECT t*?
1. Assert: Due to validation, a value of value type I32 is on the top of the stack.
2. Pop (I32.CONST c) from the stack.
3. Assert: Due to validation, a value is on the top of the stack.
4. Pop val_2 from the stack.
5. Assert: Due to validation, a value is on the top of the stack.
6. Pop val_1 from the stack.
7. If (c is not 0), then:
  a. Push val_1 to the stack.
8. Else:
  a. Push val_2 to the stack.

execution_of_IF t? instr_1* instr_2*
1. Assert: Due to validation, a value of value type I32 is on the top of the stack.
2. Pop (I32.CONST c) from the stack.
3. If (c is not 0), then:
  a. Execute (BLOCK t? instr_1*).
4. Else:
  a. Execute (BLOCK t? instr_2*).

execution_of_LABEL_
1. Pop all values val* from the stack.
2. Assert: Due to validation, a label is now on the top of the stack.
3. Exit current context.
4. Push val* to the stack.

execution_of_BR label_u0
1. Let L be the current label.
2. Let n be the arity of L.
3. Let instr'* be the continuation of L.
4. Pop all values admin_u1* from the stack.
5. Exit current context.
6. If ((label_u0 is 0) and (|admin_u1*| ≥ n)), then:
  a. Let val'* ++ val^n be admin_u1*.
  b. Push val^n to the stack.
  c. Execute the sequence (instr'*).
7. If (label_u0 ≥ 1), then:
  a. Let l be (label_u0 - 1).
  b. Let val* be admin_u1*.
  c. Push val* to the stack.
  d. Execute (BR l).

execution_of_BR_IF l
1. Assert: Due to validation, a value of value type I32 is on the top of the stack.
2. Pop (I32.CONST c) from the stack.
3. If (c is not 0), then:
  a. Execute (BR l).
4. Else:
  a. Do nothing.

execution_of_BR_TABLE l* l'
1. Assert: Due to validation, a value of value type I32 is on the top of the stack.
2. Pop (I32.CONST i) from the stack.
3. If (i < |l*|), then:
  a. Execute (BR l*[i]).
4. Else:
  a. Execute (BR l').

execution_of_FRAME_
1. Let f be the current frame.
2. Let n be the arity of f.
3. Assert: Due to validation, there are at least n values on the top of the stack.
4. Pop val^n from the stack.
5. Assert: Due to validation, a frame is now on the top of the stack.
6. Exit current context.
7. Push val^n to the stack.

execution_of_RETURN
1. If the current context is frame, then:
  a. Let F be the current frame.
  b. Let n be the arity of F.
  c. Pop val^n from the stack.
  d. Pop all values val'* from the stack.
  e. Exit current context.
  f. Push val^n to the stack.
2. Else if the current context is label, then:
  a. Pop all values val* from the stack.
  b. Exit current context.
  c. Push val* to the stack.
  d. Execute RETURN.

execution_of_UNOP t unop
1. Assert: Due to validation, a value of value type t is on the top of the stack.
2. Pop (t.CONST c_1) from the stack.
3. If (|$unop(t, unop, c_1)| is 1), then:
  a. Let [c] be $unop(t, unop, c_1).
  b. Push (t.CONST c) to the stack.
4. If ($unop(t, unop, c_1) is []), then:
  a. Trap.

execution_of_BINOP t binop
1. Assert: Due to validation, a value of value type t is on the top of the stack.
2. Pop (t.CONST c_2) from the stack.
3. Assert: Due to validation, a value of value type t is on the top of the stack.
4. Pop (t.CONST c_1) from the stack.
5. If (|$binop(t, binop, c_1, c_2)| is 1), then:
  a. Let [c] be $binop(t, binop, c_1, c_2).
  b. Push (t.CONST c) to the stack.
6. If ($binop(t, binop, c_1, c_2) is []), then:
  a. Trap.

execution_of_TESTOP t testop
1. Assert: Due to validation, a value of value type t is on the top of the stack.
2. Pop (t.CONST c_1) from the stack.
3. Let c be $testop(t, testop, c_1).
4. Push (I32.CONST c) to the stack.

execution_of_RELOP t relop
1. Assert: Due to validation, a value of value type t is on the top of the stack.
2. Pop (t.CONST c_2) from the stack.
3. Assert: Due to validation, a value of value type t is on the top of the stack.
4. Pop (t.CONST c_1) from the stack.
5. Let c be $relop(t, relop, c_1, c_2).
6. Push (I32.CONST c) to the stack.

execution_of_CVTOP t_2 cvtop t_1 sx?
1. Assert: Due to validation, a value of value type t_1 is on the top of the stack.
2. Pop (t_1.CONST c_1) from the stack.
3. If (|$cvtop(t_1, t_2, cvtop, sx?, c_1)| is 1), then:
  a. Let [c] be $cvtop(t_1, t_2, cvtop, sx?, c_1).
  b. Push (t_2.CONST c) to the stack.
4. If ($cvtop(t_1, t_2, cvtop, sx?, c_1) is []), then:
  a. Trap.

execution_of_LOCAL.TEE x
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop val from the stack.
3. Push val to the stack.
4. Push val to the stack.
5. Execute (LOCAL.SET x).

execution_of_BLOCK t? instr*
1. If t? is not defined, then:
  a. Let n be 0.
2. Else:
  a. Let n be 1.
3. Let L be the label_n{[]}.
4. Enter L with label instr* ++ [LABEL_]:

execution_of_LOOP t? instr*
1. Let L be the label_0{[(LOOP t? instr*)]}.
2. Enter L with label instr* ++ [LABEL_]:

execution_of_CALL x
1. Assert: Due to validation, (x < |$funcaddr()|).
2. Execute (CALL_ADDR $funcaddr()[x]).

execution_of_CALL_INDIRECT x
1. Assert: Due to validation, a value of value type I32 is on the top of the stack.
2. Pop (I32.CONST i) from the stack.
3. If (i ≥ |$table(0).ELEM|), then:
  a. Trap.
4. If $table(0).ELEM[i] is not defined, then:
  a. Trap.
5. Let ?(a) be $table(0).ELEM[i].
6. If (a ≥ |$funcinst()|), then:
  a. Trap.
7. If ($type(x) is not $funcinst()[a].TYPE), then:
  a. Trap.
8. Execute (CALL_ADDR a).

execution_of_CALL_ADDR a
1. Assert: Due to validation, (a < |$funcinst()|).
2. Let { TYPE: (t_1^k -> t_2^n); MODULE: mm; CODE: func; } be $funcinst()[a].
3. Assert: Due to validation, there are at least k values on the top of the stack.
4. Pop val^k from the stack.
5. Assert: Due to validation, func is of the case FUNC.
6. Let (FUNC x y_0 instr*) be func.
7. Let (LOCAL t)* be y_0.
8. Let f be { LOCAL: val^k ++ $default(t)*; MODULE: mm; }.
9. Let F be the activation of f with arity n.
10. Enter F with label [FRAME_]:
  a. Let L be the label_n{[]}.
  b. Enter L with label instr* ++ [LABEL_]:

execution_of_LOCAL.GET x
1. Push $local(x) to the stack.

execution_of_GLOBAL.GET x
1. Push $global(x).VALUE to the stack.

execution_of_LOAD valty_u0 n_sx_u1? mo
1. Assert: Due to validation, a value of value type I32 is on the top of the stack.
2. Pop (I32.CONST i) from the stack.
3. If n_sx_u1? is not defined, then:
  a. Let t be valty_u0.
  b. If (((i + mo.OFFSET) + ($size(t) / 8)) > |$mem(0).DATA|), then:
    1) Trap.
  c. Let c be $inverse_of_bytes(t, $mem(0).DATA[(i + mo.OFFSET) : ($size(t) / 8)]).
  d. Push (t.CONST c) to the stack.
4. If the type of valty_u0 is inn, then:
  a. If n_sx_u1? is defined, then:
    1) Let ?(y_0) be n_sx_u1?.
    2) Let (n, sx) be y_0.
    3) If (((i + mo.OFFSET) + (n / 8)) > |$mem(0).DATA|), then:
      a) Trap.
  b. Let inn be valty_u0.
  c. If n_sx_u1? is defined, then:
    1) Let ?(y_0) be n_sx_u1?.
    2) Let (n, sx) be y_0.
    3) Let c be $inverse_of_ibytes(n, $mem(0).DATA[(i + mo.OFFSET) : (n / 8)]).
    4) Push (inn.CONST $ext(n, $size(inn), sx, c)) to the stack.

execution_of_MEMORY.SIZE
1. Let ((n · 64) · $Ki()) be |$mem(0).DATA|.
2. Push (I32.CONST n) to the stack.

execution_of_LOCAL.SET x
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop val from the stack.
3. Perform $with_local(x, val).

execution_of_GLOBAL.SET x
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop val from the stack.
3. Perform $with_global(x, val).

execution_of_STORE valty_u1 n_u2? mo
1. Assert: Due to validation, a value of value type valty_u0 is on the top of the stack.
2. Pop (valty_u0.CONST c) from the stack.
3. Assert: Due to validation, a value of value type I32 is on the top of the stack.
4. Pop (I32.CONST i) from the stack.
5. If n_u2? is not defined, then:
  a. Let t be valty_u1.
  b. If ((((i + mo.OFFSET) + ($size(t) / 8)) > |$mem(0).DATA|) and (valty_u0 is t)), then:
    1) Trap.
  c. If (valty_u0 is t), then:
    1) Let b* be $bytes(t, c).
    2) Perform $with_mem(0, (i + mo.OFFSET), ($size(t) / 8), b*).
6. Else:
  a. Let ?(n) be n_u2?.
  b. If the type of valty_u1 is inn, then:
    1) Let inn be valty_u1.
    2) If ((((i + mo.OFFSET) + (n / 8)) > |$mem(0).DATA|) and (valty_u0 is inn)), then:
      a) Trap.
    3) If (valty_u0 is inn), then:
      a) Let b* be $ibytes(n, $wrap($size(inn), n, c)).
      b) Perform $with_mem(0, (i + mo.OFFSET), (n / 8), b*).

execution_of_MEMORY.GROW
1. Assert: Due to validation, a value of value type I32 is on the top of the stack.
2. Pop (I32.CONST n) from the stack.
3. Either:
  a. Let mi be $growmemory($mem(0), n).
  b. Push (I32.CONST (|$mem(0).DATA| / (64 · $Ki()))) to the stack.
  c. Perform $with_meminst(0, mi).
4. Or:
  a. Push (I32.CONST $invsigned(32, (- 1))) to the stack.

eval_expr instr*
1. Execute the sequence (instr*).
2. Pop val from the stack.
3. Return [val].

execution_of_CALL_REF x
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop ref from the stack.
3. If ref is of the case REF.NULL, then:
  a. Trap.
4. Assert: Due to validation, ref is of the case REF.FUNC_ADDR.
5. Let (REF.FUNC_ADDR a) be ref.
6. If (a < |$funcinst()|), then:
  a. Let fi be $funcinst()[a].
  b. Assert: Due to validation, fi.CODE is of the case FUNC.
  c. Let (FUNC y_0 y_1 instr*) be fi.CODE.
  d. Let (LOCAL t)* be y_1.
  e. Assert: Due to validation, $expanddt(fi.TYPE) is of the case FUNC.
  f. Let (FUNC y_0) be $expanddt(fi.TYPE).
  g. Let (t_1^n -> t_2^m) be y_0.
  h. Assert: Due to validation, there are at least n values on the top of the stack.
  i. Pop val^n from the stack.
  j. Let f be { LOCAL: ?(val)^n ++ $default(t)*; MODULE: fi.MODULE; }.
  k. Let F be the activation of f with arity m.
  l. Enter F with label [FRAME_]:
    1) Let L be the label_m{[]}.
    2) Enter L with label instr* ++ [LABEL_]:

group_bytes_by n byte*
1. Let n' be |byte*|.
2. If (n' ≥ n), then:
  a. Return [byte*[0 : n]] ++ $group_bytes_by(n, byte*[n : (n' - n)]).
3. Return [].

execution_of_ARRAY.NEW_DATA x y
1. Assert: Due to validation, a value of value type I32 is on the top of the stack.
2. Pop (I32.CONST n) from the stack.
3. Assert: Due to validation, a value of value type I32 is on the top of the stack.
4. Pop (I32.CONST i) from the stack.
5. If $expanddt($type(x)) is of the case ARRAY, then:
  a. Let (ARRAY y_0) be $expanddt($type(x)).
  b. Let (mut, zt) be y_0.
  c. If ((i + ((n · $storagesize(zt)) / 8)) > |$data(y).DATA|), then:
    1) Trap.
  d. Let nt be $unpacknumtype(zt).
  e. Let b* be $data(y).DATA[i : ((n · $storagesize(zt)) / 8)].
  f. Let gb* be $group_bytes_by(($storagesize(zt) / 8), b*).
  g. Let c^n be $inverse_of_ibytes($storagesize(zt), gb)*.
  h. Push (nt.CONST c)^n to the stack.
  i. Execute (ARRAY.NEW_FIXED x n).
== Complete.
Generating prose for Wasm 2.0...
watsup 0.4 generator
== Parsing...
== Elaboration...
== IL Validation...
== Running pass sideconditions...
== IL Validation after pass sideconditions...
== Running pass animate...
== IL Validation after pass animate...
== Translating to AL...
== Prose Generation...
=================
 Generated prose
=================
validation_of_UNREACHABLE
- The instruction is valid with type (t_1* -> t_2*).

validation_of_NOP
- The instruction is valid with type ([] -> []).

validation_of_DROP
- The instruction is valid with type ([t] -> []).

validation_of_SELECT ?([t])
- The instruction is valid with type ([t, t, I32] -> [t]).

validation_of_BLOCK bt instr*
- Under the context C with .LABEL prepended by [t_2*], instr* must be valid with type (t_1* -> t_2*).
- Under the context C, bt must be valid with type (t_1* -> t_2*).
- The instruction is valid with type (t_1* -> t_2*).

validation_of_LOOP bt instr*
- Under the context C with .LABEL prepended by [t_1*], instr* must be valid with type (t_1* -> t_2*).
- Under the context C, bt must be valid with type (t_1* -> t_2*).
- The instruction is valid with type (t_1* -> t_2*).

validation_of_IF bt instr_1* instr_2*
- Under the context C with .LABEL prepended by [t_2*], instr_2* must be valid with type (t_1* -> t_2*).
- Under the context C, bt must be valid with type (t_1* -> t_2*).
- Under the context C with .LABEL prepended by [t_2*], instr_1* must be valid with type (t_1* -> t_2*).
- The instruction is valid with type (t_1* ++ [I32] -> t_2*).

validation_of_BR l
- |C.LABEL| must be greater than l.
- Let t* be C.LABEL[l].
- The instruction is valid with type (t_1* ++ t* -> t_2*).

validation_of_BR_IF l
- |C.LABEL| must be greater than l.
- Let t* be C.LABEL[l].
- The instruction is valid with type (t* ++ [I32] -> t*).

validation_of_BR_TABLE l* l'
- For all l in l*,
  - |C.LABEL| must be greater than l.
- |C.LABEL| must be greater than l'.
- For all l in l*,
  - C.LABEL[l] must match t*.
- C.LABEL[l'] must match t*.
- The instruction is valid with type (t_1* ++ t* -> t_2*).

validation_of_RETURN
- Let ?(t*) be C.RETURN.
- The instruction is valid with type (t_1* ++ t* -> t_2*).

validation_of_CALL x
- |C.FUNC| must be greater than x.
- Let (t_1* -> t_2*) be C.FUNC[x].
- The instruction is valid with type (t_1* -> t_2*).

validation_of_CALL_INDIRECT x y
- |C.TABLE| must be greater than x.
- |C.TYPE| must be greater than y.
- Let (lim, FUNCREF) be C.TABLE[x].
- Let (t_1* -> t_2*) be C.TYPE[y].
- The instruction is valid with type (t_1* ++ [I32] -> t_2*).

validation_of_CONST nt c_nt
- The instruction is valid with type ([] -> [nt]).

validation_of_UNOP nt unop_nt
- The instruction is valid with type ([nt] -> [nt]).

validation_of_BINOP nt binop_nt
- The instruction is valid with type ([nt, nt] -> [nt]).

validation_of_TESTOP nt testop_nt
- The instruction is valid with type ([nt] -> [I32]).

validation_of_RELOP nt relop_nt
- The instruction is valid with type ([nt, nt] -> [I32]).

validation_of_CVTOP nt_1 REINTERPRET nt_2 ?()
- nt_1 must be different with nt_2.
- $size(nt_1) must be equal to $size(nt_2).
- The instruction is valid with type ([nt_2] -> [nt_1]).

validation_of_CVTOP inn_1 CONVERT inn_2 sx?
- inn_1 must be different with inn_2.
- (($size(inn_1) > $size(inn_2))) and ((sx? is ?())) are equivalent.
- The instruction is valid with type ([inn_2] -> [inn_1]).

validation_of_REF.NULL rt
- The instruction is valid with type ([] -> [rt]).

validation_of_REF.FUNC x
- |C.FUNC| must be greater than x.
- Let ft be C.FUNC[x].
- The instruction is valid with type ([] -> [FUNCREF]).

validation_of_REF.IS_NULL
- The instruction is valid with type ([rt] -> [I32]).

validation_of_VCONST V128 c
- The instruction is valid with type ([] -> [V128]).

validation_of_VVUNOP V128 vvunop
- The instruction is valid with type ([V128] -> [V128]).

validation_of_VVBINOP V128 vvbinop
- The instruction is valid with type ([V128, V128] -> [V128]).

validation_of_VVTERNOP V128 vvternop
- The instruction is valid with type ([V128, V128, V128] -> [V128]).

validation_of_VVTESTOP V128 vvtestop
- The instruction is valid with type ([V128] -> [I32]).

validation_of_VBITMASK sh
- The instruction is valid with type ([V128] -> [I32]).

validation_of_VSWIZZLE sh
- The instruction is valid with type ([V128, V128] -> [V128]).

validation_of_VSHUFFLE (imm X N) i*
- For all i in i*,
  - i must be less than (N · 2).
- The instruction is valid with type ([V128, V128] -> [V128]).

validation_of_VSPLAT (lnn X N)
- The instruction is valid with type ([$unpack(lnn)] -> [V128]).

validation_of_VEXTRACT_LANE (lnn X N) sx? i
- i must be less than N.
- The instruction is valid with type ([V128] -> [$unpack(lnn)]).

validation_of_VREPLACE_LANE (lnn X N) i
- i must be less than N.
- The instruction is valid with type ([V128, $unpack(lnn)] -> [V128]).

validation_of_VUNOP sh vunop_sh
- The instruction is valid with type ([V128] -> [V128]).

validation_of_VBINOP sh vbinop_sh
- The instruction is valid with type ([V128, V128] -> [V128]).

validation_of_VTESTOP sh vtestop_sh
- The instruction is valid with type ([V128] -> [I32]).

validation_of_VRELOP sh vrelop_sh
- The instruction is valid with type ([V128, V128] -> [V128]).

validation_of_VSHIFTOP sh vshiftop_sh
- The instruction is valid with type ([V128, I32] -> [V128]).

validation_of_VCVTOP sh vcvtop hf? sh sx? zero
- The instruction is valid with type ([V128] -> [V128]).

validation_of_VNARROW sh sh sx
- The instruction is valid with type ([V128, V128] -> [V128]).

validation_of_VEXTUNOP sh sh vextunop sx
- The instruction is valid with type ([V128] -> [V128]).

validation_of_VEXTBINOP sh sh vextbinop sx
- The instruction is valid with type ([V128, V128] -> [V128]).

validation_of_LOCAL.GET x
- |C.LOCAL| must be greater than x.
- Let t be C.LOCAL[x].
- The instruction is valid with type ([] -> [t]).

validation_of_LOCAL.SET x
- |C.LOCAL| must be greater than x.
- Let t be C.LOCAL[x].
- The instruction is valid with type ([t] -> []).

validation_of_LOCAL.TEE x
- |C.LOCAL| must be greater than x.
- Let t be C.LOCAL[x].
- The instruction is valid with type ([t] -> [t]).

validation_of_GLOBAL.GET x
- |C.GLOBAL| must be greater than x.
- Let (mut, t) be C.GLOBAL[x].
- The instruction is valid with type ([] -> [t]).

validation_of_GLOBAL.SET x
- |C.GLOBAL| must be greater than x.
- Let ((MUT ?(())), t) be C.GLOBAL[x].
- The instruction is valid with type ([t] -> []).

validation_of_TABLE.GET x
- |C.TABLE| must be greater than x.
- Let (lim, rt) be C.TABLE[x].
- The instruction is valid with type ([I32] -> [rt]).

validation_of_TABLE.SET x
- |C.TABLE| must be greater than x.
- Let (lim, rt) be C.TABLE[x].
- The instruction is valid with type ([I32, rt] -> []).

validation_of_TABLE.SIZE x
- |C.TABLE| must be greater than x.
- Let tt be C.TABLE[x].
- The instruction is valid with type ([] -> [I32]).

validation_of_TABLE.GROW x
- |C.TABLE| must be greater than x.
- Let (lim, rt) be C.TABLE[x].
- The instruction is valid with type ([rt, I32] -> [I32]).

validation_of_TABLE.FILL x
- |C.TABLE| must be greater than x.
- Let (lim, rt) be C.TABLE[x].
- The instruction is valid with type ([I32, rt, I32] -> []).

validation_of_TABLE.COPY x_1 x_2
- |C.TABLE| must be greater than x_1.
- |C.TABLE| must be greater than x_2.
- Let (lim_1, rt) be C.TABLE[x_1].
- Let (lim_2, rt) be C.TABLE[x_2].
- The instruction is valid with type ([I32, I32, I32] -> []).

validation_of_TABLE.INIT x_1 x_2
- |C.TABLE| must be greater than x_1.
- |C.ELEM| must be greater than x_2.
- Let (lim, rt) be C.TABLE[x_1].
- C.ELEM[x_2] must be equal to rt.
- The instruction is valid with type ([I32, I32, I32] -> []).

validation_of_ELEM.DROP x
- |C.ELEM| must be greater than x.
- Let rt be C.ELEM[x].
- The instruction is valid with type ([] -> []).

validation_of_MEMORY.SIZE
- |C.MEM| must be greater than 0.
- Let mt be C.MEM[0].
- The instruction is valid with type ([] -> [I32]).

validation_of_MEMORY.GROW
- |C.MEM| must be greater than 0.
- Let mt be C.MEM[0].
- The instruction is valid with type ([I32] -> [I32]).

validation_of_MEMORY.FILL
- |C.MEM| must be greater than 0.
- Let mt be C.MEM[0].
- The instruction is valid with type ([I32, I32, I32] -> []).

validation_of_MEMORY.COPY
- |C.MEM| must be greater than 0.
- Let mt be C.MEM[0].
- The instruction is valid with type ([I32, I32, I32] -> []).

validation_of_MEMORY.INIT x
- |C.MEM| must be greater than 0.
- |C.DATA| must be greater than x.
- C.DATA[x] must be equal to OK.
- Let mt be C.MEM[0].
- The instruction is valid with type ([I32, I32, I32] -> []).

validation_of_DATA.DROP x
- |C.DATA| must be greater than x.
- C.DATA[x] must be equal to OK.
- The instruction is valid with type ([] -> []).

validation_of_LOAD nt (n, sx)? { ALIGN: n_A; OFFSET: n_O; }
- |C.MEM| must be greater than 0.
- ((sx? is ?())) and ((n? is ?())) are equivalent.
- (2 ^ n_A) must be less than or equal to ($size(nt) / 8).
- If n is defined,
  - (2 ^ n_A) must be less than or equal to (n / 8).
  - (n / 8) must be less than ($size(nt) / 8).
- n? must be equal to ?().
- Let mt be C.MEM[0].
- The instruction is valid with type ([I32] -> [nt]).

validation_of_STORE nt n? { ALIGN: n_A; OFFSET: n_O; }
- |C.MEM| must be greater than 0.
- (2 ^ n_A) must be less than or equal to ($size(nt) / 8).
- If n is defined,
  - (2 ^ n_A) must be less than or equal to (n / 8).
  - (n / 8) must be less than ($size(nt) / 8).
- n? must be equal to ?().
- Let mt be C.MEM[0].
- The instruction is valid with type ([I32, nt] -> []).

validation_of_VLOAD ?((SHAPE M N sx)) { ALIGN: n_A; OFFSET: n_O; }
- |C.MEM| must be greater than 0.
- (2 ^ n_A) must be less than or equal to ((M / 8) · N).
- Let mt be C.MEM[0].
- The instruction is valid with type ([I32] -> [V128]).

validation_of_VLOAD_LANE N { ALIGN: n_A; OFFSET: n_O; } i
- |C.MEM| must be greater than 0.
- (2 ^ n_A) must be less than (N / 8).
- i must be less than (128 / N).
- Let mt be C.MEM[0].
- The instruction is valid with type ([I32, V128] -> [V128]).

validation_of_VSTORE { ALIGN: n_A; OFFSET: n_O; }
- |C.MEM| must be greater than 0.
- (2 ^ n_A) must be less than or equal to ($size(V128) / 8).
- Let mt be C.MEM[0].
- The instruction is valid with type ([I32, V128] -> []).

validation_of_VSTORE_LANE N { ALIGN: n_A; OFFSET: n_O; } i
- |C.MEM| must be greater than 0.
- (2 ^ n_A) must be less than (N / 8).
- i must be less than (128 / N).
- Let mt be C.MEM[0].
- The instruction is valid with type ([I32, V128] -> []).

Ki
1. Return 1024.

min n_u0 n_u1
1. If (n_u0 is 0), then:
  a. Return 0.
2. If (n_u1 is 0), then:
  a. Return 0.
3. Assert: Due to validation, (n_u0 ≥ 1).
4. Let i be (n_u0 - 1).
5. Assert: Due to validation, (n_u1 ≥ 1).
6. Let j be (n_u1 - 1).
7. Return $min(i, j).

sum n_u0*
1. If (n_u0* is []), then:
  a. Return 0.
2. Let [n] ++ n'* be n_u0*.
3. Return (n + $sum(n'*)).

concat_ X_u0*
1. If (X_u0* is []), then:
  a. Return [].
2. Let [w*] ++ w'** be X_u0*.
3. Return w* ++ $concat_(w'**).

signif N_u0
1. If (N_u0 is 32), then:
  a. Return 23.
2. Assert: Due to validation, (N_u0 is 64).
3. Return 52.

expon N_u0
1. If (N_u0 is 32), then:
  a. Return 8.
2. Assert: Due to validation, (N_u0 is 64).
3. Return 11.

M N
1. Return $signif(N).

E N
1. Return $expon(N).

fzero N
1. Return (POS (SUBNORM 0)).

fone N
1. Return (POS (NORM 1 0)).

canon_ N
1. Return (2 ^ ($signif(N) - 1)).

size valty_u0
1. If (valty_u0 is I32), then:
  a. Return 32.
2. If (valty_u0 is I64), then:
  a. Return 64.
3. If (valty_u0 is F32), then:
  a. Return 32.
4. If (valty_u0 is F64), then:
  a. Return 64.
5. If (valty_u0 is V128), then:
  a. Return 128.

psize packt_u0
1. If (packt_u0 is I8), then:
  a. Return 8.
2. Assert: Due to validation, (packt_u0 is I16).
3. Return 16.

lsize lanet_u0
1. If the type of lanet_u0 is numtype, then:
  a. Let numtype be lanet_u0.
  b. Return $size(numtype).
2. Assert: Due to validation, the type of lanet_u0 is packtype.
3. Let packtype be lanet_u0.
4. Return $psize(packtype).

lanetype (lnn X N)
1. Return lnn.

dim (lnn X N)
1. Return N.

shsize (lnn X N)
1. Return ($lsize(lnn) · N).

concat_bytes byte_u0*
1. If (byte_u0* is []), then:
  a. Return [].
2. Let [b*] ++ b'** be byte_u0*.
3. Return b* ++ $concat_bytes(b'**).

unpack lanet_u0
1. If the type of lanet_u0 is numtype, then:
  a. Let numtype be lanet_u0.
  b. Return numtype.
2. Assert: Due to validation, the type of lanet_u0 is packtype.
3. Return I32.

free_dataidx_instr instr_u0
1. If instr_u0 is of the case MEMORY.INIT, then:
  a. Let (MEMORY.INIT x) be instr_u0.
  b. Return [x].
2. If instr_u0 is of the case DATA.DROP, then:
  a. Let (DATA.DROP x) be instr_u0.
  b. Return [x].
3. Return [].

free_dataidx_instrs instr_u0*
1. If (instr_u0* is []), then:
  a. Return [].
2. Let [instr] ++ instr'* be instr_u0*.
3. Return $free_dataidx_instr(instr) ++ $free_dataidx_instrs(instr'*).

free_dataidx_expr in*
1. Return $free_dataidx_instrs(in*).

free_dataidx_func (FUNC x loc* e)
1. Return $free_dataidx_expr(e).

free_dataidx_funcs func_u0*
1. If (func_u0* is []), then:
  a. Return [].
2. Let [func] ++ func'* be func_u0*.
3. Return $free_dataidx_func(func) ++ $free_dataidx_funcs(func'*).

memop0
1. Return { ALIGN: 0; OFFSET: 0; }.

signed N i
1. If (0 ≤ (2 ^ (N - 1))), then:
  a. Return i.
2. Assert: Due to validation, ((2 ^ (N - 1)) ≤ i).
3. Assert: Due to validation, (i < (2 ^ N)).
4. Return (i - (2 ^ N)).

invsigned N i
1. Let j be $inverse_of_signed(N, i).
2. Return j.

unop numty_u1 unop__u0 num__u2
1. If (unop__u0 is CLZ), then:
  a. Let iN be num__u2.
  b. If the type of numty_u1 is inn, then:
    1) Let inn be numty_u1.
    2) Return [$iclz($size(inn), iN)].
2. If (unop__u0 is CTZ), then:
  a. Let iN be num__u2.
  b. If the type of numty_u1 is inn, then:
    1) Let inn be numty_u1.
    2) Return [$ictz($size(inn), iN)].
3. If (unop__u0 is POPCNT), then:
  a. Let iN be num__u2.
  b. If the type of numty_u1 is inn, then:
    1) Let inn be numty_u1.
    2) Return [$ipopcnt($size(inn), iN)].
4. If unop__u0 is of the case EXTEND, then:
  a. Let (EXTEND N) be unop__u0.
  b. Let iN be num__u2.
  c. If the type of numty_u1 is inn, then:
    1) Let inn be numty_u1.
    2) Return [$ext(N, $size(inn), S, $wrap($size(inn), N, iN))].
5. If (unop__u0 is ABS), then:
  a. Let fN be num__u2.
  b. If the type of numty_u1 is fnn, then:
    1) Let fnn be numty_u1.
    2) Return [$fabs($size(fnn), fN)].
6. If (unop__u0 is NEG), then:
  a. Let fN be num__u2.
  b. If the type of numty_u1 is fnn, then:
    1) Let fnn be numty_u1.
    2) Return [$fneg($size(fnn), fN)].
7. If (unop__u0 is SQRT), then:
  a. Let fN be num__u2.
  b. If the type of numty_u1 is fnn, then:
    1) Let fnn be numty_u1.
    2) Return [$fsqrt($size(fnn), fN)].
8. If (unop__u0 is CEIL), then:
  a. Let fN be num__u2.
  b. If the type of numty_u1 is fnn, then:
    1) Let fnn be numty_u1.
    2) Return [$fceil($size(fnn), fN)].
9. If (unop__u0 is FLOOR), then:
  a. Let fN be num__u2.
  b. If the type of numty_u1 is fnn, then:
    1) Let fnn be numty_u1.
    2) Return [$ffloor($size(fnn), fN)].
10. If (unop__u0 is TRUNC), then:
  a. Let fN be num__u2.
  b. If the type of numty_u1 is fnn, then:
    1) Let fnn be numty_u1.
    2) Return [$ftrunc($size(fnn), fN)].
11. Assert: Due to validation, (unop__u0 is NEAREST).
12. Let fN be num__u2.
13. Assert: Due to validation, the type of numty_u1 is fnn.
14. Let fnn be numty_u1.
15. Return [$fnearest($size(fnn), fN)].

binop numty_u1 binop_u0 num__u2 num__u3
1. If (binop_u0 is ADD), then:
  a. Let iN_1 be num__u2.
  b. Let iN_2 be num__u3.
  c. If the type of numty_u1 is inn, then:
    1) Let inn be numty_u1.
    2) Return [$iadd($size(inn), iN_1, iN_2)].
2. If (binop_u0 is SUB), then:
  a. Let iN_1 be num__u2.
  b. Let iN_2 be num__u3.
  c. If the type of numty_u1 is inn, then:
    1) Let inn be numty_u1.
    2) Return [$isub($size(inn), iN_1, iN_2)].
3. If (binop_u0 is MUL), then:
  a. Let iN_1 be num__u2.
  b. Let iN_2 be num__u3.
  c. If the type of numty_u1 is inn, then:
    1) Let inn be numty_u1.
    2) Return [$imul($size(inn), iN_1, iN_2)].
4. Let iN_1 be num__u2.
5. Let iN_2 be num__u3.
6. If the type of numty_u1 is inn, then:
  a. Let inn be numty_u1.
  b. If binop_u0 is of the case DIV, then:
    1) Let (DIV sx) be binop_u0.
    2) Return [$idiv($size(inn), sx, iN_1, iN_2)].
  c. If binop_u0 is of the case REM, then:
    1) Let (REM sx) be binop_u0.
    2) Return [$irem($size(inn), sx, iN_1, iN_2)].
7. If (binop_u0 is AND), then:
  a. Let iN_1 be num__u2.
  b. Let iN_2 be num__u3.
  c. If the type of numty_u1 is inn, then:
    1) Let inn be numty_u1.
    2) Return [$iand($size(inn), iN_1, iN_2)].
8. If (binop_u0 is OR), then:
  a. Let iN_1 be num__u2.
  b. Let iN_2 be num__u3.
  c. If the type of numty_u1 is inn, then:
    1) Let inn be numty_u1.
    2) Return [$ior($size(inn), iN_1, iN_2)].
9. If (binop_u0 is XOR), then:
  a. Let iN_1 be num__u2.
  b. Let iN_2 be num__u3.
  c. If the type of numty_u1 is inn, then:
    1) Let inn be numty_u1.
    2) Return [$ixor($size(inn), iN_1, iN_2)].
10. If (binop_u0 is SHL), then:
  a. Let iN_1 be num__u2.
  b. Let iN_2 be num__u3.
  c. If the type of numty_u1 is inn, then:
    1) Let inn be numty_u1.
    2) Return [$ishl($size(inn), iN_1, iN_2)].
11. Let iN_1 be num__u2.
12. Let iN_2 be num__u3.
13. If the type of numty_u1 is inn, then:
  a. Let inn be numty_u1.
  b. If binop_u0 is of the case SHR, then:
    1) Let (SHR sx) be binop_u0.
    2) Return [$ishr($size(inn), sx, iN_1, iN_2)].
14. If (binop_u0 is ROTL), then:
  a. Let iN_1 be num__u2.
  b. Let iN_2 be num__u3.
  c. If the type of numty_u1 is inn, then:
    1) Let inn be numty_u1.
    2) Return [$irotl($size(inn), iN_1, iN_2)].
15. If (binop_u0 is ROTR), then:
  a. Let iN_1 be num__u2.
  b. Let iN_2 be num__u3.
  c. If the type of numty_u1 is inn, then:
    1) Let inn be numty_u1.
    2) Return [$irotr($size(inn), iN_1, iN_2)].
16. If (binop_u0 is ADD), then:
  a. Let fN_1 be num__u2.
  b. Let fN_2 be num__u3.
  c. If the type of numty_u1 is fnn, then:
    1) Let fnn be numty_u1.
    2) Return [$fadd($size(fnn), fN_1, fN_2)].
17. If (binop_u0 is SUB), then:
  a. Let fN_1 be num__u2.
  b. Let fN_2 be num__u3.
  c. If the type of numty_u1 is fnn, then:
    1) Let fnn be numty_u1.
    2) Return [$fsub($size(fnn), fN_1, fN_2)].
18. If (binop_u0 is MUL), then:
  a. Let fN_1 be num__u2.
  b. Let fN_2 be num__u3.
  c. If the type of numty_u1 is fnn, then:
    1) Let fnn be numty_u1.
    2) Return [$fmul($size(fnn), fN_1, fN_2)].
19. If (binop_u0 is DIV), then:
  a. Let fN_1 be num__u2.
  b. Let fN_2 be num__u3.
  c. If the type of numty_u1 is fnn, then:
    1) Let fnn be numty_u1.
    2) Return [$fdiv($size(fnn), fN_1, fN_2)].
20. If (binop_u0 is MIN), then:
  a. Let fN_1 be num__u2.
  b. Let fN_2 be num__u3.
  c. If the type of numty_u1 is fnn, then:
    1) Let fnn be numty_u1.
    2) Return [$fmin($size(fnn), fN_1, fN_2)].
21. If (binop_u0 is MAX), then:
  a. Let fN_1 be num__u2.
  b. Let fN_2 be num__u3.
  c. If the type of numty_u1 is fnn, then:
    1) Let fnn be numty_u1.
    2) Return [$fmax($size(fnn), fN_1, fN_2)].
22. Assert: Due to validation, (binop_u0 is COPYSIGN).
23. Let fN_1 be num__u2.
24. Let fN_2 be num__u3.
25. Assert: Due to validation, the type of numty_u1 is fnn.
26. Let fnn be numty_u1.
27. Return [$fcopysign($size(fnn), fN_1, fN_2)].

testop inn EQZ iN
1. Return $ieqz($size(inn), iN).

relop numty_u1 relop_u0 num__u2 num__u3
1. If (relop_u0 is EQ), then:
  a. Let iN_1 be num__u2.
  b. Let iN_2 be num__u3.
  c. If the type of numty_u1 is inn, then:
    1) Let inn be numty_u1.
    2) Return $ieq($size(inn), iN_1, iN_2).
2. If (relop_u0 is NE), then:
  a. Let iN_1 be num__u2.
  b. Let iN_2 be num__u3.
  c. If the type of numty_u1 is inn, then:
    1) Let inn be numty_u1.
    2) Return $ine($size(inn), iN_1, iN_2).
3. Let iN_1 be num__u2.
4. Let iN_2 be num__u3.
5. If the type of numty_u1 is inn, then:
  a. Let inn be numty_u1.
  b. If relop_u0 is of the case LT, then:
    1) Let (LT sx) be relop_u0.
    2) Return $ilt($size(inn), sx, iN_1, iN_2).
  c. If relop_u0 is of the case GT, then:
    1) Let (GT sx) be relop_u0.
    2) Return $igt($size(inn), sx, iN_1, iN_2).
  d. If relop_u0 is of the case LE, then:
    1) Let (LE sx) be relop_u0.
    2) Return $ile($size(inn), sx, iN_1, iN_2).
  e. If relop_u0 is of the case GE, then:
    1) Let (GE sx) be relop_u0.
    2) Return $ige($size(inn), sx, iN_1, iN_2).
6. If (relop_u0 is EQ), then:
  a. Let fN_1 be num__u2.
  b. Let fN_2 be num__u3.
  c. If the type of numty_u1 is fnn, then:
    1) Let fnn be numty_u1.
    2) Return $feq($size(fnn), fN_1, fN_2).
7. If (relop_u0 is NE), then:
  a. Let fN_1 be num__u2.
  b. Let fN_2 be num__u3.
  c. If the type of numty_u1 is fnn, then:
    1) Let fnn be numty_u1.
    2) Return $fne($size(fnn), fN_1, fN_2).
8. If (relop_u0 is LT), then:
  a. Let fN_1 be num__u2.
  b. Let fN_2 be num__u3.
  c. If the type of numty_u1 is fnn, then:
    1) Let fnn be numty_u1.
    2) Return $flt($size(fnn), fN_1, fN_2).
9. If (relop_u0 is GT), then:
  a. Let fN_1 be num__u2.
  b. Let fN_2 be num__u3.
  c. If the type of numty_u1 is fnn, then:
    1) Let fnn be numty_u1.
    2) Return $fgt($size(fnn), fN_1, fN_2).
10. If (relop_u0 is LE), then:
  a. Let fN_1 be num__u2.
  b. Let fN_2 be num__u3.
  c. If the type of numty_u1 is fnn, then:
    1) Let fnn be numty_u1.
    2) Return $fle($size(fnn), fN_1, fN_2).
11. Assert: Due to validation, (relop_u0 is GE).
12. Let fN_1 be num__u2.
13. Let fN_2 be num__u3.
14. Assert: Due to validation, the type of numty_u1 is fnn.
15. Let fnn be numty_u1.
16. Return $fge($size(fnn), fN_1, fN_2).

cvtop numty_u0 numty_u1 cvtop_u4 sx_u2? num__u3
1. If ((numty_u0 is I32) and ((numty_u1 is I64) and (cvtop_u4 is CONVERT))), then:
  a. Let iN be num__u3.
  b. If sx_u2? is defined, then:
    1) Let ?(sx) be sx_u2?.
    2) Return [$ext(32, 64, sx, iN)].
2. If ((numty_u0 is I64) and ((numty_u1 is I32) and (cvtop_u4 is CONVERT))), then:
  a. Let iN be num__u3.
  b. Return [$wrap(64, 32, iN)].
3. If (cvtop_u4 is CONVERT), then:
  a. Let fN be num__u3.
  b. If the type of numty_u0 is fnn, then:
    1) Let fnn be numty_u0.
    2) If the type of numty_u1 is inn, then:
      a) Let inn be numty_u1.
      b) If sx_u2? is defined, then:
        1. Let ?(sx) be sx_u2?.
        2. Return [$trunc($size(fnn), $size(inn), sx, fN)].
4. If (cvtop_u4 is CONVERT_SAT), then:
  a. Let fN be num__u3.
  b. If the type of numty_u0 is fnn, then:
    1) Let fnn be numty_u0.
    2) If the type of numty_u1 is inn, then:
      a) Let inn be numty_u1.
      b) If sx_u2? is defined, then:
        1. Let ?(sx) be sx_u2?.
        2. Return [$trunc_sat($size(fnn), $size(inn), sx, fN)].
5. If ((numty_u0 is F32) and ((numty_u1 is F64) and (cvtop_u4 is CONVERT))), then:
  a. Let fN be num__u3.
  b. Return [$promote(32, 64, fN)].
6. If ((numty_u0 is F64) and ((numty_u1 is F32) and (cvtop_u4 is CONVERT))), then:
  a. Let fN be num__u3.
  b. Return [$demote(64, 32, fN)].
7. Assert: Due to validation, (cvtop_u4 is CONVERT).
8. If the type of numty_u1 is fnn, then:
  a. Let fnn be numty_u1.
  b. Let iN be num__u3.
  c. If the type of numty_u0 is inn, then:
    1) Let inn be numty_u0.
    2) If sx_u2? is defined, then:
      a) Let ?(sx) be sx_u2?.
      b) Return [$convert($size(inn), $size(fnn), sx, iN)].
    3) If ($size(inn) is $size(fnn)), then:
      a) Return [$reinterpret(inn, fnn, iN)].
9. Let fN be num__u3.
10. Assert: Due to validation, the type of numty_u0 is fnn.
11. Let fnn be numty_u0.
12. Assert: Due to validation, the type of numty_u1 is inn.
13. Let inn be numty_u1.
14. Assert: Due to validation, ($size(inn) is $size(fnn)).
15. Return [$reinterpret(fnn, inn, fN)].

invibytes N b*
1. Let n be $inverse_of_ibytes(N, b*).
2. Return n.

invfbytes N b*
1. Let p be $inverse_of_fbytes(N, b*).
2. Return p.

packnum lanet_u0 c
1. If the type of lanet_u0 is numtype, then:
  a. Return c.
2. Assert: Due to validation, the type of lanet_u0 is packtype.
3. Let packtype be lanet_u0.
4. Return $wrap($size($unpack(packtype)), $psize(packtype), c).

unpacknum lanet_u0 c
1. If the type of lanet_u0 is numtype, then:
  a. Return c.
2. Assert: Due to validation, the type of lanet_u0 is packtype.
3. Let packtype be lanet_u0.
4. Return $ext($psize(packtype), $size($unpack(packtype)), U, c).

invlanes_ sh c*
1. Let vc be $inverse_of_lanes_(sh, c*).
2. Return vc.

halfop half_u0 i j
1. If (half_u0 is LOW), then:
  a. Return i.
2. Assert: Due to validation, (half_u0 is HIGH).
3. Return j.

default valty_u0
1. If (valty_u0 is I32), then:
  a. Return (I32.CONST 0).
2. If (valty_u0 is I64), then:
  a. Return (I64.CONST 0).
3. If (valty_u0 is F32), then:
  a. Return (F32.CONST $fzero(32)).
4. If (valty_u0 is F64), then:
  a. Return (F64.CONST $fzero(64)).
5. If (valty_u0 is V128), then:
  a. Return (V128.CONST 0).
6. If (valty_u0 is FUNCREF), then:
  a. Return (REF.NULL FUNCREF).
7. Assert: Due to validation, (valty_u0 is EXTERNREF).
8. Return (REF.NULL EXTERNREF).

funcsxv exter_u0*
1. If (exter_u0* is []), then:
  a. Return [].
2. Let [y_0] ++ xv* be exter_u0*.
3. If y_0 is of the case FUNC, then:
  a. Let (FUNC fa) be y_0.
  b. Return [fa] ++ $funcsxv(xv*).
4. Let [externval] ++ xv* be exter_u0*.
5. Return $funcsxv(xv*).

globalsxv exter_u0*
1. If (exter_u0* is []), then:
  a. Return [].
2. Let [y_0] ++ xv* be exter_u0*.
3. If y_0 is of the case GLOBAL, then:
  a. Let (GLOBAL ga) be y_0.
  b. Return [ga] ++ $globalsxv(xv*).
4. Let [externval] ++ xv* be exter_u0*.
5. Return $globalsxv(xv*).

tablesxv exter_u0*
1. If (exter_u0* is []), then:
  a. Return [].
2. Let [y_0] ++ xv* be exter_u0*.
3. If y_0 is of the case TABLE, then:
  a. Let (TABLE ta) be y_0.
  b. Return [ta] ++ $tablesxv(xv*).
4. Let [externval] ++ xv* be exter_u0*.
5. Return $tablesxv(xv*).

memsxv exter_u0*
1. If (exter_u0* is []), then:
  a. Return [].
2. Let [y_0] ++ xv* be exter_u0*.
3. If y_0 is of the case MEM, then:
  a. Let (MEM ma) be y_0.
  b. Return [ma] ++ $memsxv(xv*).
4. Let [externval] ++ xv* be exter_u0*.
5. Return $memsxv(xv*).

store
1. Return.

frame
1. Let f be the current frame.
2. Return f.

funcaddr
1. Let f be the current frame.
2. Return f.MODULE.FUNC.

funcinst
1. Return s.FUNC.

globalinst
1. Return s.GLOBAL.

tableinst
1. Return s.TABLE.

meminst
1. Return s.MEM.

eleminst
1. Return s.ELEM.

datainst
1. Return s.DATA.

moduleinst
1. Let f be the current frame.
2. Return f.MODULE.

type x
1. Let f be the current frame.
2. Return f.MODULE.TYPE[x].

func x
1. Let f be the current frame.
2. Return s.FUNC[f.MODULE.FUNC[x]].

global x
1. Let f be the current frame.
2. Return s.GLOBAL[f.MODULE.GLOBAL[x]].

table x
1. Let f be the current frame.
2. Return s.TABLE[f.MODULE.TABLE[x]].

mem x
1. Let f be the current frame.
2. Return s.MEM[f.MODULE.MEM[x]].

elem x
1. Let f be the current frame.
2. Return s.ELEM[f.MODULE.ELEM[x]].

data x
1. Let f be the current frame.
2. Return s.DATA[f.MODULE.DATA[x]].

local x
1. Let f be the current frame.
2. Return f.LOCAL[x].

with_local x v
1. Let f be the current frame.
2. Replace f.LOCAL[x] with v.

with_global x v
1. Let f be the current frame.
2. Replace s.GLOBAL[f.MODULE.GLOBAL[x]].VALUE with v.

with_table x i r
1. Let f be the current frame.
2. Replace s.TABLE[f.MODULE.TABLE[x]].ELEM[i] with r.

with_tableinst x ti
1. Let f be the current frame.
2. Replace s.TABLE[f.MODULE.TABLE[x]] with ti.

with_mem x i j b*
1. Let f be the current frame.
2. Replace s.MEM[f.MODULE.MEM[x]].DATA[i : j] with b*.

with_meminst x mi
1. Let f be the current frame.
2. Replace s.MEM[f.MODULE.MEM[x]] with mi.

with_elem x r*
1. Let f be the current frame.
2. Replace s.ELEM[f.MODULE.ELEM[x]].ELEM with r*.

with_data x b*
1. Let f be the current frame.
2. Replace s.DATA[f.MODULE.DATA[x]].DATA with b*.

growtable ti n r
1. Let { TYPE: ((i, j), rt); ELEM: r'*; } be ti.
2. Let i' be (|r'*| + n).
3. If (i' ≤ j), then:
  a. Let ti' be { TYPE: ((i', j), rt); ELEM: r'* ++ r^n; }.
  b. Return ti'.

growmemory mi n
1. Let { TYPE: (I8 (i, j)); DATA: b*; } be mi.
2. Let i' be ((|b*| / (64 · $Ki())) + n).
3. If (i' ≤ j), then:
  a. Let mi' be { TYPE: (I8 (i', j)); DATA: b* ++ 0^((n · 64) · $Ki()); }.
  b. Return mi'.

blocktype block_u1
1. If (block_u1 is (_RESULT ?())), then:
  a. Return ([] -> []).
2. If block_u1 is of the case _RESULT, then:
  a. Let (_RESULT y_0) be block_u1.
  b. If y_0 is defined, then:
    1) Let ?(t) be y_0.
    2) Return ([] -> [t]).
3. Assert: Due to validation, block_u1 is of the case _IDX.
4. Let (_IDX x) be block_u1.
5. Return $type(x).

funcs exter_u0*
1. If (exter_u0* is []), then:
  a. Return [].
2. Let [y_0] ++ externval'* be exter_u0*.
3. If y_0 is of the case FUNC, then:
  a. Let (FUNC fa) be y_0.
  b. Return [fa] ++ $funcs(externval'*).
4. Let [externval] ++ externval'* be exter_u0*.
5. Return $funcs(externval'*).

globals exter_u0*
1. If (exter_u0* is []), then:
  a. Return [].
2. Let [y_0] ++ externval'* be exter_u0*.
3. If y_0 is of the case GLOBAL, then:
  a. Let (GLOBAL ga) be y_0.
  b. Return [ga] ++ $globals(externval'*).
4. Let [externval] ++ externval'* be exter_u0*.
5. Return $globals(externval'*).

tables exter_u0*
1. If (exter_u0* is []), then:
  a. Return [].
2. Let [y_0] ++ externval'* be exter_u0*.
3. If y_0 is of the case TABLE, then:
  a. Let (TABLE ta) be y_0.
  b. Return [ta] ++ $tables(externval'*).
4. Let [externval] ++ externval'* be exter_u0*.
5. Return $tables(externval'*).

mems exter_u0*
1. If (exter_u0* is []), then:
  a. Return [].
2. Let [y_0] ++ externval'* be exter_u0*.
3. If y_0 is of the case MEM, then:
  a. Let (MEM ma) be y_0.
  b. Return [ma] ++ $mems(externval'*).
4. Let [externval] ++ externval'* be exter_u0*.
5. Return $mems(externval'*).

allocfunc mm func
1. Assert: Due to validation, func is of the case FUNC.
2. Let (FUNC x local* expr) be func.
3. Let fi be { TYPE: mm.TYPE[x]; MODULE: mm; CODE: func; }.
4. Let a be |s.FUNC|.
5. Append fi to the s.FUNC.
6. Return a.

allocfuncs mm func_u0*
1. If (func_u0* is []), then:
  a. Return [].
2. Let [func] ++ func'* be func_u0*.
3. Let fa be $allocfunc(mm, func).
4. Let fa'* be $allocfuncs(mm, func'*).
5. Return [fa] ++ fa'*.

allocglobal globaltype val
1. Let gi be { TYPE: globaltype; VALUE: val; }.
2. Let a be |s.GLOBAL|.
3. Append gi to the s.GLOBAL.
4. Return a.

allocglobals globa_u0* val_u1*
1. If (globa_u0* is []), then:
  a. Assert: Due to validation, (val_u1* is []).
  b. Return [].
2. Else:
  a. Let [globaltype] ++ globaltype'* be globa_u0*.
  b. Assert: Due to validation, (|val_u1*| ≥ 1).
  c. Let [val] ++ val'* be val_u1*.
  d. Let ga be $allocglobal(globaltype, val).
  e. Let ga'* be $allocglobals(globaltype'*, val'*).
  f. Return [ga] ++ ga'*.

alloctable ((i, j), rt)
1. Let ti be { TYPE: ((i, j), rt); ELEM: (REF.NULL rt)^i; }.
2. Let a be |s.TABLE|.
3. Append ti to the s.TABLE.
4. Return a.

alloctables table_u0*
1. If (table_u0* is []), then:
  a. Return [].
2. Let [tabletype] ++ tabletype'* be table_u0*.
3. Let ta be $alloctable(tabletype).
4. Let ta'* be $alloctables(tabletype'*).
5. Return [ta] ++ ta'*.

allocmem (I8 (i, j))
1. Let mi be { TYPE: (I8 (i, j)); DATA: 0^((i · 64) · $Ki()); }.
2. Let a be |s.MEM|.
3. Append mi to the s.MEM.
4. Return a.

allocmems memty_u0*
1. If (memty_u0* is []), then:
  a. Return [].
2. Let [memtype] ++ memtype'* be memty_u0*.
3. Let ma be $allocmem(memtype).
4. Let ma'* be $allocmems(memtype'*).
5. Return [ma] ++ ma'*.

allocelem rt ref*
1. Let ei be { TYPE: rt; ELEM: ref*; }.
2. Let a be |s.ELEM|.
3. Append ei to the s.ELEM.
4. Return a.

allocelems refty_u0* ref_u1*
1. If ((refty_u0* is []) and (ref_u1* is [])), then:
  a. Return [].
2. Assert: Due to validation, (|ref_u1*| ≥ 1).
3. Let [ref*] ++ ref'** be ref_u1*.
4. Assert: Due to validation, (|refty_u0*| ≥ 1).
5. Let [rt] ++ rt'* be refty_u0*.
6. Let ea be $allocelem(rt, ref*).
7. Let ea'* be $allocelems(rt'*, ref'**).
8. Return [ea] ++ ea'*.

allocdata byte*
1. Let di be { DATA: byte*; }.
2. Let a be |s.DATA|.
3. Append di to the s.DATA.
4. Return a.

allocdatas byte_u0*
1. If (byte_u0* is []), then:
  a. Return [].
2. Let [byte*] ++ byte'** be byte_u0*.
3. Let da be $allocdata(byte*).
4. Let da'* be $allocdatas(byte'**).
5. Return [da] ++ da'*.

instexport fa* ga* ta* ma* (EXPORT name exter_u0)
1. If exter_u0 is of the case FUNC, then:
  a. Let (FUNC x) be exter_u0.
  b. Return { NAME: name; VALUE: (FUNC fa*[x]); }.
2. If exter_u0 is of the case GLOBAL, then:
  a. Let (GLOBAL x) be exter_u0.
  b. Return { NAME: name; VALUE: (GLOBAL ga*[x]); }.
3. If exter_u0 is of the case TABLE, then:
  a. Let (TABLE x) be exter_u0.
  b. Return { NAME: name; VALUE: (TABLE ta*[x]); }.
4. Assert: Due to validation, exter_u0 is of the case MEM.
5. Let (MEM x) be exter_u0.
6. Return { NAME: name; VALUE: (MEM ma*[x]); }.

allocmodule module externval* val* ref**
1. Let fa_ex* be $funcs(externval*).
2. Let ga_ex* be $globals(externval*).
3. Let ma_ex* be $mems(externval*).
4. Let ta_ex* be $tables(externval*).
5. Assert: Due to validation, module is of the case MODULE.
6. Let (MODULE y_0 import* func^n_func y_1 y_2 y_3 y_4 y_5 start? export*) be module.
7. Let (DATA byte* datamode)^n_data be y_5.
8. Let (ELEM rt expr_2* elemmode)^n_elem be y_4.
9. Let (MEMORY memtype)^n_mem be y_3.
10. Let (TABLE tabletype)^n_table be y_2.
11. Let (GLOBAL globaltype expr_1)^n_global be y_1.
12. Let (TYPE ft)* be y_0.
13. Let fa* be (|s.FUNC| + i_func)^(i_func<n_func).
14. Let ga* be (|s.GLOBAL| + i_global)^(i_global<n_global).
15. Let ta* be (|s.TABLE| + i_table)^(i_table<n_table).
16. Let ma* be (|s.MEM| + i_mem)^(i_mem<n_mem).
17. Let ea* be (|s.ELEM| + i_elem)^(i_elem<n_elem).
18. Let da* be (|s.DATA| + i_data)^(i_data<n_data).
19. Let xi* be $instexport(fa_ex* ++ fa*, ga_ex* ++ ga*, ta_ex* ++ ta*, ma_ex* ++ ma*, export)*.
20. Let mm be { TYPE: ft*; FUNC: fa_ex* ++ fa*; GLOBAL: ga_ex* ++ ga*; TABLE: ta_ex* ++ ta*; MEM: ma_ex* ++ ma*; ELEM: ea*; DATA: da*; EXPORT: xi*; }.
21. Let y_0 be $allocfuncs(mm, func^n_func).
22. Assert: Due to validation, (y_0 is fa*).
23. Let y_0 be $allocglobals(globaltype^n_global, val*).
24. Assert: Due to validation, (y_0 is ga*).
25. Let y_0 be $alloctables(tabletype^n_table).
26. Assert: Due to validation, (y_0 is ta*).
27. Let y_0 be $allocmems(memtype^n_mem).
28. Assert: Due to validation, (y_0 is ma*).
29. Let y_0 be $allocelems(rt^n_elem, ref**).
30. Assert: Due to validation, (y_0 is ea*).
31. Let y_0 be $allocdatas(byte*^n_data).
32. Assert: Due to validation, (y_0 is da*).
33. Return mm.

runelem (ELEM reftype expr* elemm_u0) i
1. If (elemm_u0 is PASSIVE), then:
  a. Return [].
2. If (elemm_u0 is DECLARE), then:
  a. Return [(ELEM.DROP i)].
3. Assert: Due to validation, elemm_u0 is of the case ACTIVE.
4. Let (ACTIVE x instr*) be elemm_u0.
5. Let n be |expr*|.
6. Return instr* ++ [(I32.CONST 0), (I32.CONST n), (TABLE.INIT x i), (ELEM.DROP i)].

rundata (DATA byte* datam_u0) i
1. If (datam_u0 is PASSIVE), then:
  a. Return [].
2. Assert: Due to validation, datam_u0 is of the case ACTIVE.
3. Let (ACTIVE y_0 instr*) be datam_u0.
4. Assert: Due to validation, (y_0 is 0).
5. Let n be |byte*|.
6. Return instr* ++ [(I32.CONST 0), (I32.CONST n), (MEMORY.INIT i), (DATA.DROP i)].

instantiate module externval*
1. Assert: Due to validation, module is of the case MODULE.
2. Let (MODULE type* import* func* global* table* mem* elem* data* start? export*) be module.
3. Let (TYPE functype)* be type*.
4. Let n_D be |data*|.
5. Let n_E be |elem*|.
6. Let n_F be |func*|.
7. Let (START x)? be start?.
8. Let (GLOBAL globaltype expr_G)* be global*.
9. Let (ELEM reftype expr_E* elemmode)* be elem*.
10. Let instr_D* be $concat_($rundata(data*[j], j)^(j<n_D)).
11. Let instr_E* be $concat_($runelem(elem*[i], i)^(i<n_E)).
12. Let mm_init be { TYPE: functype*; FUNC: $funcs(externval*) ++ (|s.FUNC| + i_F)^(i_F<n_F); GLOBAL: $globals(externval*); TABLE: []; MEM: []; ELEM: []; DATA: []; EXPORT: []; }.
13. Let f_init be { LOCAL: []; MODULE: mm_init; }.
14. Let z be f_init.
15. Push the activation of z to the stack.
16. Let [val]* be $eval_expr(expr_G)*.
17. Pop the activation of z from the stack.
18. Push the activation of z to the stack.
19. Let [ref]** be $eval_expr(expr_E)**.
20. Pop the activation of z from the stack.
21. Let mm be $allocmodule(module, externval*, val*, ref**).
22. Let f be { LOCAL: []; MODULE: mm; }.
23. Enter the activation of f with arity 0 with label [FRAME_]:
  a. Execute the sequence (instr_E*).
  b. Execute the sequence (instr_D*).
  c. If x is defined, then:
    1) Let ?(x_0) be x.
    2) Execute (CALL x_0).
24. Return mm.

invoke fa val^n
1. Let f be { LOCAL: []; MODULE: { TYPE: []; FUNC: []; GLOBAL: []; TABLE: []; MEM: []; ELEM: []; DATA: []; EXPORT: []; }; }.
2. Let (t_1^n -> t_2*) be $funcinst()[fa].TYPE.
3. Let k be |t_2*|.
4. Enter the activation of f with arity k with label [FRAME_]:
  a. Push val^n to the stack.
  b. Execute (CALL_ADDR fa).
5. Pop val^k from the stack.
6. Return val^k.

utf8 name_u0
1. If (|name_u0| is 1), then:
  a. Let [ch] be name_u0.
  b. If ((ch < 128) and the type of ch is byte), then:
    1) Let b be ch.
    2) Return [b].
  c. If ((128 ≤ ch) and ((ch < 2048) and (ch ≥ (b_2 - 128)))), then:
    1) Let ((2 ^ 6) · (b_1 - 192)) be (ch - (b_2 - 128)).
    2) Return [b_1, b_2].
  d. If ((((2048 ≤ ch) and (ch < 55296)) or ((57344 ≤ ch) and (ch < 65536))) and (ch ≥ (b_3 - 128))), then:
    1) Let (((2 ^ 12) · (b_1 - 224)) + ((2 ^ 6) · (b_2 - 128))) be (ch - (b_3 - 128)).
    2) Return [b_1, b_2, b_3].
  e. If ((65536 ≤ ch) and ((ch < 69632) and (ch ≥ (b_4 - 128)))), then:
    1) Let ((((2 ^ 18) · (b_1 - 240)) + ((2 ^ 12) · (b_2 - 128))) + ((2 ^ 6) · (b_3 - 128))) be (ch - (b_4 - 128)).
    2) Return [b_1, b_2, b_3, b_4].
2. Let ch* be name_u0.
3. Return $concat_($utf8([ch])*).

execution_of_UNREACHABLE
1. Trap.

execution_of_NOP
1. Do nothing.

execution_of_DROP
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop val from the stack.
3. Do nothing.

execution_of_SELECT t*?
1. Assert: Due to validation, a value of value type I32 is on the top of the stack.
2. Pop (I32.CONST c) from the stack.
3. Assert: Due to validation, a value is on the top of the stack.
4. Pop val_2 from the stack.
5. Assert: Due to validation, a value is on the top of the stack.
6. Pop val_1 from the stack.
7. If (c is not 0), then:
  a. Push val_1 to the stack.
8. Else:
  a. Push val_2 to the stack.

execution_of_IF bt instr_1* instr_2*
1. Assert: Due to validation, a value of value type I32 is on the top of the stack.
2. Pop (I32.CONST c) from the stack.
3. If (c is not 0), then:
  a. Execute (BLOCK bt instr_1*).
4. Else:
  a. Execute (BLOCK bt instr_2*).

execution_of_LABEL_
1. Pop all values val* from the stack.
2. Assert: Due to validation, a label is now on the top of the stack.
3. Exit current context.
4. Push val* to the stack.

execution_of_BR label_u0
1. Let L be the current label.
2. Let n be the arity of L.
3. Let instr'* be the continuation of L.
4. Pop all values admin_u1* from the stack.
5. Exit current context.
6. If ((label_u0 is 0) and (|admin_u1*| ≥ n)), then:
  a. Let val'* ++ val^n be admin_u1*.
  b. Push val^n to the stack.
  c. Execute the sequence (instr'*).
7. If (label_u0 ≥ 1), then:
  a. Let l be (label_u0 - 1).
  b. Let val* be admin_u1*.
  c. Push val* to the stack.
  d. Execute (BR l).

execution_of_BR_IF l
1. Assert: Due to validation, a value of value type I32 is on the top of the stack.
2. Pop (I32.CONST c) from the stack.
3. If (c is not 0), then:
  a. Execute (BR l).
4. Else:
  a. Do nothing.

execution_of_BR_TABLE l* l'
1. Assert: Due to validation, a value of value type I32 is on the top of the stack.
2. Pop (I32.CONST i) from the stack.
3. If (i < |l*|), then:
  a. Execute (BR l*[i]).
4. Else:
  a. Execute (BR l').

execution_of_FRAME_
1. Let f be the current frame.
2. Let n be the arity of f.
3. Assert: Due to validation, there are at least n values on the top of the stack.
4. Pop val^n from the stack.
5. Assert: Due to validation, a frame is now on the top of the stack.
6. Exit current context.
7. Push val^n to the stack.

execution_of_RETURN
1. If the current context is frame, then:
  a. Let F be the current frame.
  b. Let n be the arity of F.
  c. Pop val^n from the stack.
  d. Pop all values val'* from the stack.
  e. Exit current context.
  f. Push val^n to the stack.
2. Else if the current context is label, then:
  a. Pop all values val* from the stack.
  b. Exit current context.
  c. Push val* to the stack.
  d. Execute RETURN.

execution_of_UNOP nt unop
1. Assert: Due to validation, a value of value type nt is on the top of the stack.
2. Pop (nt.CONST c_1) from the stack.
3. If (|$unop(nt, unop, c_1)| is 1), then:
  a. Let [c] be $unop(nt, unop, c_1).
  b. Push (nt.CONST c) to the stack.
4. If ($unop(nt, unop, c_1) is []), then:
  a. Trap.

execution_of_BINOP nt binop
1. Assert: Due to validation, a value of value type nt is on the top of the stack.
2. Pop (nt.CONST c_2) from the stack.
3. Assert: Due to validation, a value of value type nt is on the top of the stack.
4. Pop (nt.CONST c_1) from the stack.
5. If (|$binop(nt, binop, c_1, c_2)| is 1), then:
  a. Let [c] be $binop(nt, binop, c_1, c_2).
  b. Push (nt.CONST c) to the stack.
6. If ($binop(nt, binop, c_1, c_2) is []), then:
  a. Trap.

execution_of_TESTOP nt testop
1. Assert: Due to validation, a value of value type nt is on the top of the stack.
2. Pop (nt.CONST c_1) from the stack.
3. Let c be $testop(nt, testop, c_1).
4. Push (I32.CONST c) to the stack.

execution_of_RELOP nt relop
1. Assert: Due to validation, a value of value type nt is on the top of the stack.
2. Pop (nt.CONST c_2) from the stack.
3. Assert: Due to validation, a value of value type nt is on the top of the stack.
4. Pop (nt.CONST c_1) from the stack.
5. Let c be $relop(nt, relop, c_1, c_2).
6. Push (I32.CONST c) to the stack.

execution_of_CVTOP nt_2 cvtop nt_1 sx?
1. Assert: Due to validation, a value of value type nt_1 is on the top of the stack.
2. Pop (nt_1.CONST c_1) from the stack.
3. If (|$cvtop(nt_1, nt_2, cvtop, sx?, c_1)| is 1), then:
  a. Let [c] be $cvtop(nt_1, nt_2, cvtop, sx?, c_1).
  b. Push (nt_2.CONST c) to the stack.
4. If ($cvtop(nt_1, nt_2, cvtop, sx?, c_1) is []), then:
  a. Trap.

execution_of_REF.IS_NULL
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop val from the stack.
3. If val is of the case REF.NULL, then:
  a. Push (I32.CONST 1) to the stack.
4. Else:
  a. Push (I32.CONST 0) to the stack.

execution_of_VVUNOP V128 vvunop
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop (V128.CONST c_1) from the stack.
3. Let c be $vvunop(V128, vvunop, c_1).
4. Push (V128.CONST c) to the stack.

execution_of_VVBINOP V128 vvbinop
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop (V128.CONST c_2) from the stack.
3. Assert: Due to validation, a value is on the top of the stack.
4. Pop (V128.CONST c_1) from the stack.
5. Let c be $vvbinop(V128, vvbinop, c_1, c_2).
6. Push (V128.CONST c) to the stack.

execution_of_VVTERNOP V128 vvternop
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop (V128.CONST c_3) from the stack.
3. Assert: Due to validation, a value is on the top of the stack.
4. Pop (V128.CONST c_2) from the stack.
5. Assert: Due to validation, a value is on the top of the stack.
6. Pop (V128.CONST c_1) from the stack.
7. Let c be $vvternop(V128, vvternop, c_1, c_2, c_3).
8. Push (V128.CONST c) to the stack.

execution_of_VVTESTOP V128 ANY_TRUE
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop (V128.CONST c_1) from the stack.
3. Let c be $ine($size(V128), c_1, 0).
4. Push (I32.CONST c) to the stack.

execution_of_VSWIZZLE (inn X N)
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop (V128.CONST c_2) from the stack.
3. Assert: Due to validation, a value is on the top of the stack.
4. Pop (V128.CONST c_1) from the stack.
5. Let c* be $lanes_((inn X N), c_1) ++ 0^(256 - N).
6. Let ci* be $lanes_((inn X N), c_2).
7. Assert: Due to validation, (ci*[k] < |c*|)^(k<N).
8. Assert: Due to validation, (k < |ci*|)^(k<N).
9. Let c' be $invlanes_((inn X N), c*[ci*[k]]^(k<N)).
10. Push (V128.CONST c') to the stack.

execution_of_VSHUFFLE (inn X N) i*
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop (V128.CONST c_2) from the stack.
3. Assert: Due to validation, a value is on the top of the stack.
4. Pop (V128.CONST c_1) from the stack.
5. Assert: Due to validation, (k < |i*|)^(k<N).
6. Let c'* be $lanes_((inn X N), c_1) ++ $lanes_((inn X N), c_2).
7. Assert: Due to validation, (i*[k] < |c'*|)^(k<N).
8. Let c be $invlanes_((inn X N), c'*[i*[k]]^(k<N)).
9. Push (V128.CONST c) to the stack.

execution_of_VSPLAT (lnn X N)
1. Assert: Due to validation, a value of value type $unpack(lnn) is on the top of the stack.
2. Pop (nt_0.CONST c_1) from the stack.
3. Let c be $invlanes_((lnn X N), $packnum(lnn, c_1)^N).
4. Push (V128.CONST c) to the stack.

execution_of_VEXTRACT_LANE (lanet_u0 X N) sx_u1? i
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop (V128.CONST c_1) from the stack.
3. If (sx_u1? is not defined and the type of lanet_u0 is numtype), then:
  a. Let nt be lanet_u0.
  b. If (i < |$lanes_((nt X N), c_1)|), then:
    1) Let c_2 be $lanes_((nt X N), c_1)[i].
    2) Push (nt.CONST c_2) to the stack.
4. If the type of lanet_u0 is packtype, then:
  a. Let pt be lanet_u0.
  b. If sx_u1? is defined, then:
    1) Let ?(sx) be sx_u1?.
    2) If (i < |$lanes_((pt X N), c_1)|), then:
      a) Let c_2 be $ext($psize(pt), 32, sx, $lanes_((pt X N), c_1)[i]).
      b) Push (I32.CONST c_2) to the stack.

execution_of_VREPLACE_LANE (lnn X N) i
1. Assert: Due to validation, a value of value type $unpack(lnn) is on the top of the stack.
2. Pop (nt_0.CONST c_2) from the stack.
3. Assert: Due to validation, a value is on the top of the stack.
4. Pop (V128.CONST c_1) from the stack.
5. Let c be $invlanes_((lnn X N), $lanes_((lnn X N), c_1) with [i] replaced by $packnum(lnn, c_2)).
6. Push (V128.CONST c) to the stack.

execution_of_VUNOP sh vunop
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop (V128.CONST c_1) from the stack.
3. Let c be $vunop(sh, vunop, c_1).
4. Push (V128.CONST c) to the stack.

execution_of_VBINOP sh vbinop
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop (V128.CONST c_2) from the stack.
3. Assert: Due to validation, a value is on the top of the stack.
4. Pop (V128.CONST c_1) from the stack.
5. If (|$vbinop(sh, vbinop, c_1, c_2)| is 1), then:
  a. Let [c] be $vbinop(sh, vbinop, c_1, c_2).
  b. Push (V128.CONST c) to the stack.
6. If ($vbinop(sh, vbinop, c_1, c_2) is []), then:
  a. Trap.

execution_of_VRELOP sh vrelop
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop (V128.CONST c_2) from the stack.
3. Assert: Due to validation, a value is on the top of the stack.
4. Pop (V128.CONST c_1) from the stack.
5. Let c be $vrelop(sh, vrelop, c_1, c_2).
6. Push (V128.CONST c) to the stack.

execution_of_VSHIFTOP (imm X N) vshiftop
1. Assert: Due to validation, a value of value type I32 is on the top of the stack.
2. Pop (I32.CONST n) from the stack.
3. Assert: Due to validation, a value is on the top of the stack.
4. Pop (V128.CONST c_1) from the stack.
5. Let ci* be $lanes_((imm X N), c_1).
6. Let c be $invlanes_((imm X N), $vishiftop((imm X N), vshiftop, ci, n)*).
7. Push (V128.CONST c) to the stack.

execution_of_VTESTOP (inn X N) ALL_TRUE
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop (V128.CONST c) from the stack.
3. Let ci* be $lanes_((inn X N), c).
4. If (ci is not 0)*, then:
  a. Push (I32.CONST 1) to the stack.
5. Else:
  a. Push (I32.CONST 0) to the stack.

execution_of_VBITMASK (inn X N)
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop (V128.CONST c) from the stack.
3. Let ci* be $lanes_((inn X N), c).
4. Let i be $inverse_of_ibits(32, $ilt($size(inn), S, ci, 0)*).
5. Push (I32.CONST i) to the stack.

execution_of_VNARROW (inn_1 X N_1) (inn_2 X N_2) sx
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop (V128.CONST c_2) from the stack.
3. Assert: Due to validation, a value is on the top of the stack.
4. Pop (V128.CONST c_1) from the stack.
5. Assert: Due to validation, (ci_1* is $lanes_((inn_1 X N_1), c_1)).
6. Assert: Due to validation, (ci_2* is $lanes_((inn_1 X N_1), c_2)).
7. Assert: Due to validation, (cj_1* is $narrow($size(inn_1), $size(inn_2), sx, i_1)*).
8. Assert: Due to validation, (cj_2* is $narrow($size(inn_1), $size(inn_2), sx, i_2)*).
9. Assert: Due to validation, (c is $invlanes_((inn_2 X N_2), cj_1* ++ cj_2*)).
10. Push (V128.CONST c) to the stack.

execution_of_VCVTOP (lanet_u0 X N_2) vcvtop half_u1? (lanet_u2 X N_1) sx_u3? (ZERO _u4?)
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop (V128.CONST c_1) from the stack.
3. If (half_u1? is not defined and _u4? is not defined), then:
  a. Let lnn_1 be lanet_u2.
  b. Let lnn_2 be lanet_u0.
  c. If sx_u3? is defined, then:
    1) Let ?(sx) be sx_u3?.
    2) Let c'* be $lanes_((lnn_1 X N_1), c_1).
    3) Let c be $invlanes_((lnn_2 X N_2), $vcvtop((lnn_1 X N_1), (lnn_2 X N_2), vcvtop, ?(sx), c')*).
    4) Push (V128.CONST c) to the stack.
4. If (_u4? is not defined and half_u1? is defined), then:
  a. Let ?(hf) be half_u1?.
  b. If the type of lanet_u2 is inn, then:
    1) Let inn_1 be lanet_u2.
    2) If the type of lanet_u0 is inn, then:
      a) Let inn_2 be lanet_u0.
      b) Let sx? be sx_u3?.
      c) Let ci* be $lanes_((inn_1 X N_1), c_1)[$halfop(hf, 0, N_2) : N_2].
      d) Let c be $invlanes_((inn_2 X N_2), $vcvtop((inn_1 X N_1), (inn_2 X N_2), vcvtop, sx?, ci)*).
      e) Push (V128.CONST c) to the stack.
5. If (half_u1? is not defined and ((_u4? is ?(())) and the type of lanet_u2 is inn)), then:
  a. Let inn_1 be lanet_u2.
  b. If the type of lanet_u0 is inn, then:
    1) Let inn_2 be lanet_u0.
    2) Let sx? be sx_u3?.
    3) Let ci* be $lanes_((inn_1 X N_1), c_1).
    4) Let c be $invlanes_((inn_2 X N_2), $vcvtop((inn_1 X N_1), (inn_2 X N_2), vcvtop, sx?, ci)* ++ 0^N_1).
    5) Push (V128.CONST c) to the stack.

execution_of_VEXTUNOP sh_1 sh_2 vextunop sx
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop (V128.CONST c_1) from the stack.
3. Let c be $vextunop(sh_1, sh_2, vextunop, sx, c_1).
4. Push (V128.CONST c) to the stack.

execution_of_VEXTBINOP sh_1 sh_2 vextbinop sx
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop (V128.CONST c_2) from the stack.
3. Assert: Due to validation, a value is on the top of the stack.
4. Pop (V128.CONST c_1) from the stack.
5. Let c be $vextbinop(sh_1, sh_2, vextbinop, sx, c_1, c_2).
6. Push (V128.CONST c) to the stack.

execution_of_LOCAL.TEE x
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop val from the stack.
3. Push val to the stack.
4. Push val to the stack.
5. Execute (LOCAL.SET x).

execution_of_BLOCK bt instr*
1. Let (t_1^k -> t_2^n) be $blocktype(bt).
2. Assert: Due to validation, there are at least k values on the top of the stack.
3. Pop val^k from the stack.
4. Let L be the label_n{[]}.
5. Enter L with label instr* ++ [LABEL_]:
  a. Push val^k to the stack.

execution_of_LOOP bt instr*
1. Let (t_1^k -> t_2^n) be $blocktype(bt).
2. Assert: Due to validation, there are at least k values on the top of the stack.
3. Pop val^k from the stack.
4. Let L be the label_k{[(LOOP bt instr*)]}.
5. Enter L with label instr* ++ [LABEL_]:
  a. Push val^k to the stack.

execution_of_CALL x
1. Assert: Due to validation, (x < |$funcaddr()|).
2. Execute (CALL_ADDR $funcaddr()[x]).

execution_of_CALL_INDIRECT x y
1. Assert: Due to validation, a value of value type I32 is on the top of the stack.
2. Pop (I32.CONST i) from the stack.
3. If (i ≥ |$table(x).ELEM|), then:
  a. Trap.
4. If $table(x).ELEM[i] is not of the case REF.FUNC_ADDR, then:
  a. Trap.
5. Let (REF.FUNC_ADDR a) be $table(x).ELEM[i].
6. If (a ≥ |$funcinst()|), then:
  a. Trap.
7. If ($type(y) is not $funcinst()[a].TYPE), then:
  a. Trap.
8. Execute (CALL_ADDR a).

execution_of_CALL_ADDR a
1. Assert: Due to validation, (a < |$funcinst()|).
2. Let { TYPE: (t_1^k -> t_2^n); MODULE: mm; CODE: func; } be $funcinst()[a].
3. Assert: Due to validation, there are at least k values on the top of the stack.
4. Pop val^k from the stack.
5. Assert: Due to validation, func is of the case FUNC.
6. Let (FUNC x y_0 instr*) be func.
7. Let (LOCAL t)* be y_0.
8. Let f be { LOCAL: val^k ++ $default(t)*; MODULE: mm; }.
9. Let F be the activation of f with arity n.
10. Enter F with label [FRAME_]:
  a. Let L be the label_n{[]}.
  b. Enter L with label instr* ++ [LABEL_]:

execution_of_REF.FUNC x
1. Assert: Due to validation, (x < |$funcaddr()|).
2. Push (REF.FUNC_ADDR $funcaddr()[x]) to the stack.

execution_of_LOCAL.GET x
1. Push $local(x) to the stack.

execution_of_GLOBAL.GET x
1. Push $global(x).VALUE to the stack.

execution_of_TABLE.GET x
1. Assert: Due to validation, a value of value type I32 is on the top of the stack.
2. Pop (I32.CONST i) from the stack.
3. If (i ≥ |$table(x).ELEM|), then:
  a. Trap.
4. Push $table(x).ELEM[i] to the stack.

execution_of_TABLE.SIZE x
1. Let n be |$table(x).ELEM|.
2. Push (I32.CONST n) to the stack.

execution_of_TABLE.FILL x
1. Assert: Due to validation, a value of value type I32 is on the top of the stack.
2. Pop (I32.CONST n) from the stack.
3. Assert: Due to validation, a value is on the top of the stack.
4. Pop val from the stack.
5. Assert: Due to validation, a value of value type I32 is on the top of the stack.
6. Pop (I32.CONST i) from the stack.
7. If ((i + n) > |$table(x).ELEM|), then:
  a. Trap.
8. If (n is 0), then:
  a. Do nothing.
9. Else:
  a. Push (I32.CONST i) to the stack.
  b. Push val to the stack.
  c. Execute (TABLE.SET x).
  d. Push (I32.CONST (i + 1)) to the stack.
  e. Push val to the stack.
  f. Push (I32.CONST (n - 1)) to the stack.
  g. Execute (TABLE.FILL x).

execution_of_TABLE.COPY x y
1. Assert: Due to validation, a value of value type I32 is on the top of the stack.
2. Pop (I32.CONST n) from the stack.
3. Assert: Due to validation, a value of value type I32 is on the top of the stack.
4. Pop (I32.CONST i) from the stack.
5. Assert: Due to validation, a value of value type I32 is on the top of the stack.
6. Pop (I32.CONST j) from the stack.
7. If ((i + n) > |$table(y).ELEM|), then:
  a. Trap.
8. If ((j + n) > |$table(x).ELEM|), then:
  a. Trap.
9. If (n is 0), then:
  a. Do nothing.
10. Else:
  a. If (j ≤ i), then:
    1) Push (I32.CONST j) to the stack.
    2) Push (I32.CONST i) to the stack.
    3) Execute (TABLE.GET y).
    4) Execute (TABLE.SET x).
    5) Push (I32.CONST (j + 1)) to the stack.
    6) Push (I32.CONST (i + 1)) to the stack.
  b. Else:
    1) Push (I32.CONST ((j + n) - 1)) to the stack.
    2) Push (I32.CONST ((i + n) - 1)) to the stack.
    3) Execute (TABLE.GET y).
    4) Execute (TABLE.SET x).
    5) Push (I32.CONST j) to the stack.
    6) Push (I32.CONST i) to the stack.
  c. Push (I32.CONST (n - 1)) to the stack.
  d. Execute (TABLE.COPY x y).

execution_of_TABLE.INIT x y
1. Assert: Due to validation, a value of value type I32 is on the top of the stack.
2. Pop (I32.CONST n) from the stack.
3. Assert: Due to validation, a value of value type I32 is on the top of the stack.
4. Pop (I32.CONST i) from the stack.
5. Assert: Due to validation, a value of value type I32 is on the top of the stack.
6. Pop (I32.CONST j) from the stack.
7. If ((i + n) > |$elem(y).ELEM|), then:
  a. Trap.
8. If ((j + n) > |$table(x).ELEM|), then:
  a. Trap.
9. If (n is 0), then:
  a. Do nothing.
10. Else if (i < |$elem(y).ELEM|), then:
  a. Push (I32.CONST j) to the stack.
  b. Push $elem(y).ELEM[i] to the stack.
  c. Execute (TABLE.SET x).
  d. Push (I32.CONST (j + 1)) to the stack.
  e. Push (I32.CONST (i + 1)) to the stack.
  f. Push (I32.CONST (n - 1)) to the stack.
  g. Execute (TABLE.INIT x y).

execution_of_LOAD numty_u0 n_sx_u1? mo
1. Assert: Due to validation, a value of value type I32 is on the top of the stack.
2. Pop (I32.CONST i) from the stack.
3. If n_sx_u1? is not defined, then:
  a. Let nt be numty_u0.
  b. If (((i + mo.OFFSET) + ($size(nt) / 8)) > |$mem(0).DATA|), then:
    1) Trap.
  c. Let c be $inverse_of_nbytes(nt, $mem(0).DATA[(i + mo.OFFSET) : ($size(nt) / 8)]).
  d. Push (nt.CONST c) to the stack.
4. If the type of numty_u0 is inn, then:
  a. If n_sx_u1? is defined, then:
    1) Let ?(y_0) be n_sx_u1?.
    2) Let (n, sx) be y_0.
    3) If (((i + mo.OFFSET) + (n / 8)) > |$mem(0).DATA|), then:
      a) Trap.
  b. Let inn be numty_u0.
  c. If n_sx_u1? is defined, then:
    1) Let ?(y_0) be n_sx_u1?.
    2) Let (n, sx) be y_0.
    3) Let c be $inverse_of_ibytes(n, $mem(0).DATA[(i + mo.OFFSET) : (n / 8)]).
    4) Push (inn.CONST $ext(n, $size(inn), sx, c)) to the stack.

execution_of_VLOAD vload_u0? mo
1. Assert: Due to validation, a value of value type I32 is on the top of the stack.
2. Pop (I32.CONST i) from the stack.
3. If ((((i + mo.OFFSET) + ($size(V128) / 8)) > |$mem(0).DATA|) and vload_u0? is not defined), then:
  a. Trap.
4. If vload_u0? is not defined, then:
  a. Let c be $inverse_of_vbytes(V128, $mem(0).DATA[(i + mo.OFFSET) : ($size(V128) / 8)]).
  b. Push (V128.CONST c) to the stack.
5. Else:
  a. Let ?(y_0) be vload_u0?.
  b. If y_0 is of the case SHAPE, then:
    1) Let (SHAPE M N sx) be y_0.
    2) If (((i + mo.OFFSET) + ((M · N) / 8)) > |$mem(0).DATA|), then:
      a) Trap.
    3) If the type of $inverse_of_size((M · 2)) is inn, then:
      a) Let inn be $inverse_of_size((M · 2)).
      b) Let j^N be $inverse_of_ibytes(M, $mem(0).DATA[((i + mo.OFFSET) + ((k · M) / 8)) : (M / 8)])^(k<N).
      c) Let c be $invlanes_((inn X N), $ext(M, $size(inn), sx, j)^N).
      d) Push (V128.CONST c) to the stack.
  c. If y_0 is of the case SPLAT, then:
    1) Let (SPLAT N) be y_0.
    2) If (((i + mo.OFFSET) + (N / 8)) > |$mem(0).DATA|), then:
      a) Trap.
    3) Let M be (128 / N).
    4) If the type of $inverse_of_lsize(N) is imm, then:
      a) Let imm be $inverse_of_lsize(N).
      b) Let j be $inverse_of_ibytes(N, $mem(0).DATA[(i + mo.OFFSET) : (N / 8)]).
      c) Let c be $invlanes_((imm X M), j^M).
      d) Push (V128.CONST c) to the stack.
  d. If y_0 is of the case ZERO, then:
    1) Let (ZERO N) be y_0.
    2) If (((i + mo.OFFSET) + (N / 8)) > |$mem(0).DATA|), then:
      a) Trap.
    3) Let j be $inverse_of_ibytes(N, $mem(0).DATA[(i + mo.OFFSET) : (N / 8)]).
    4) Let c be $ext(N, 128, U, j).
    5) Push (V128.CONST c) to the stack.

execution_of_VLOAD_LANE N mo j
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop (V128.CONST c_1) from the stack.
3. Assert: Due to validation, a value of value type I32 is on the top of the stack.
4. Pop (I32.CONST i) from the stack.
5. If (((i + mo.OFFSET) + (N / 8)) > |$mem(0).DATA|), then:
  a. Trap.
6. Let M be (128 / N).
7. If the type of $inverse_of_lsize(N) is imm, then:
  a. Let imm be $inverse_of_lsize(N).
  b. Let k be $inverse_of_ibytes(N, $mem(0).DATA[(i + mo.OFFSET) : (N / 8)]).
  c. Let c be $invlanes_((imm X M), $lanes_((imm X M), c_1) with [j] replaced by k).
  d. Push (V128.CONST c) to the stack.

execution_of_MEMORY.SIZE
1. Let ((n · 64) · $Ki()) be |$mem(0).DATA|.
2. Push (I32.CONST n) to the stack.

execution_of_MEMORY.FILL
1. Assert: Due to validation, a value of value type I32 is on the top of the stack.
2. Pop (I32.CONST n) from the stack.
3. Assert: Due to validation, a value is on the top of the stack.
4. Pop val from the stack.
5. Assert: Due to validation, a value of value type I32 is on the top of the stack.
6. Pop (I32.CONST i) from the stack.
7. If ((i + n) > |$mem(0).DATA|), then:
  a. Trap.
8. If (n is 0), then:
  a. Do nothing.
9. Else:
  a. Push (I32.CONST i) to the stack.
  b. Push val to the stack.
  c. Execute (STORE I32 ?(8) $memop0()).
  d. Push (I32.CONST (i + 1)) to the stack.
  e. Push val to the stack.
  f. Push (I32.CONST (n - 1)) to the stack.
  g. Execute MEMORY.FILL.

execution_of_MEMORY.COPY
1. Assert: Due to validation, a value of value type I32 is on the top of the stack.
2. Pop (I32.CONST n) from the stack.
3. Assert: Due to validation, a value of value type I32 is on the top of the stack.
4. Pop (I32.CONST i) from the stack.
5. Assert: Due to validation, a value of value type I32 is on the top of the stack.
6. Pop (I32.CONST j) from the stack.
7. If ((i + n) > |$mem(0).DATA|), then:
  a. Trap.
8. If ((j + n) > |$mem(0).DATA|), then:
  a. Trap.
9. If (n is 0), then:
  a. Do nothing.
10. Else:
  a. If (j ≤ i), then:
    1) Push (I32.CONST j) to the stack.
    2) Push (I32.CONST i) to the stack.
    3) Execute (LOAD I32 ?((8, U)) $memop0()).
    4) Execute (STORE I32 ?(8) $memop0()).
    5) Push (I32.CONST (j + 1)) to the stack.
    6) Push (I32.CONST (i + 1)) to the stack.
  b. Else:
    1) Push (I32.CONST ((j + n) - 1)) to the stack.
    2) Push (I32.CONST ((i + n) - 1)) to the stack.
    3) Execute (LOAD I32 ?((8, U)) $memop0()).
    4) Execute (STORE I32 ?(8) $memop0()).
    5) Push (I32.CONST j) to the stack.
    6) Push (I32.CONST i) to the stack.
  c. Push (I32.CONST (n - 1)) to the stack.
  d. Execute MEMORY.COPY.

execution_of_MEMORY.INIT x
1. Assert: Due to validation, a value of value type I32 is on the top of the stack.
2. Pop (I32.CONST n) from the stack.
3. Assert: Due to validation, a value of value type I32 is on the top of the stack.
4. Pop (I32.CONST i) from the stack.
5. Assert: Due to validation, a value of value type I32 is on the top of the stack.
6. Pop (I32.CONST j) from the stack.
7. If ((i + n) > |$data(x).DATA|), then:
  a. Trap.
8. If ((j + n) > |$mem(0).DATA|), then:
  a. Trap.
9. If (n is 0), then:
  a. Do nothing.
10. Else if (i < |$data(x).DATA|), then:
  a. Push (I32.CONST j) to the stack.
  b. Push (I32.CONST $data(x).DATA[i]) to the stack.
  c. Execute (STORE I32 ?(8) $memop0()).
  d. Push (I32.CONST (j + 1)) to the stack.
  e. Push (I32.CONST (i + 1)) to the stack.
  f. Push (I32.CONST (n - 1)) to the stack.
  g. Execute (MEMORY.INIT x).

execution_of_LOCAL.SET x
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop val from the stack.
3. Perform $with_local(x, val).

execution_of_GLOBAL.SET x
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop val from the stack.
3. Perform $with_global(x, val).

execution_of_TABLE.SET x
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop ref from the stack.
3. Assert: Due to validation, a value of value type I32 is on the top of the stack.
4. Pop (I32.CONST i) from the stack.
5. If (i ≥ |$table(x).ELEM|), then:
  a. Trap.
6. Perform $with_table(x, i, ref).

execution_of_TABLE.GROW x
1. Assert: Due to validation, a value of value type I32 is on the top of the stack.
2. Pop (I32.CONST n) from the stack.
3. Assert: Due to validation, a value is on the top of the stack.
4. Pop ref from the stack.
5. Either:
  a. Let ti be $growtable($table(x), n, ref).
  b. Push (I32.CONST |$table(x).ELEM|) to the stack.
  c. Perform $with_tableinst(x, ti).
6. Or:
  a. Push (I32.CONST $invsigned(32, (- 1))) to the stack.

execution_of_ELEM.DROP x
1. Perform $with_elem(x, []).

execution_of_STORE numty_u1 n_u2? mo
1. Assert: Due to validation, a value of value type numty_u0 is on the top of the stack.
2. Pop (numty_u0.CONST c) from the stack.
3. Assert: Due to validation, a value of value type I32 is on the top of the stack.
4. Pop (I32.CONST i) from the stack.
5. If n_u2? is not defined, then:
  a. Let nt be numty_u1.
  b. If ((((i + mo.OFFSET) + ($size(nt) / 8)) > |$mem(0).DATA|) and (numty_u0 is nt)), then:
    1) Trap.
  c. If (numty_u0 is nt), then:
    1) Let b* be $nbytes(nt, c).
    2) Perform $with_mem(0, (i + mo.OFFSET), ($size(nt) / 8), b*).
6. Else:
  a. Let ?(n) be n_u2?.
  b. If the type of numty_u1 is inn, then:
    1) Let inn be numty_u1.
    2) If ((((i + mo.OFFSET) + (n / 8)) > |$mem(0).DATA|) and (numty_u0 is inn)), then:
      a) Trap.
    3) If (numty_u0 is inn), then:
      a) Let b* be $ibytes(n, $wrap($size(inn), n, c)).
      b) Perform $with_mem(0, (i + mo.OFFSET), (n / 8), b*).

execution_of_VSTORE mo
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop (V128.CONST c) from the stack.
3. Assert: Due to validation, a value of value type I32 is on the top of the stack.
4. Pop (I32.CONST i) from the stack.
5. If (((i + mo.OFFSET) + ($size(V128) / 8)) > |$mem(0).DATA|), then:
  a. Trap.
6. Let b* be $vbytes(V128, c).
7. Perform $with_mem(0, (i + mo.OFFSET), ($size(V128) / 8), b*).

execution_of_VSTORE_LANE N mo j
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop (V128.CONST c) from the stack.
3. Assert: Due to validation, a value of value type I32 is on the top of the stack.
4. Pop (I32.CONST i) from the stack.
5. If (((i + mo.OFFSET) + N) > |$mem(0).DATA|), then:
  a. Trap.
6. Let M be (128 / N).
7. If the type of $inverse_of_lsize(N) is imm, then:
  a. Let imm be $inverse_of_lsize(N).
  b. If (j < |$lanes_((imm X M), c)|), then:
    1) Let b* be $ibytes(N, $lanes_((imm X M), c)[j]).
    2) Perform $with_mem(0, (i + mo.OFFSET), (N / 8), b*).

execution_of_MEMORY.GROW
1. Assert: Due to validation, a value of value type I32 is on the top of the stack.
2. Pop (I32.CONST n) from the stack.
3. Either:
  a. Let mi be $growmemory($mem(0), n).
  b. Push (I32.CONST (|$mem(0).DATA| / (64 · $Ki()))) to the stack.
  c. Perform $with_meminst(0, mi).
4. Or:
  a. Push (I32.CONST $invsigned(32, (- 1))) to the stack.

execution_of_DATA.DROP x
1. Perform $with_data(x, []).

eval_expr instr*
1. Execute the sequence (instr*).
2. Pop val from the stack.
3. Return [val].

execution_of_CALL_REF x
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop ref from the stack.
3. If ref is of the case REF.NULL, then:
  a. Trap.
4. Assert: Due to validation, ref is of the case REF.FUNC_ADDR.
5. Let (REF.FUNC_ADDR a) be ref.
6. If (a < |$funcinst()|), then:
  a. Let fi be $funcinst()[a].
  b. Assert: Due to validation, fi.CODE is of the case FUNC.
  c. Let (FUNC y_0 y_1 instr*) be fi.CODE.
  d. Let (LOCAL t)* be y_1.
  e. Assert: Due to validation, $expanddt(fi.TYPE) is of the case FUNC.
  f. Let (FUNC y_0) be $expanddt(fi.TYPE).
  g. Let (t_1^n -> t_2^m) be y_0.
  h. Assert: Due to validation, there are at least n values on the top of the stack.
  i. Pop val^n from the stack.
  j. Let f be { LOCAL: ?(val)^n ++ $default(t)*; MODULE: fi.MODULE; }.
  k. Let F be the activation of f with arity m.
  l. Enter F with label [FRAME_]:
    1) Let L be the label_m{[]}.
    2) Enter L with label instr* ++ [LABEL_]:

group_bytes_by n byte*
1. Let n' be |byte*|.
2. If (n' ≥ n), then:
  a. Return [byte*[0 : n]] ++ $group_bytes_by(n, byte*[n : (n' - n)]).
3. Return [].

execution_of_ARRAY.NEW_DATA x y
1. Assert: Due to validation, a value of value type I32 is on the top of the stack.
2. Pop (I32.CONST n) from the stack.
3. Assert: Due to validation, a value of value type I32 is on the top of the stack.
4. Pop (I32.CONST i) from the stack.
5. If $expanddt($type(x)) is of the case ARRAY, then:
  a. Let (ARRAY y_0) be $expanddt($type(x)).
  b. Let (mut, zt) be y_0.
  c. If ((i + ((n · $storagesize(zt)) / 8)) > |$data(y).DATA|), then:
    1) Trap.
  d. Let nt be $unpacknumtype(zt).
  e. Let b* be $data(y).DATA[i : ((n · $storagesize(zt)) / 8)].
  f. Let gb* be $group_bytes_by(($storagesize(zt) / 8), b*).
  g. Let c^n be $inverse_of_ibytes($storagesize(zt), gb)*.
  h. Push (nt.CONST c)^n to the stack.
  i. Execute (ARRAY.NEW_FIXED x n).
== Complete.
Generating prose for Wasm 3.0...
watsup 0.4 generator
== Parsing...
== Elaboration...
== IL Validation...
== Running pass sideconditions...
== IL Validation after pass sideconditions...
== Running pass animate...
== IL Validation after pass animate...
== Translating to AL...
== Prose Generation...
prem_to_instr: Invalid prem 2
prem_to_instr: Invalid prem 2
prem_to_instr: Invalid prem 2
prem_to_instr: Invalid prem 2
prem_to_instr: Invalid prem 2
prem_to_instr: Invalid prem 2
prem_to_instr: Invalid prem 2
prem_to_instr: Invalid prem 2
prem_to_instr: Invalid prem 2
prem_to_instr: Invalid prem 2
prem_to_instr: Invalid prem 2
prem_to_instr: Invalid prem 2
prem_to_instr: Invalid prem 2
prem_to_instr: Invalid prem 3
prem_to_instr: Invalid prem 2
prem_to_instr: Invalid prem 2
prem_to_instr: Invalid prem 2
prem_to_instr: Invalid prem 2
prem_to_instr: Invalid prem 2
=================
 Generated prose
=================
validation_of_UNREACHABLE
- The instruction is valid with type (t_1* -> t_2*).

validation_of_NOP
- The instruction is valid with type ([] -> []).

validation_of_DROP
- The instruction is valid with type ([t] -> []).

validation_of_SELECT ?([t])
- The instruction is valid with type ([t, t, I32] -> [t]).

validation_of_BLOCK bt instr*
- Under the context C with .LABEL prepended by [t_2*], instr* must be valid with type (t_1* -> x* ++ t_2*).
- Under the context C, bt must be valid with type (t_1* -> t_2*).
- The instruction is valid with type (t_1* -> t_2*).

validation_of_LOOP bt instr*
- Under the context C with .LABEL prepended by [t_1*], instr* must be valid with type (t_1* -> x* ++ t_2*).
- Under the context C, bt must be valid with type (t_1* -> t_2*).
- The instruction is valid with type (t_1* -> t_2*).

validation_of_IF bt instr_1* instr_2*
- Under the context C with .LABEL prepended by [t_2*], instr_1* must be valid with type (t_1* -> x_1* ++ t_2*).
- Under the context C, bt must be valid with type (t_1* -> t_2*).
- Under the context C with .LABEL prepended by [t_2*], instr_2* must be valid with type (t_1* -> x_2* ++ t_2*).
- The instruction is valid with type (t_1* ++ [I32] -> t_2*).

validation_of_BR l
- |C.LABEL| must be greater than l.
- Let t* be C.LABEL[l].
- The instruction is valid with type (t_1* ++ t* -> t_2*).

validation_of_BR_IF l
- |C.LABEL| must be greater than l.
- Let t* be C.LABEL[l].
- The instruction is valid with type (t* ++ [I32] -> t*).

validation_of_BR_TABLE l* l'
- For all l in l*,
  - |C.LABEL| must be greater than l.
- |C.LABEL| must be greater than l'.
- For all l in l*,
  - Yet: TODO: prem_to_instrs 2
- Yet: TODO: prem_to_instrs 2
- The instruction is valid with type (t_1* ++ t* -> t_2*).

validation_of_BR_ON_NULL l
- |C.LABEL| must be greater than l.
- Under the context C, ht must be valid.
- Let t* be C.LABEL[l].
- The instruction is valid with type (t* ++ [(REF (NULL ?(())) ht)] -> t* ++ [(REF (NULL ?()) ht)]).

validation_of_BR_ON_NON_NULL l
- |C.LABEL| must be greater than l.
- Let t* ++ [(REF (NULL ?()) ht)] be C.LABEL[l].
- Under the context C, ht must be valid.
- The instruction is valid with type (t* ++ [(REF (NULL ?(())) ht)] -> t*).

validation_of_BR_ON_CAST l rt_1 rt_2
- |C.LABEL| must be greater than l.
- Under the context C, rt_1 must be valid.
- Under the context C, rt_2 must be valid.
- Yet: TODO: prem_to_instrs 2
- Let t* ++ [rt] be C.LABEL[l].
- Yet: TODO: prem_to_instrs 2
- The instruction is valid with type (t* ++ [rt_1] -> t* ++ [$diffrt(rt_1, rt_2)]).

validation_of_BR_ON_CAST_FAIL l rt_1 rt_2
- |C.LABEL| must be greater than l.
- Under the context C, rt_1 must be valid.
- Under the context C, rt_2 must be valid.
- Yet: TODO: prem_to_instrs 2
- Let t* ++ [rt] be C.LABEL[l].
- Yet: TODO: prem_to_instrs 2
- The instruction is valid with type (t* ++ [rt_1] -> t* ++ [rt_2]).

validation_of_RETURN
- Let ?(t*) be C.RETURN.
- The instruction is valid with type (t_1* ++ t* -> t_2*).

validation_of_CALL x
- |C.FUNC| must be greater than x.
- Let (FUNC (t_1* -> t_2*)) be $expanddt(C.FUNC[x]).
- The instruction is valid with type (t_1* -> t_2*).

validation_of_CALL_REF ?(x)
- |C.TYPE| must be greater than x.
- Let (FUNC (t_1* -> t_2*)) be $expanddt(C.TYPE[x]).
- The instruction is valid with type (t_1* ++ [(REF (NULL ?(())) $idx(x))] -> t_2*).

validation_of_CALL_INDIRECT x y
- |C.TABLE| must be greater than x.
- |C.TYPE| must be greater than y.
- Let (lim, rt) be C.TABLE[x].
- Let (FUNC (t_1* -> t_2*)) be $expanddt(C.TYPE[y]).
- Yet: TODO: prem_to_instrs 2
- The instruction is valid with type (t_1* ++ [I32] -> t_2*).

validation_of_RETURN_CALL x
- |C.FUNC| must be greater than x.
- Let (FUNC (t_1* -> t_2*)) be $expanddt(C.FUNC[x]).
- Yet: TODO: prem_to_instrs 2
- C.RETURN must be equal to ?(t'_2*).
- The instruction is valid with type (t_3* ++ t_1* -> t_4*).

validation_of_RETURN_CALL_REF ?(x)
- |C.TYPE| must be greater than x.
- Let (FUNC (t_1* -> t_2*)) be $expanddt(C.TYPE[x]).
- Yet: TODO: prem_to_instrs 2
- C.RETURN must be equal to ?(t'_2*).
- The instruction is valid with type (t_3* ++ t_1* ++ [(REF (NULL ?(())) $idx(x))] -> t_4*).

validation_of_RETURN_CALL_INDIRECT x y
- |C.TABLE| must be greater than x.
- |C.TYPE| must be greater than y.
- Let (lim, rt) be C.TABLE[x].
- Let (FUNC (t_1* -> t_2*)) be $expanddt(C.TYPE[y]).
- Yet: TODO: prem_to_instrs 2
- Yet: TODO: prem_to_instrs 2
- C.RETURN must be equal to ?(t'_2*).
- The instruction is valid with type (t_3* ++ t_1* ++ [I32] -> t_4*).

validation_of_CONST nt c_nt
- The instruction is valid with type ([] -> [nt]).

validation_of_UNOP nt unop_nt
- The instruction is valid with type ([nt] -> [nt]).

validation_of_BINOP nt binop_nt
- The instruction is valid with type ([nt, nt] -> [nt]).

validation_of_TESTOP nt testop_nt
- The instruction is valid with type ([nt] -> [I32]).

validation_of_RELOP nt relop_nt
- The instruction is valid with type ([nt, nt] -> [I32]).

validation_of_CVTOP nt_1 REINTERPRET nt_2 ?()
- nt_1 must be different with nt_2.
- $size(nt_1) must be equal to $size(nt_2).
- The instruction is valid with type ([nt_2] -> [nt_1]).

validation_of_CVTOP inn_1 CONVERT inn_2 sx?
- inn_1 must be different with inn_2.
- (($size(inn_1) > $size(inn_2))) and ((sx? is ?())) are equivalent.
- The instruction is valid with type ([inn_2] -> [inn_1]).

validation_of_REF.NULL ht
- Under the context C, ht must be valid.
- The instruction is valid with type ([] -> [(REF (NULL ?(())) ht)]).

validation_of_REF.FUNC x
- |C.FUNC| must be greater than x.
- Let dt be C.FUNC[x].
- The instruction is valid with type (epsilon -> [(REF (NULL ?()) dt)]).

validation_of_REF.I31
- The instruction is valid with type ([I32] -> [(REF (NULL ?()) I31)]).

validation_of_REF.IS_NULL
- The instruction is valid with type ([rt] -> [I32]).

validation_of_REF.AS_NON_NULL
- Under the context C, ht must be valid.
- The instruction is valid with type ([(REF (NULL ?(())) ht)] -> [(REF (NULL ?()) ht)]).

validation_of_REF.EQ
- The instruction is valid with type ([(REF (NULL ?(())) EQ), (REF (NULL ?(())) EQ)] -> [I32]).

validation_of_REF.TEST rt
- Under the context C, rt must be valid.
- Yet: TODO: prem_to_instrs 2
- Under the context C, rt' must be valid.
- The instruction is valid with type ([rt'] -> [I32]).

validation_of_REF.CAST rt
- Under the context C, rt must be valid.
- Yet: TODO: prem_to_instrs 2
- Under the context C, rt' must be valid.
- The instruction is valid with type ([rt'] -> [rt]).

validation_of_I31.GET sx
- The instruction is valid with type ([(REF (NULL ?(())) I31)] -> [I32]).

validation_of_STRUCT.NEW x
- |C.TYPE| must be greater than x.
- Let (STRUCT (mut, zt)*) be $expanddt(C.TYPE[x]).
- |zt*| must be equal to |mut*|.
- The instruction is valid with type ($unpack(zt)* -> [(REF (NULL ?()) $idx(x))]).

validation_of_STRUCT.NEW_DEFAULT x
- |C.TYPE| must be greater than x.
- Let (STRUCT (mut, zt)*) be $expanddt(C.TYPE[x]).
- |zt*| must be equal to |mut*|.
- Yet: TODO: prem_to_intrs 3
- |zt*| must be equal to |val*|.
- The instruction is valid with type ($unpack(zt)* -> [(REF (NULL ?()) $idx(x))]).

validation_of_STRUCT.GET sx? x i
- |C.TYPE| must be greater than x.
- Let (STRUCT yt*) be $expanddt(C.TYPE[x]).
- |yt*| must be greater than i.
- Let (mut, zt) be yt*[i].
- ((zt is $unpack(zt))) and ((sx? is ?())) are equivalent.
- The instruction is valid with type ([(REF (NULL ?(())) $idx(x))] -> [$unpack(zt)]).

validation_of_STRUCT.SET x i
- |C.TYPE| must be greater than x.
- Let (STRUCT yt*) be $expanddt(C.TYPE[x]).
- |yt*| must be greater than i.
- Let ((MUT ?(())), zt) be yt*[i].
- The instruction is valid with type ([(REF (NULL ?(())) $idx(x)), $unpack(zt)] -> []).

validation_of_ARRAY.NEW x
- |C.TYPE| must be greater than x.
- Let (ARRAY (mut, zt)) be $expanddt(C.TYPE[x]).
- The instruction is valid with type ([$unpack(zt), I32] -> [(REF (NULL ?()) $idx(x))]).

validation_of_ARRAY.NEW_DEFAULT x
- |C.TYPE| must be greater than x.
- Let (ARRAY (mut, zt)) be $expanddt(C.TYPE[x]).
- Let ?(val) be $default($unpack(zt)).
- The instruction is valid with type ([I32] -> [(REF (NULL ?()) $idx(x))]).

validation_of_ARRAY.NEW_FIXED x n
- |C.TYPE| must be greater than x.
- Let (ARRAY (mut, zt)) be $expanddt(C.TYPE[x]).
- The instruction is valid with type ([$unpack(zt)] -> [(REF (NULL ?()) $idx(x))]).

validation_of_ARRAY.NEW_ELEM x y
- |C.TYPE| must be greater than x.
- |C.ELEM| must be greater than y.
- Let (ARRAY (mut, rt)) be $expanddt(C.TYPE[x]).
- Yet: TODO: prem_to_instrs 2
- The instruction is valid with type ([I32, I32] -> [(REF (NULL ?()) $idx(x))]).

validation_of_ARRAY.NEW_DATA x y
- |C.TYPE| must be greater than x.
- |C.DATA| must be greater than y.
- C.DATA[y] must be equal to OK.
- Let (ARRAY (mut, t)) be $expanddt(C.TYPE[x]).
- Let numtype be t.
- The instruction is valid with type ([I32, I32] -> [(REF (NULL ?()) $idx(x))]).

validation_of_ARRAY.GET sx? x
- |C.TYPE| must be greater than x.
- Let (ARRAY (mut, zt)) be $expanddt(C.TYPE[x]).
- ((zt is $unpack(zt))) and ((sx? is ?())) are equivalent.
- The instruction is valid with type ([(REF (NULL ?(())) $idx(x)), I32] -> [$unpack(zt)]).

validation_of_ARRAY.SET x
- |C.TYPE| must be greater than x.
- Let (ARRAY ((MUT ?(())), zt)) be $expanddt(C.TYPE[x]).
- The instruction is valid with type ([(REF (NULL ?(())) $idx(x)), I32, $unpack(zt)] -> []).

validation_of_ARRAY.LEN
- Let $expanddt(C.TYPE[x]) be (ARRAY ((MUT ?(())), zt)).
- |C.TYPE| must be greater than x.
- The instruction is valid with type ([(REF (NULL ?(())) ARRAY)] -> [I32]).

validation_of_ARRAY.FILL x
- |C.TYPE| must be greater than x.
- Let (ARRAY ((MUT ?(())), zt)) be $expanddt(C.TYPE[x]).
- The instruction is valid with type ([(REF (NULL ?(())) $idx(x)), I32, $unpack(zt), I32] -> []).

validation_of_ARRAY.COPY x_1 x_2
- |C.TYPE| must be greater than x_1.
- |C.TYPE| must be greater than x_2.
- Let (ARRAY (mut, zt_2)) be $expanddt(C.TYPE[x_2]).
- Yet: TODO: prem_to_instrs 2
- $expanddt(C.TYPE[x_1]) must be equal to (ARRAY ((MUT ?(())), zt_1)).
- The instruction is valid with type ([(REF (NULL ?(())) $idx(x_1)), I32, (REF (NULL ?(())) $idx(x_2)), I32, I32] -> []).

validation_of_ARRAY.INIT_ELEM x y
- |C.TYPE| must be greater than x.
- |C.ELEM| must be greater than y.
- Yet: TODO: prem_to_instrs 2
- $expanddt(C.TYPE[x]) must be equal to (ARRAY ((MUT ?(())), zt)).
- The instruction is valid with type ([(REF (NULL ?(())) $idx(x)), I32, I32, I32] -> []).

validation_of_ARRAY.INIT_DATA x y
- |C.DATA| must be greater than y.
- |C.TYPE| must be greater than x.
- C.DATA[y] must be equal to OK.
- Let numtype be t.
- $expanddt(C.TYPE[x]) must be equal to (ARRAY ((MUT ?(())), zt)).
- The instruction is valid with type ([(REF (NULL ?(())) $idx(x)), I32, I32, I32] -> []).

validation_of_EXTERN.CONVERT_ANY
- The instruction is valid with type ([(REF nul ANY)] -> [(REF nul EXTERN)]).

validation_of_ANY.CONVERT_EXTERN
- The instruction is valid with type ([(REF nul EXTERN)] -> [(REF nul ANY)]).

validation_of_VCONST V128 c
- The instruction is valid with type ([] -> [V128]).

validation_of_VVUNOP V128 vvunop
- The instruction is valid with type ([V128] -> [V128]).

validation_of_VVBINOP V128 vvbinop
- The instruction is valid with type ([V128, V128] -> [V128]).

validation_of_VVTERNOP V128 vvternop
- The instruction is valid with type ([V128, V128, V128] -> [V128]).

validation_of_VVTESTOP V128 vvtestop
- The instruction is valid with type ([V128] -> [I32]).

validation_of_VBITMASK sh
- The instruction is valid with type ([V128] -> [I32]).

validation_of_VSWIZZLE sh
- The instruction is valid with type ([V128, V128] -> [V128]).

validation_of_VSHUFFLE (imm X N) i*
- For all i in i*,
  - i must be less than (N · 2).
- The instruction is valid with type ([V128, V128] -> [V128]).

validation_of_VSPLAT (lnn X N)
- The instruction is valid with type ([$lunpack(lnn)] -> [V128]).

validation_of_VEXTRACT_LANE (lnn X N) sx? i
- i must be less than N.
- The instruction is valid with type ([V128] -> [$lunpack(lnn)]).

validation_of_VREPLACE_LANE (lnn X N) i
- i must be less than N.
- The instruction is valid with type ([V128, $lunpack(lnn)] -> [V128]).

validation_of_VUNOP sh vunop_sh
- The instruction is valid with type ([V128] -> [V128]).

validation_of_VBINOP sh vbinop_sh
- The instruction is valid with type ([V128, V128] -> [V128]).

validation_of_VTESTOP sh vtestop_sh
- The instruction is valid with type ([V128] -> [I32]).

validation_of_VRELOP sh vrelop_sh
- The instruction is valid with type ([V128, V128] -> [V128]).

validation_of_VSHIFTOP sh vshiftop_sh
- The instruction is valid with type ([V128, I32] -> [V128]).

validation_of_VCVTOP sh vcvtop hf? sh sx? zero
- The instruction is valid with type ([V128] -> [V128]).

validation_of_VNARROW sh sh sx
- The instruction is valid with type ([V128, V128] -> [V128]).

validation_of_VEXTUNOP sh sh vextunop sx
- The instruction is valid with type ([V128] -> [V128]).

validation_of_VEXTBINOP sh sh vextbinop sx
- The instruction is valid with type ([V128, V128] -> [V128]).

validation_of_LOCAL.GET x
- |C.LOCAL| must be greater than x.
- Let (init, t) be C.LOCAL[x].
- The instruction is valid with type ([] -> [t]).

validation_of_GLOBAL.GET x
- |C.GLOBAL| must be greater than x.
- Let (mut, t) be C.GLOBAL[x].
- The instruction is valid with type ([] -> [t]).

validation_of_GLOBAL.SET x
- |C.GLOBAL| must be greater than x.
- Let ((MUT ?(())), t) be C.GLOBAL[x].
- The instruction is valid with type ([t] -> []).

validation_of_TABLE.GET x
- |C.TABLE| must be greater than x.
- Let (lim, rt) be C.TABLE[x].
- The instruction is valid with type ([I32] -> [rt]).

validation_of_TABLE.SET x
- |C.TABLE| must be greater than x.
- Let (lim, rt) be C.TABLE[x].
- The instruction is valid with type ([I32, rt] -> []).

validation_of_TABLE.SIZE x
- |C.TABLE| must be greater than x.
- Let tt be C.TABLE[x].
- The instruction is valid with type ([] -> [I32]).

validation_of_TABLE.GROW x
- |C.TABLE| must be greater than x.
- Let (lim, rt) be C.TABLE[x].
- The instruction is valid with type ([rt, I32] -> [I32]).

validation_of_TABLE.FILL x
- |C.TABLE| must be greater than x.
- Let (lim, rt) be C.TABLE[x].
- The instruction is valid with type ([I32, rt, I32] -> []).

validation_of_TABLE.COPY x_1 x_2
- |C.TABLE| must be greater than x_1.
- |C.TABLE| must be greater than x_2.
- Let (lim_1, rt_1) be C.TABLE[x_1].
- Let (lim_2, rt_2) be C.TABLE[x_2].
- Yet: TODO: prem_to_instrs 2
- The instruction is valid with type ([I32, I32, I32] -> []).

validation_of_TABLE.INIT x y
- |C.TABLE| must be greater than x.
- |C.ELEM| must be greater than y.
- Let rt_2 be C.ELEM[y].
- Let (lim, rt_1) be C.TABLE[x].
- Yet: TODO: prem_to_instrs 2
- The instruction is valid with type ([I32, I32, I32] -> []).

validation_of_ELEM.DROP x
- |C.ELEM| must be greater than x.
- Let rt be C.ELEM[x].
- The instruction is valid with type ([] -> []).

validation_of_MEMORY.SIZE x
- |C.MEM| must be greater than x.
- Let mt be C.MEM[x].
- The instruction is valid with type ([] -> [I32]).

validation_of_MEMORY.GROW x
- |C.MEM| must be greater than x.
- Let mt be C.MEM[x].
- The instruction is valid with type ([I32] -> [I32]).

validation_of_MEMORY.FILL x
- |C.MEM| must be greater than x.
- Let mt be C.MEM[x].
- The instruction is valid with type ([I32, I32, I32] -> []).

validation_of_MEMORY.COPY x_1 x_2
- |C.MEM| must be greater than x_1.
- |C.MEM| must be greater than x_2.
- Let mt_1 be C.MEM[x_1].
- Let mt_2 be C.MEM[x_2].
- The instruction is valid with type ([I32, I32, I32] -> []).

validation_of_MEMORY.INIT x y
- |C.MEM| must be greater than x.
- |C.DATA| must be greater than y.
- C.DATA[y] must be equal to OK.
- Let mt be C.MEM[x].
- The instruction is valid with type ([I32, I32, I32] -> []).

validation_of_DATA.DROP x
- |C.DATA| must be greater than x.
- C.DATA[x] must be equal to OK.
- The instruction is valid with type ([] -> []).

validation_of_LOAD nt (n, sx)? x { ALIGN: n_A; OFFSET: n_O; }
- |C.MEM| must be greater than x.
- ((sx? is ?())) and ((n? is ?())) are equivalent.
- (2 ^ n_A) must be less than or equal to ($size(nt) / 8).
- If n is defined,
  - (2 ^ n_A) must be less than or equal to (n / 8).
  - (n / 8) must be less than ($size(nt) / 8).
- n? must be equal to ?().
- Let mt be C.MEM[x].
- The instruction is valid with type ([I32] -> [nt]).

validation_of_STORE nt n? x { ALIGN: n_A; OFFSET: n_O; }
- |C.MEM| must be greater than x.
- (2 ^ n_A) must be less than or equal to ($size(nt) / 8).
- If n is defined,
  - (2 ^ n_A) must be less than or equal to (n / 8).
  - (n / 8) must be less than ($size(nt) / 8).
- n? must be equal to ?().
- Let mt be C.MEM[x].
- The instruction is valid with type ([I32, nt] -> []).

validation_of_VLOAD ?((SHAPE M N sx)) x { ALIGN: n_A; OFFSET: n_O; }
- |C.MEM| must be greater than x.
- (2 ^ n_A) must be less than or equal to ((M / 8) · N).
- Let mt be C.MEM[x].
- The instruction is valid with type ([I32] -> [V128]).

validation_of_VLOAD_LANE n x { ALIGN: n_A; OFFSET: n_O; } laneidx
- |C.MEM| must be greater than x.
- (2 ^ n_A) must be less than (n / 8).
- laneidx must be less than (128 / n).
- Let mt be C.MEM[x].
- The instruction is valid with type ([I32, V128] -> [V128]).

validation_of_VSTORE x { ALIGN: n_A; OFFSET: n_O; }
- |C.MEM| must be greater than x.
- (2 ^ n_A) must be less than or equal to ($size(V128) / 8).
- Let mt be C.MEM[x].
- The instruction is valid with type ([I32, V128] -> []).

validation_of_VSTORE_LANE n x { ALIGN: n_A; OFFSET: n_O; } laneidx
- |C.MEM| must be greater than x.
- (2 ^ n_A) must be less than (n / 8).
- laneidx must be less than (128 / n).
- Let mt be C.MEM[x].
- The instruction is valid with type ([I32, V128] -> []).

Ki
1. Return 1024.

min n_u0 n_u1
1. If (n_u0 is 0), then:
  a. Return 0.
2. If (n_u1 is 0), then:
  a. Return 0.
3. Assert: Due to validation, (n_u0 ≥ 1).
4. Let i be (n_u0 - 1).
5. Assert: Due to validation, (n_u1 ≥ 1).
6. Let j be (n_u1 - 1).
7. Return $min(i, j).

sum n_u0*
1. If (n_u0* is []), then:
  a. Return 0.
2. Let [n] ++ n'* be n_u0*.
3. Return (n + $sum(n'*)).

concat_ X_u0*
1. If (X_u0* is []), then:
  a. Return [].
2. Let [w*] ++ w'** be X_u0*.
3. Return w* ++ $concat_(w'**).

signif N_u0
1. If (N_u0 is 32), then:
  a. Return 23.
2. Assert: Due to validation, (N_u0 is 64).
3. Return 52.

expon N_u0
1. If (N_u0 is 32), then:
  a. Return 8.
2. Assert: Due to validation, (N_u0 is 64).
3. Return 11.

M N
1. Return $signif(N).

E N
1. Return $expon(N).

fzero N
1. Return (POS (SUBNORM 0)).

fone N
1. Return (POS (NORM 1 0)).

canon_ N
1. Return (2 ^ ($signif(N) - 1)).

size valty_u0
1. If (valty_u0 is I32), then:
  a. Return 32.
2. If (valty_u0 is I64), then:
  a. Return 64.
3. If (valty_u0 is F32), then:
  a. Return 32.
4. If (valty_u0 is F64), then:
  a. Return 64.
5. If (valty_u0 is V128), then:
  a. Return 128.

psize packt_u0
1. If (packt_u0 is I8), then:
  a. Return 8.
2. Assert: Due to validation, (packt_u0 is I16).
3. Return 16.

lsize lanet_u0
1. If the type of lanet_u0 is numtype, then:
  a. Let numtype be lanet_u0.
  b. Return $size(numtype).
2. Assert: Due to validation, the type of lanet_u0 is packtype.
3. Let packtype be lanet_u0.
4. Return $psize(packtype).

zsize stora_u0
1. If the type of stora_u0 is valtype, then:
  a. Let valtype be stora_u0.
  b. Return $size(valtype).
2. Assert: Due to validation, the type of stora_u0 is packtype.
3. Let packtype be stora_u0.
4. Return $psize(packtype).

lanetype (lnn X N)
1. Return lnn.

sizenn t
1. Return $size(t).

dim (lnn X N)
1. Return N.

shsize (lnn X N)
1. Return ($lsize(lnn) · N).

setminus1 x idx_u0*
1. If (idx_u0* is []), then:
  a. Return [x].
2. Let [y_1] ++ y* be idx_u0*.
3. If (x is y_1), then:
  a. Return [].
4. Let [y_1] ++ y* be idx_u0*.
5. Return $setminus1(x, y*).

setminus idx_u0* y*
1. If (idx_u0* is []), then:
  a. Return [].
2. Let [x_1] ++ x* be idx_u0*.
3. Return $setminus1(x_1, y*) ++ $setminus(x*, y*).

free_dataidx_instr instr_u0
1. If instr_u0 is of the case MEMORY.INIT, then:
  a. Let (MEMORY.INIT x y) be instr_u0.
  b. Return [y].
2. If instr_u0 is of the case DATA.DROP, then:
  a. Let (DATA.DROP x) be instr_u0.
  b. Return [x].
3. Return [].

free_dataidx_instrs instr_u0*
1. If (instr_u0* is []), then:
  a. Return [].
2. Let [instr] ++ instr'* be instr_u0*.
3. Return $free_dataidx_instr(instr) ++ $free_dataidx_instrs(instr'*).

free_dataidx_expr in*
1. Return $free_dataidx_instrs(in*).

free_dataidx_func (FUNC x loc* e)
1. Return $free_dataidx_expr(e).

free_dataidx_funcs func_u0*
1. If (func_u0* is []), then:
  a. Return [].
2. Let [func] ++ func'* be func_u0*.
3. Return $free_dataidx_func(func) ++ $free_dataidx_funcs(func'*).

lunpack lanet_u0
1. If the type of lanet_u0 is numtype, then:
  a. Let numtype be lanet_u0.
  b. Return numtype.
2. Assert: Due to validation, the type of lanet_u0 is packtype.
3. Return I32.

unpack stora_u0
1. If the type of stora_u0 is valtype, then:
  a. Let valtype be stora_u0.
  b. Return valtype.
2. Assert: Due to validation, the type of stora_u0 is packtype.
3. Return I32.

nunpack stora_u0
1. If the type of stora_u0 is numtype, then:
  a. Let numtype be stora_u0.
  b. Return numtype.
2. If the type of stora_u0 is packtype, then:
  a. Return I32.

vunpack vectype
1. Return vectype.

sxfield stora_u0
1. If the type of stora_u0 is valtype, then:
  a. Return ?().
2. Assert: Due to validation, the type of stora_u0 is packtype.
3. Return ?(S).

diffrt (REF nul_1 ht_1) (REF (NULL _u0?) ht_2)
1. If (_u0? is ?(())), then:
  a. Return (REF (NULL ?()) ht_1).
2. Assert: Due to validation, _u0? is not defined.
3. Return (REF nul_1 ht_1).

idx x
1. Return (_IDX x).

subst_typevar xx typev_u0* heapt_u1*
1. If ((typev_u0* is []) and (heapt_u1* is [])), then:
  a. Return xx.
2. Assert: Due to validation, (|heapt_u1*| ≥ 1).
3. Let [ht_1] ++ ht'* be heapt_u1*.
4. If (|typev_u0*| ≥ 1), then:
  a. Let [xx_1] ++ xx'* be typev_u0*.
  b. If (xx is xx_1), then:
    1) Return ht_1.
5. Let [ht_1] ++ ht'* be heapt_u1*.
6. Assert: Due to validation, (|typev_u0*| ≥ 1).
7. Let [xx_1] ++ xx'* be typev_u0*.
8. Return $subst_typevar(xx, xx'*, ht'*).

subst_numtype nt xx* ht*
1. Return nt.

subst_vectype vt xx* ht*
1. Return vt.

subst_packtype pt xx* ht*
1. Return pt.

subst_heaptype heapt_u0 xx* ht*
1. If the type of heapt_u0 is typevar, then:
  a. Let xx' be heapt_u0.
  b. Return $subst_typevar(xx', xx*, ht*).
2. If the type of heapt_u0 is deftype, then:
  a. Let dt be heapt_u0.
  b. Return $subst_deftype(dt, xx*, ht*).
3. Let ht' be heapt_u0.
4. Return ht'.

subst_reftype (REF nul ht') xx* ht*
1. Return (REF nul $subst_heaptype(ht', xx*, ht*)).

subst_valtype valty_u0 xx* ht*
1. If the type of valty_u0 is numtype, then:
  a. Let nt be valty_u0.
  b. Return $subst_numtype(nt, xx*, ht*).
2. If the type of valty_u0 is vectype, then:
  a. Let vt be valty_u0.
  b. Return $subst_vectype(vt, xx*, ht*).
3. If the type of valty_u0 is reftype, then:
  a. Let rt be valty_u0.
  b. Return $subst_reftype(rt, xx*, ht*).
4. Assert: Due to validation, (valty_u0 is BOT).
5. Return BOT.

subst_storagetype stora_u0 xx* ht*
1. If the type of stora_u0 is valtype, then:
  a. Let t be stora_u0.
  b. Return $subst_valtype(t, xx*, ht*).
2. Assert: Due to validation, the type of stora_u0 is packtype.
3. Let pt be stora_u0.
4. Return $subst_packtype(pt, xx*, ht*).

subst_fieldtype (mut, zt) xx* ht*
1. Return (mut, $subst_storagetype(zt, xx*, ht*)).

subst_comptype compt_u0 xx* ht*
1. If compt_u0 is of the case STRUCT, then:
  a. Let (STRUCT yt*) be compt_u0.
  b. Return (STRUCT $subst_fieldtype(yt, xx*, ht*)*).
2. If compt_u0 is of the case ARRAY, then:
  a. Let (ARRAY yt) be compt_u0.
  b. Return (ARRAY $subst_fieldtype(yt, xx*, ht*)).
3. Assert: Due to validation, compt_u0 is of the case FUNC.
4. Let (FUNC ft) be compt_u0.
5. Return (FUNC $subst_functype(ft, xx*, ht*)).

subst_subtype subty_u0 xx* ht*
1. If subty_u0 is of the case SUB, then:
  a. Let (SUB fin y* ct) be subty_u0.
  b. Return (SUBD fin $subst_heaptype((_IDX y), xx*, ht*)* $subst_comptype(ct, xx*, ht*)).
2. Assert: Due to validation, subty_u0 is of the case SUBD.
3. Let (SUBD fin ht'* ct) be subty_u0.
4. Return (SUBD fin $subst_heaptype(ht', xx*, ht*)* $subst_comptype(ct, xx*, ht*)).

subst_rectype (REC st*) xx* ht*
1. Return (REC $subst_subtype(st, xx*, ht*)*).

subst_deftype (DEF qt i) xx* ht*
1. Return (DEF $subst_rectype(qt, xx*, ht*) i).

subst_functype (t_1* -> t_2*) xx* ht*
1. Return ($subst_valtype(t_1, xx*, ht*)* -> $subst_valtype(t_2, xx*, ht*)*).

subst_globaltype (mut, t) xx* ht*
1. Return (mut, $subst_valtype(t, xx*, ht*)).

subst_tabletype (lim, rt) xx* ht*
1. Return (lim, $subst_reftype(rt, xx*, ht*)).

subst_memtype (I8 lim) xx* ht*
1. Return (I8 lim).

subst_externtype exter_u0 xx* ht*
1. If exter_u0 is of the case FUNC, then:
  a. Let (FUNC dt) be exter_u0.
  b. Return (FUNC $subst_deftype(dt, xx*, ht*)).
2. If exter_u0 is of the case GLOBAL, then:
  a. Let (GLOBAL gt) be exter_u0.
  b. Return (GLOBAL $subst_globaltype(gt, xx*, ht*)).
3. If exter_u0 is of the case TABLE, then:
  a. Let (TABLE tt) be exter_u0.
  b. Return (TABLE $subst_tabletype(tt, xx*, ht*)).
4. Assert: Due to validation, exter_u0 is of the case MEM.
5. Let (MEM mt) be exter_u0.
6. Return (MEM $subst_memtype(mt, xx*, ht*)).

subst_all_reftype rt ht^n
1. Return $subst_reftype(rt, $idx(x)^(x<n), ht^n).

subst_all_deftype dt ht^n
1. Return $subst_deftype(dt, $idx(x)^(x<n), ht^n).

subst_all_deftypes defty_u0* ht*
1. If (defty_u0* is []), then:
  a. Return [].
2. Let [dt_1] ++ dt* be defty_u0*.
3. Return [$subst_all_deftype(dt_1, ht*)] ++ $subst_all_deftypes(dt*, ht*).

rollrt x (REC st^n)
1. Return (REC $subst_subtype(st, $idx((x + i))^(i<n), (REC i)^(i<n))^n).

unrollrt (REC st^n)
1. Let qt be (REC st^n).
2. Return (REC $subst_subtype(st, (REC i)^(i<n), (DEF qt i)^(i<n))^n).

rolldt x qt
1. Assert: Due to validation, $rollrt(x, qt) is of the case REC.
2. Let (REC st^n) be $rollrt(x, qt).
3. Return (DEF (REC st^n) i)^(i<n).

unrolldt (DEF qt i)
1. Assert: Due to validation, $unrollrt(qt) is of the case REC.
2. Let (REC st*) be $unrollrt(qt).
3. Return st*[i].

expanddt dt
1. Assert: Due to validation, $unrolldt(dt) is of the case SUBD.
2. Let (SUBD fin ht* ct) be $unrolldt(dt).
3. Return ct.

funcsxt exter_u0*
1. If (exter_u0* is []), then:
  a. Return [].
2. Let [y_0] ++ et* be exter_u0*.
3. If y_0 is of the case FUNC, then:
  a. Let (FUNC dt) be y_0.
  b. Return [dt] ++ $funcsxt(et*).
4. Let [externtype] ++ et* be exter_u0*.
5. Return $funcsxt(et*).

globalsxt exter_u0*
1. If (exter_u0* is []), then:
  a. Return [].
2. Let [y_0] ++ et* be exter_u0*.
3. If y_0 is of the case GLOBAL, then:
  a. Let (GLOBAL gt) be y_0.
  b. Return [gt] ++ $globalsxt(et*).
4. Let [externtype] ++ et* be exter_u0*.
5. Return $globalsxt(et*).

tablesxt exter_u0*
1. If (exter_u0* is []), then:
  a. Return [].
2. Let [y_0] ++ et* be exter_u0*.
3. If y_0 is of the case TABLE, then:
  a. Let (TABLE tt) be y_0.
  b. Return [tt] ++ $tablesxt(et*).
4. Let [externtype] ++ et* be exter_u0*.
5. Return $tablesxt(et*).

memsxt exter_u0*
1. If (exter_u0* is []), then:
  a. Return [].
2. Let [y_0] ++ et* be exter_u0*.
3. If y_0 is of the case MEM, then:
  a. Let (MEM mt) be y_0.
  b. Return [mt] ++ $memsxt(et*).
4. Let [externtype] ++ et* be exter_u0*.
5. Return $memsxt(et*).

memop0
1. Return { ALIGN: 0; OFFSET: 0; }.

signed N i
1. If (0 ≤ (2 ^ (N - 1))), then:
  a. Return i.
2. Assert: Due to validation, ((2 ^ (N - 1)) ≤ i).
3. Assert: Due to validation, (i < (2 ^ N)).
4. Return (i - (2 ^ N)).

invsigned N i
1. Let j be $inverse_of_signed(N, i).
2. Return j.

unop numty_u1 unop__u0 num__u2
1. If (unop__u0 is CLZ), then:
  a. Let iN be num__u2.
  b. If the type of numty_u1 is inn, then:
    1) Let inn be numty_u1.
    2) Return [$iclz($size(inn), iN)].
2. If (unop__u0 is CTZ), then:
  a. Let iN be num__u2.
  b. If the type of numty_u1 is inn, then:
    1) Let inn be numty_u1.
    2) Return [$ictz($size(inn), iN)].
3. If (unop__u0 is POPCNT), then:
  a. Let iN be num__u2.
  b. If the type of numty_u1 is inn, then:
    1) Let inn be numty_u1.
    2) Return [$ipopcnt($size(inn), iN)].
4. If unop__u0 is of the case EXTEND, then:
  a. Let (EXTEND N) be unop__u0.
  b. Let iN be num__u2.
  c. If the type of numty_u1 is inn, then:
    1) Let inn be numty_u1.
    2) Return [$ext(N, $size(inn), S, $wrap($size(inn), N, iN))].
5. If (unop__u0 is ABS), then:
  a. Let fN be num__u2.
  b. If the type of numty_u1 is fnn, then:
    1) Let fnn be numty_u1.
    2) Return [$fabs($size(fnn), fN)].
6. If (unop__u0 is NEG), then:
  a. Let fN be num__u2.
  b. If the type of numty_u1 is fnn, then:
    1) Let fnn be numty_u1.
    2) Return [$fneg($size(fnn), fN)].
7. If (unop__u0 is SQRT), then:
  a. Let fN be num__u2.
  b. If the type of numty_u1 is fnn, then:
    1) Let fnn be numty_u1.
    2) Return [$fsqrt($size(fnn), fN)].
8. If (unop__u0 is CEIL), then:
  a. Let fN be num__u2.
  b. If the type of numty_u1 is fnn, then:
    1) Let fnn be numty_u1.
    2) Return [$fceil($size(fnn), fN)].
9. If (unop__u0 is FLOOR), then:
  a. Let fN be num__u2.
  b. If the type of numty_u1 is fnn, then:
    1) Let fnn be numty_u1.
    2) Return [$ffloor($size(fnn), fN)].
10. If (unop__u0 is TRUNC), then:
  a. Let fN be num__u2.
  b. If the type of numty_u1 is fnn, then:
    1) Let fnn be numty_u1.
    2) Return [$ftrunc($size(fnn), fN)].
11. Assert: Due to validation, (unop__u0 is NEAREST).
12. Let fN be num__u2.
13. Assert: Due to validation, the type of numty_u1 is fnn.
14. Let fnn be numty_u1.
15. Return [$fnearest($size(fnn), fN)].

binop numty_u1 binop_u0 num__u2 num__u3
1. If (binop_u0 is ADD), then:
  a. Let iN_1 be num__u2.
  b. Let iN_2 be num__u3.
  c. If the type of numty_u1 is inn, then:
    1) Let inn be numty_u1.
    2) Return [$iadd($size(inn), iN_1, iN_2)].
2. If (binop_u0 is SUB), then:
  a. Let iN_1 be num__u2.
  b. Let iN_2 be num__u3.
  c. If the type of numty_u1 is inn, then:
    1) Let inn be numty_u1.
    2) Return [$isub($size(inn), iN_1, iN_2)].
3. If (binop_u0 is MUL), then:
  a. Let iN_1 be num__u2.
  b. Let iN_2 be num__u3.
  c. If the type of numty_u1 is inn, then:
    1) Let inn be numty_u1.
    2) Return [$imul($size(inn), iN_1, iN_2)].
4. Let iN_1 be num__u2.
5. Let iN_2 be num__u3.
6. If the type of numty_u1 is inn, then:
  a. Let inn be numty_u1.
  b. If binop_u0 is of the case DIV, then:
    1) Let (DIV sx) be binop_u0.
    2) Return [$idiv($size(inn), sx, iN_1, iN_2)].
  c. If binop_u0 is of the case REM, then:
    1) Let (REM sx) be binop_u0.
    2) Return [$irem($size(inn), sx, iN_1, iN_2)].
7. If (binop_u0 is AND), then:
  a. Let iN_1 be num__u2.
  b. Let iN_2 be num__u3.
  c. If the type of numty_u1 is inn, then:
    1) Let inn be numty_u1.
    2) Return [$iand($size(inn), iN_1, iN_2)].
8. If (binop_u0 is OR), then:
  a. Let iN_1 be num__u2.
  b. Let iN_2 be num__u3.
  c. If the type of numty_u1 is inn, then:
    1) Let inn be numty_u1.
    2) Return [$ior($size(inn), iN_1, iN_2)].
9. If (binop_u0 is XOR), then:
  a. Let iN_1 be num__u2.
  b. Let iN_2 be num__u3.
  c. If the type of numty_u1 is inn, then:
    1) Let inn be numty_u1.
    2) Return [$ixor($size(inn), iN_1, iN_2)].
10. If (binop_u0 is SHL), then:
  a. Let iN_1 be num__u2.
  b. Let iN_2 be num__u3.
  c. If the type of numty_u1 is inn, then:
    1) Let inn be numty_u1.
    2) Return [$ishl($size(inn), iN_1, iN_2)].
11. Let iN_1 be num__u2.
12. Let iN_2 be num__u3.
13. If the type of numty_u1 is inn, then:
  a. Let inn be numty_u1.
  b. If binop_u0 is of the case SHR, then:
    1) Let (SHR sx) be binop_u0.
    2) Return [$ishr($size(inn), sx, iN_1, iN_2)].
14. If (binop_u0 is ROTL), then:
  a. Let iN_1 be num__u2.
  b. Let iN_2 be num__u3.
  c. If the type of numty_u1 is inn, then:
    1) Let inn be numty_u1.
    2) Return [$irotl($size(inn), iN_1, iN_2)].
15. If (binop_u0 is ROTR), then:
  a. Let iN_1 be num__u2.
  b. Let iN_2 be num__u3.
  c. If the type of numty_u1 is inn, then:
    1) Let inn be numty_u1.
    2) Return [$irotr($size(inn), iN_1, iN_2)].
16. If (binop_u0 is ADD), then:
  a. Let fN_1 be num__u2.
  b. Let fN_2 be num__u3.
  c. If the type of numty_u1 is fnn, then:
    1) Let fnn be numty_u1.
    2) Return [$fadd($size(fnn), fN_1, fN_2)].
17. If (binop_u0 is SUB), then:
  a. Let fN_1 be num__u2.
  b. Let fN_2 be num__u3.
  c. If the type of numty_u1 is fnn, then:
    1) Let fnn be numty_u1.
    2) Return [$fsub($size(fnn), fN_1, fN_2)].
18. If (binop_u0 is MUL), then:
  a. Let fN_1 be num__u2.
  b. Let fN_2 be num__u3.
  c. If the type of numty_u1 is fnn, then:
    1) Let fnn be numty_u1.
    2) Return [$fmul($size(fnn), fN_1, fN_2)].
19. If (binop_u0 is DIV), then:
  a. Let fN_1 be num__u2.
  b. Let fN_2 be num__u3.
  c. If the type of numty_u1 is fnn, then:
    1) Let fnn be numty_u1.
    2) Return [$fdiv($size(fnn), fN_1, fN_2)].
20. If (binop_u0 is MIN), then:
  a. Let fN_1 be num__u2.
  b. Let fN_2 be num__u3.
  c. If the type of numty_u1 is fnn, then:
    1) Let fnn be numty_u1.
    2) Return [$fmin($size(fnn), fN_1, fN_2)].
21. If (binop_u0 is MAX), then:
  a. Let fN_1 be num__u2.
  b. Let fN_2 be num__u3.
  c. If the type of numty_u1 is fnn, then:
    1) Let fnn be numty_u1.
    2) Return [$fmax($size(fnn), fN_1, fN_2)].
22. Assert: Due to validation, (binop_u0 is COPYSIGN).
23. Let fN_1 be num__u2.
24. Let fN_2 be num__u3.
25. Assert: Due to validation, the type of numty_u1 is fnn.
26. Let fnn be numty_u1.
27. Return [$fcopysign($size(fnn), fN_1, fN_2)].

testop inn EQZ iN
1. Return $ieqz($size(inn), iN).

relop numty_u1 relop_u0 num__u2 num__u3
1. If (relop_u0 is EQ), then:
  a. Let iN_1 be num__u2.
  b. Let iN_2 be num__u3.
  c. If the type of numty_u1 is inn, then:
    1) Let inn be numty_u1.
    2) Return $ieq($size(inn), iN_1, iN_2).
2. If (relop_u0 is NE), then:
  a. Let iN_1 be num__u2.
  b. Let iN_2 be num__u3.
  c. If the type of numty_u1 is inn, then:
    1) Let inn be numty_u1.
    2) Return $ine($size(inn), iN_1, iN_2).
3. Let iN_1 be num__u2.
4. Let iN_2 be num__u3.
5. If the type of numty_u1 is inn, then:
  a. Let inn be numty_u1.
  b. If relop_u0 is of the case LT, then:
    1) Let (LT sx) be relop_u0.
    2) Return $ilt($size(inn), sx, iN_1, iN_2).
  c. If relop_u0 is of the case GT, then:
    1) Let (GT sx) be relop_u0.
    2) Return $igt($size(inn), sx, iN_1, iN_2).
  d. If relop_u0 is of the case LE, then:
    1) Let (LE sx) be relop_u0.
    2) Return $ile($size(inn), sx, iN_1, iN_2).
  e. If relop_u0 is of the case GE, then:
    1) Let (GE sx) be relop_u0.
    2) Return $ige($size(inn), sx, iN_1, iN_2).
6. If (relop_u0 is EQ), then:
  a. Let fN_1 be num__u2.
  b. Let fN_2 be num__u3.
  c. If the type of numty_u1 is fnn, then:
    1) Let fnn be numty_u1.
    2) Return $feq($size(fnn), fN_1, fN_2).
7. If (relop_u0 is NE), then:
  a. Let fN_1 be num__u2.
  b. Let fN_2 be num__u3.
  c. If the type of numty_u1 is fnn, then:
    1) Let fnn be numty_u1.
    2) Return $fne($size(fnn), fN_1, fN_2).
8. If (relop_u0 is LT), then:
  a. Let fN_1 be num__u2.
  b. Let fN_2 be num__u3.
  c. If the type of numty_u1 is fnn, then:
    1) Let fnn be numty_u1.
    2) Return $flt($size(fnn), fN_1, fN_2).
9. If (relop_u0 is GT), then:
  a. Let fN_1 be num__u2.
  b. Let fN_2 be num__u3.
  c. If the type of numty_u1 is fnn, then:
    1) Let fnn be numty_u1.
    2) Return $fgt($size(fnn), fN_1, fN_2).
10. If (relop_u0 is LE), then:
  a. Let fN_1 be num__u2.
  b. Let fN_2 be num__u3.
  c. If the type of numty_u1 is fnn, then:
    1) Let fnn be numty_u1.
    2) Return $fle($size(fnn), fN_1, fN_2).
11. Assert: Due to validation, (relop_u0 is GE).
12. Let fN_1 be num__u2.
13. Let fN_2 be num__u3.
14. Assert: Due to validation, the type of numty_u1 is fnn.
15. Let fnn be numty_u1.
16. Return $fge($size(fnn), fN_1, fN_2).

cvtop numty_u0 numty_u1 cvtop_u4 sx_u2? num__u3
1. If ((numty_u0 is I32) and ((numty_u1 is I64) and (cvtop_u4 is CONVERT))), then:
  a. Let iN be num__u3.
  b. If sx_u2? is defined, then:
    1) Let ?(sx) be sx_u2?.
    2) Return [$ext(32, 64, sx, iN)].
2. If ((numty_u0 is I64) and ((numty_u1 is I32) and (cvtop_u4 is CONVERT))), then:
  a. Let iN be num__u3.
  b. Return [$wrap(64, 32, iN)].
3. If (cvtop_u4 is CONVERT), then:
  a. Let fN be num__u3.
  b. If the type of numty_u0 is fnn, then:
    1) Let fnn be numty_u0.
    2) If the type of numty_u1 is inn, then:
      a) Let inn be numty_u1.
      b) If sx_u2? is defined, then:
        1. Let ?(sx) be sx_u2?.
        2. Return [$trunc($size(fnn), $size(inn), sx, fN)].
4. If (cvtop_u4 is CONVERT_SAT), then:
  a. Let fN be num__u3.
  b. If the type of numty_u0 is fnn, then:
    1) Let fnn be numty_u0.
    2) If the type of numty_u1 is inn, then:
      a) Let inn be numty_u1.
      b) If sx_u2? is defined, then:
        1. Let ?(sx) be sx_u2?.
        2. Return [$trunc_sat($size(fnn), $size(inn), sx, fN)].
5. If ((numty_u0 is F32) and ((numty_u1 is F64) and (cvtop_u4 is CONVERT))), then:
  a. Let fN be num__u3.
  b. Return [$promote(32, 64, fN)].
6. If ((numty_u0 is F64) and ((numty_u1 is F32) and (cvtop_u4 is CONVERT))), then:
  a. Let fN be num__u3.
  b. Return [$demote(64, 32, fN)].
7. If ((cvtop_u4 is CONVERT) and the type of numty_u1 is fnn), then:
  a. Let fnn be numty_u1.
  b. Let iN be num__u3.
  c. If the type of numty_u0 is inn, then:
    1) Let inn be numty_u0.
    2) If sx_u2? is defined, then:
      a) Let ?(sx) be sx_u2?.
      b) Return [$convert($size(inn), $size(fnn), sx, iN)].
8. Assert: Due to validation, (cvtop_u4 is REINTERPRET).
9. If the type of numty_u1 is fnn, then:
  a. Let fnn be numty_u1.
  b. Let iN be num__u3.
  c. If the type of numty_u0 is inn, then:
    1) Let inn be numty_u0.
    2) If ($size(inn) is $size(fnn)), then:
      a) Return [$reinterpret(inn, fnn, iN)].
10. Let fN be num__u3.
11. Assert: Due to validation, the type of numty_u0 is fnn.
12. Let fnn be numty_u0.
13. Assert: Due to validation, the type of numty_u1 is inn.
14. Let inn be numty_u1.
15. Assert: Due to validation, ($size(inn) is $size(fnn)).
16. Return [$reinterpret(fnn, inn, fN)].

invibytes N b*
1. Let n be $inverse_of_ibytes(N, b*).
2. Return n.

invfbytes N b*
1. Let p be $inverse_of_fbytes(N, b*).
2. Return p.

packnum lanet_u0 c
1. If the type of lanet_u0 is numtype, then:
  a. Return c.
2. Assert: Due to validation, the type of lanet_u0 is packtype.
3. Let packtype be lanet_u0.
4. Return $wrap($size($lunpack(packtype)), $psize(packtype), c).

unpacknum lanet_u0 c
1. If the type of lanet_u0 is numtype, then:
  a. Return c.
2. Assert: Due to validation, the type of lanet_u0 is packtype.
3. Let packtype be lanet_u0.
4. Return $ext($psize(packtype), $size($lunpack(packtype)), U, c).

invlanes_ sh c*
1. Let vc be $inverse_of_lanes_(sh, c*).
2. Return vc.

halfop half_u0 i j
1. If (half_u0 is LOW), then:
  a. Return i.
2. Assert: Due to validation, (half_u0 is HIGH).
3. Return j.

vvunop V128 NOT v128
1. Return $inot($size(V128), v128).

vvbinop V128 vvbin_u0 v128_1 v128_2
1. If (vvbin_u0 is AND), then:
  a. Return $iand($size(V128), v128_1, v128_2).
2. If (vvbin_u0 is ANDNOT), then:
  a. Return $iandnot($size(V128), v128_1, v128_2).
3. If (vvbin_u0 is OR), then:
  a. Return $ior($size(V128), v128_1, v128_2).
4. Assert: Due to validation, (vvbin_u0 is XOR).
5. Return $ixor($size(V128), v128_1, v128_2).

vvternop V128 BITSELECT v128_1 v128_2 v128_3
1. Return $ibitselect($size(V128), v128_1, v128_2, v128_3).

vunop (lanet_u1 X N) vunop_u0 v128_1
1. If ((vunop_u0 is ABS) and the type of lanet_u1 is imm), then:
  a. Let imm be lanet_u1.
  b. Let lane_1* be $lanes_((imm X N), v128_1).
  c. Let v128 be $invlanes_((imm X N), $iabs($lsize(imm), lane_1)*).
  d. Return v128.
2. If ((vunop_u0 is NEG) and the type of lanet_u1 is imm), then:
  a. Let imm be lanet_u1.
  b. Let lane_1* be $lanes_((imm X N), v128_1).
  c. Let v128 be $invlanes_((imm X N), $ineg($lsize(imm), lane_1)*).
  d. Return v128.
3. If ((vunop_u0 is POPCNT) and the type of lanet_u1 is imm), then:
  a. Let imm be lanet_u1.
  b. Let lane_1* be $lanes_((imm X N), v128_1).
  c. Let v128 be $invlanes_((imm X N), $ipopcnt($lsize(imm), lane_1)*).
  d. Return v128.
4. If ((vunop_u0 is ABS) and the type of lanet_u1 is fnn), then:
  a. Let fnn be lanet_u1.
  b. Let lane_1* be $lanes_((fnn X N), v128_1).
  c. Let v128 be $invlanes_((fnn X N), $fabs($size(fnn), lane_1)*).
  d. Return v128.
5. If ((vunop_u0 is NEG) and the type of lanet_u1 is fnn), then:
  a. Let fnn be lanet_u1.
  b. Let lane_1* be $lanes_((fnn X N), v128_1).
  c. Let v128 be $invlanes_((fnn X N), $fneg($size(fnn), lane_1)*).
  d. Return v128.
6. If ((vunop_u0 is SQRT) and the type of lanet_u1 is fnn), then:
  a. Let fnn be lanet_u1.
  b. Let lane_1* be $lanes_((fnn X N), v128_1).
  c. Let v128 be $invlanes_((fnn X N), $fsqrt($size(fnn), lane_1)*).
  d. Return v128.
7. If ((vunop_u0 is CEIL) and the type of lanet_u1 is fnn), then:
  a. Let fnn be lanet_u1.
  b. Let lane_1* be $lanes_((fnn X N), v128_1).
  c. Let v128 be $invlanes_((fnn X N), $fceil($size(fnn), lane_1)*).
  d. Return v128.
8. If ((vunop_u0 is FLOOR) and the type of lanet_u1 is fnn), then:
  a. Let fnn be lanet_u1.
  b. Let lane_1* be $lanes_((fnn X N), v128_1).
  c. Let v128 be $invlanes_((fnn X N), $ffloor($size(fnn), lane_1)*).
  d. Return v128.
9. If ((vunop_u0 is TRUNC) and the type of lanet_u1 is fnn), then:
  a. Let fnn be lanet_u1.
  b. Let lane_1* be $lanes_((fnn X N), v128_1).
  c. Let v128 be $invlanes_((fnn X N), $ftrunc($size(fnn), lane_1)*).
  d. Return v128.
10. Assert: Due to validation, (vunop_u0 is NEAREST).
11. Assert: Due to validation, the type of lanet_u1 is fnn.
12. Let fnn be lanet_u1.
13. Let lane_1* be $lanes_((fnn X N), v128_1).
14. Let v128 be $invlanes_((fnn X N), $fnearest($size(fnn), lane_1)*).
15. Return v128.

vbinop (lanet_u1 X N) vbino_u0 v128_1 v128_2
1. If ((vbino_u0 is ADD) and the type of lanet_u1 is imm), then:
  a. Let imm be lanet_u1.
  b. Let lane_1* be $lanes_((imm X N), v128_1).
  c. Let lane_2* be $lanes_((imm X N), v128_2).
  d. Let v128 be [$invlanes_((imm X N), $iadd($lsize(imm), lane_1, lane_2)*)].
  e. Return v128.
2. If ((vbino_u0 is SUB) and the type of lanet_u1 is imm), then:
  a. Let imm be lanet_u1.
  b. Let lane_1* be $lanes_((imm X N), v128_1).
  c. Let lane_2* be $lanes_((imm X N), v128_2).
  d. Let v128 be [$invlanes_((imm X N), $isub($lsize(imm), lane_1, lane_2)*)].
  e. Return v128.
3. If the type of lanet_u1 is imm, then:
  a. Let imm be lanet_u1.
  b. If vbino_u0 is of the case MIN, then:
    1) Let (MIN sx) be vbino_u0.
    2) Let lane_1* be $lanes_((imm X N), v128_1).
    3) Let lane_2* be $lanes_((imm X N), v128_2).
    4) Let v128 be [$invlanes_((imm X N), $imin($lsize(imm), sx, lane_1, lane_2)*)].
    5) Return v128.
  c. If vbino_u0 is of the case MAX, then:
    1) Let (MAX sx) be vbino_u0.
    2) Let lane_1* be $lanes_((imm X N), v128_1).
    3) Let lane_2* be $lanes_((imm X N), v128_2).
    4) Let v128 be [$invlanes_((imm X N), $imax($lsize(imm), sx, lane_1, lane_2)*)].
    5) Return v128.
  d. If vbino_u0 is of the case ADD_SAT, then:
    1) Let (ADD_SAT sx) be vbino_u0.
    2) Let lane_1* be $lanes_((imm X N), v128_1).
    3) Let lane_2* be $lanes_((imm X N), v128_2).
    4) Let v128 be [$invlanes_((imm X N), $iaddsat($lsize(imm), sx, lane_1, lane_2)*)].
    5) Return v128.
  e. If vbino_u0 is of the case SUB_SAT, then:
    1) Let (SUB_SAT sx) be vbino_u0.
    2) Let lane_1* be $lanes_((imm X N), v128_1).
    3) Let lane_2* be $lanes_((imm X N), v128_2).
    4) Let v128 be [$invlanes_((imm X N), $isubsat($lsize(imm), sx, lane_1, lane_2)*)].
    5) Return v128.
4. If ((vbino_u0 is MUL) and the type of lanet_u1 is imm), then:
  a. Let imm be lanet_u1.
  b. Let lane_1* be $lanes_((imm X N), v128_1).
  c. Let lane_2* be $lanes_((imm X N), v128_2).
  d. Let v128 be [$invlanes_((imm X N), $imul($lsize(imm), lane_1, lane_2)*)].
  e. Return v128.
5. If ((vbino_u0 is AVGR_U) and the type of lanet_u1 is imm), then:
  a. Let imm be lanet_u1.
  b. Let lane_1* be $lanes_((imm X N), v128_1).
  c. Let lane_2* be $lanes_((imm X N), v128_2).
  d. Let v128 be [$invlanes_((imm X N), $iavgr_u($lsize(imm), lane_1, lane_2)*)].
  e. Return v128.
6. If ((vbino_u0 is Q15MULR_SAT_S) and the type of lanet_u1 is imm), then:
  a. Let imm be lanet_u1.
  b. Let lane_1* be $lanes_((imm X N), v128_1).
  c. Let lane_2* be $lanes_((imm X N), v128_2).
  d. Let v128 be [$invlanes_((imm X N), $iq15mulrsat_s($lsize(imm), lane_1, lane_2)*)].
  e. Return v128.
7. If ((vbino_u0 is ADD) and the type of lanet_u1 is fnn), then:
  a. Let fnn be lanet_u1.
  b. Let lane_1* be $lanes_((fnn X N), v128_1).
  c. Let lane_2* be $lanes_((fnn X N), v128_2).
  d. Let v128 be [$invlanes_((fnn X N), $fadd($size(fnn), lane_1, lane_2)*)].
  e. Return v128.
8. If ((vbino_u0 is SUB) and the type of lanet_u1 is fnn), then:
  a. Let fnn be lanet_u1.
  b. Let lane_1* be $lanes_((fnn X N), v128_1).
  c. Let lane_2* be $lanes_((fnn X N), v128_2).
  d. Let v128 be [$invlanes_((fnn X N), $fsub($size(fnn), lane_1, lane_2)*)].
  e. Return v128.
9. If ((vbino_u0 is MUL) and the type of lanet_u1 is fnn), then:
  a. Let fnn be lanet_u1.
  b. Let lane_1* be $lanes_((fnn X N), v128_1).
  c. Let lane_2* be $lanes_((fnn X N), v128_2).
  d. Let v128 be [$invlanes_((fnn X N), $fmul($size(fnn), lane_1, lane_2)*)].
  e. Return v128.
10. If ((vbino_u0 is DIV) and the type of lanet_u1 is fnn), then:
  a. Let fnn be lanet_u1.
  b. Let lane_1* be $lanes_((fnn X N), v128_1).
  c. Let lane_2* be $lanes_((fnn X N), v128_2).
  d. Let v128 be [$invlanes_((fnn X N), $fdiv($size(fnn), lane_1, lane_2)*)].
  e. Return v128.
11. If ((vbino_u0 is MIN) and the type of lanet_u1 is fnn), then:
  a. Let fnn be lanet_u1.
  b. Let lane_1* be $lanes_((fnn X N), v128_1).
  c. Let lane_2* be $lanes_((fnn X N), v128_2).
  d. Let v128 be [$invlanes_((fnn X N), $fmin($size(fnn), lane_1, lane_2)*)].
  e. Return v128.
12. If ((vbino_u0 is MAX) and the type of lanet_u1 is fnn), then:
  a. Let fnn be lanet_u1.
  b. Let lane_1* be $lanes_((fnn X N), v128_1).
  c. Let lane_2* be $lanes_((fnn X N), v128_2).
  d. Let v128 be [$invlanes_((fnn X N), $fmax($size(fnn), lane_1, lane_2)*)].
  e. Return v128.
13. If ((vbino_u0 is PMIN) and the type of lanet_u1 is fnn), then:
  a. Let fnn be lanet_u1.
  b. Let lane_1* be $lanes_((fnn X N), v128_1).
  c. Let lane_2* be $lanes_((fnn X N), v128_2).
  d. Let v128 be [$invlanes_((fnn X N), $fpmin($size(fnn), lane_1, lane_2)*)].
  e. Return v128.
14. Assert: Due to validation, (vbino_u0 is PMAX).
15. Assert: Due to validation, the type of lanet_u1 is fnn.
16. Let fnn be lanet_u1.
17. Let lane_1* be $lanes_((fnn X N), v128_1).
18. Let lane_2* be $lanes_((fnn X N), v128_2).
19. Let v128 be [$invlanes_((fnn X N), $fpmax($size(fnn), lane_1, lane_2)*)].
20. Return v128.

vrelop (lanet_u1 X N) vrelo_u0 v128_1 v128_2
1. If ((vrelo_u0 is EQ) and the type of lanet_u1 is imm), then:
  a. Let imm be lanet_u1.
  b. Let lane_1* be $lanes_((imm X N), v128_1).
  c. Let lane_2* be $lanes_((imm X N), v128_2).
  d. Let lane_3* be $ext(1, $lsize(imm), S, $ieq($lsize(imm), lane_1, lane_2))*.
  e. Let v128 be $invlanes_((imm X N), lane_3*).
  f. Return v128.
2. If ((vrelo_u0 is NE) and the type of lanet_u1 is imm), then:
  a. Let imm be lanet_u1.
  b. Let lane_1* be $lanes_((imm X N), v128_1).
  c. Let lane_2* be $lanes_((imm X N), v128_2).
  d. Let lane_3* be $ext(1, $lsize(imm), S, $ine($lsize(imm), lane_1, lane_2))*.
  e. Let v128 be $invlanes_((imm X N), lane_3*).
  f. Return v128.
3. If the type of lanet_u1 is imm, then:
  a. Let imm be lanet_u1.
  b. If vrelo_u0 is of the case LT, then:
    1) Let (LT sx) be vrelo_u0.
    2) Let lane_1* be $lanes_((imm X N), v128_1).
    3) Let lane_2* be $lanes_((imm X N), v128_2).
    4) Let lane_3* be $ext(1, $lsize(imm), S, $ilt($lsize(imm), sx, lane_1, lane_2))*.
    5) Let v128 be $invlanes_((imm X N), lane_3*).
    6) Return v128.
  c. If vrelo_u0 is of the case GT, then:
    1) Let (GT sx) be vrelo_u0.
    2) Let lane_1* be $lanes_((imm X N), v128_1).
    3) Let lane_2* be $lanes_((imm X N), v128_2).
    4) Let lane_3* be $ext(1, $lsize(imm), S, $igt($lsize(imm), sx, lane_1, lane_2))*.
    5) Let v128 be $invlanes_((imm X N), lane_3*).
    6) Return v128.
  d. If vrelo_u0 is of the case LE, then:
    1) Let (LE sx) be vrelo_u0.
    2) Let lane_1* be $lanes_((imm X N), v128_1).
    3) Let lane_2* be $lanes_((imm X N), v128_2).
    4) Let lane_3* be $ext(1, $lsize(imm), S, $ile($lsize(imm), sx, lane_1, lane_2))*.
    5) Let v128 be $invlanes_((imm X N), lane_3*).
    6) Return v128.
  e. If vrelo_u0 is of the case GE, then:
    1) Let (GE sx) be vrelo_u0.
    2) Let lane_1* be $lanes_((imm X N), v128_1).
    3) Let lane_2* be $lanes_((imm X N), v128_2).
    4) Let lane_3* be $ext(1, $lsize(imm), S, $ige($lsize(imm), sx, lane_1, lane_2))*.
    5) Let v128 be $invlanes_((imm X N), lane_3*).
    6) Return v128.
4. If (lanet_u1 is F32), then:
  a. If (vrelo_u0 is EQ), then:
    1) Let lane_1* be $lanes_((F32 X N), v128_1).
    2) Let lane_2* be $lanes_((F32 X N), v128_2).
    3) Let lane_3* be $ext(1, 32, S, $feq(32, lane_1, lane_2))*.
    4) Let v128 be $invlanes_((I32 X N), lane_3*).
    5) Return v128.
  b. If (vrelo_u0 is NE), then:
    1) Let lane_1* be $lanes_((F32 X N), v128_1).
    2) Let lane_2* be $lanes_((F32 X N), v128_2).
    3) Let lane_3* be $ext(1, 32, S, $fne(32, lane_1, lane_2))*.
    4) Let v128 be $invlanes_((I32 X N), lane_3*).
    5) Return v128.
  c. If (vrelo_u0 is LT), then:
    1) Let lane_1* be $lanes_((F32 X N), v128_1).
    2) Let lane_2* be $lanes_((F32 X N), v128_2).
    3) Let lane_3* be $ext(1, 32, S, $flt(32, lane_1, lane_2))*.
    4) Let v128 be $invlanes_((I32 X N), lane_3*).
    5) Return v128.
  d. If (vrelo_u0 is GT), then:
    1) Let lane_1* be $lanes_((F32 X N), v128_1).
    2) Let lane_2* be $lanes_((F32 X N), v128_2).
    3) Let lane_3* be $ext(1, 32, S, $fgt(32, lane_1, lane_2))*.
    4) Let v128 be $invlanes_((I32 X N), lane_3*).
    5) Return v128.
  e. If (vrelo_u0 is LE), then:
    1) Let lane_1* be $lanes_((F32 X N), v128_1).
    2) Let lane_2* be $lanes_((F32 X N), v128_2).
    3) Let lane_3* be $ext(1, 32, S, $fle(32, lane_1, lane_2))*.
    4) Let v128 be $invlanes_((I32 X N), lane_3*).
    5) Return v128.
  f. If (vrelo_u0 is GE), then:
    1) Let lane_1* be $lanes_((F32 X N), v128_1).
    2) Let lane_2* be $lanes_((F32 X N), v128_2).
    3) Let lane_3* be $ext(1, 32, S, $fge(32, lane_1, lane_2))*.
    4) Let v128 be $invlanes_((I32 X N), lane_3*).
    5) Return v128.
5. Assert: Due to validation, (lanet_u1 is F64).
6. If (vrelo_u0 is EQ), then:
  a. Let lane_1* be $lanes_((F64 X N), v128_1).
  b. Let lane_2* be $lanes_((F64 X N), v128_2).
  c. Let lane_3* be $ext(1, 64, S, $feq(64, lane_1, lane_2))*.
  d. Let v128 be $invlanes_((I64 X N), lane_3*).
  e. Return v128.
7. If (vrelo_u0 is NE), then:
  a. Let lane_1* be $lanes_((F64 X N), v128_1).
  b. Let lane_2* be $lanes_((F64 X N), v128_2).
  c. Let lane_3* be $ext(1, 64, S, $fne(64, lane_1, lane_2))*.
  d. Let v128 be $invlanes_((I64 X N), lane_3*).
  e. Return v128.
8. If (vrelo_u0 is LT), then:
  a. Let lane_1* be $lanes_((F64 X N), v128_1).
  b. Let lane_2* be $lanes_((F64 X N), v128_2).
  c. Let lane_3* be $ext(1, 64, S, $flt(64, lane_1, lane_2))*.
  d. Let v128 be $invlanes_((I64 X N), lane_3*).
  e. Return v128.
9. If (vrelo_u0 is GT), then:
  a. Let lane_1* be $lanes_((F64 X N), v128_1).
  b. Let lane_2* be $lanes_((F64 X N), v128_2).
  c. Let lane_3* be $ext(1, 64, S, $fgt(64, lane_1, lane_2))*.
  d. Let v128 be $invlanes_((I64 X N), lane_3*).
  e. Return v128.
10. If (vrelo_u0 is LE), then:
  a. Let lane_1* be $lanes_((F64 X N), v128_1).
  b. Let lane_2* be $lanes_((F64 X N), v128_2).
  c. Let lane_3* be $ext(1, 64, S, $fle(64, lane_1, lane_2))*.
  d. Let v128 be $invlanes_((I64 X N), lane_3*).
  e. Return v128.
11. Assert: Due to validation, (vrelo_u0 is GE).
12. Let lane_1* be $lanes_((F64 X N), v128_1).
13. Let lane_2* be $lanes_((F64 X N), v128_2).
14. Let lane_3* be $ext(1, 64, S, $fge(64, lane_1, lane_2))*.
15. Let v128 be $invlanes_((I64 X N), lane_3*).
16. Return v128.

vcvtop (lanet_u0 X N_1) (lanet_u1 X N_2) vcvto_u3 ?(sx) lane__u2
1. If ((lanet_u0 is I8) and ((lanet_u1 is I16) and (vcvto_u3 is EXTEND))), then:
  a. Let i8 be lane__u2.
  b. Let i16 be $ext(8, 16, sx, i8).
  c. Return i16.
2. If ((lanet_u0 is I16) and ((lanet_u1 is I32) and (vcvto_u3 is EXTEND))), then:
  a. Let i16 be lane__u2.
  b. Let i32 be $ext(16, 32, sx, i16).
  c. Return i32.
3. If ((lanet_u0 is I32) and ((lanet_u1 is I64) and (vcvto_u3 is EXTEND))), then:
  a. Let i32 be lane__u2.
  b. Let i64 be $ext(32, 64, sx, i32).
  c. Return i64.
4. If ((lanet_u0 is F32) and ((lanet_u1 is I32) and (vcvto_u3 is TRUNC_SAT))), then:
  a. Let f32 be lane__u2.
  b. Let i32 be $trunc_sat(32, 32, sx, f32).
  c. Return i32.
5. If ((lanet_u0 is F64) and ((lanet_u1 is I32) and (vcvto_u3 is TRUNC_SAT))), then:
  a. Let f64 be lane__u2.
  b. Let i32 be $trunc_sat(64, 32, sx, f64).
  c. Return i32.
6. If (lanet_u0 is I32), then:
  a. If ((lanet_u1 is F32) and (vcvto_u3 is CONVERT)), then:
    1) Let i32 be lane__u2.
    2) Let f32 be $convert(32, 32, sx, i32).
    3) Return f32.
  b. If ((lanet_u1 is F64) and (vcvto_u3 is CONVERT)), then:
    1) Let i32 be lane__u2.
    2) Let f64 be $convert(32, 64, sx, i32).
    3) Return f64.
7. If ((lanet_u0 is F64) and ((lanet_u1 is F32) and (vcvto_u3 is DEMOTE))), then:
  a. Let f64 be lane__u2.
  b. Let f32 be $demote(64, 32, f64).
  c. Return f32.
8. Assert: Due to validation, (lanet_u0 is F32).
9. Assert: Due to validation, (lanet_u1 is F64).
10. Assert: Due to validation, (vcvto_u3 is PROMOTE).
11. Let f32 be lane__u2.
12. Let f64 be $promote(32, 64, f32).
13. Return f64.

vextbinop (inn_1 X N_1) (inn_2 X N_2) DOT sx c_1 c_2
1. Let ci_1* be $lanes_((inn_2 X N_2), c_1).
2. Let ci_2* be $lanes_((inn_2 X N_2), c_2).
3. Let [cj_1, cj_2]* be $inverse_of_concat_($imul($lsize(inn_1), $ext($lsize(inn_2), $lsize(inn_1), S, ci_1), $ext($lsize(inn_2), $lsize(inn_1), S, ci_2))*).
4. Let c be $invlanes_((inn_1 X N_1), $iadd($lsize(inn_1), cj_1, cj_2)^N_1).
5. Return c.

vishiftop (imm X N) vshif_u0 lane n
1. If (vshif_u0 is SHL), then:
  a. Return $ishl($lsize(imm), lane, n).
2. Assert: Due to validation, vshif_u0 is of the case SHR.
3. Let (SHR sx) be vshif_u0.
4. Return $ishr($lsize(imm), sx, lane, n).

inst_reftype mm rt
1. Let dt* be mm.TYPE.
2. Return $subst_all_reftype(rt, dt*).

default valty_u0
1. If (valty_u0 is I32), then:
  a. Return ?((I32.CONST 0)).
2. If (valty_u0 is I64), then:
  a. Return ?((I64.CONST 0)).
3. If (valty_u0 is F32), then:
  a. Return ?((F32.CONST $fzero(32))).
4. If (valty_u0 is F64), then:
  a. Return ?((F64.CONST $fzero(64))).
5. If (valty_u0 is V128), then:
  a. Return ?((V128.CONST 0)).
6. Assert: Due to validation, valty_u0 is of the case REF.
7. Let (REF y_0 ht) be valty_u0.
8. If (y_0 is (NULL ?(()))), then:
  a. Return ?((REF.NULL ht)).
9. Assert: Due to validation, (y_0 is (NULL ?())).
10. Return ?().

packval stora_u0 val_u1
1. If the type of stora_u0 is valtype, then:
  a. Let val be val_u1.
  b. Return val.
2. Assert: Due to validation, val_u1 is of the case CONST.
3. Let (y_0.CONST i) be val_u1.
4. Assert: Due to validation, (y_0 is I32).
5. Assert: Due to validation, the type of stora_u0 is packtype.
6. Let pt be stora_u0.
7. Return (PACK pt $wrap(32, $psize(pt), i)).

unpackval stora_u0 sx_u1? field_u2
1. If sx_u1? is not defined, then:
  a. Assert: Due to validation, the type of stora_u0 is valtype.
  b. Assert: Due to validation, the type of field_u2 is val.
  c. Let val be field_u2.
  d. Return val.
2. Else:
  a. Let ?(sx) be sx_u1?.
  b. Assert: Due to validation, field_u2 is of the case PACK.
  c. Let (PACK pt i) be field_u2.
  d. Assert: Due to validation, (stora_u0 is pt).
  e. Return (I32.CONST $ext($psize(pt), 32, sx, i)).

funcsxv exter_u0*
1. If (exter_u0* is []), then:
  a. Return [].
2. Let [y_0] ++ xv* be exter_u0*.
3. If y_0 is of the case FUNC, then:
  a. Let (FUNC fa) be y_0.
  b. Return [fa] ++ $funcsxv(xv*).
4. Let [externval] ++ xv* be exter_u0*.
5. Return $funcsxv(xv*).

globalsxv exter_u0*
1. If (exter_u0* is []), then:
  a. Return [].
2. Let [y_0] ++ xv* be exter_u0*.
3. If y_0 is of the case GLOBAL, then:
  a. Let (GLOBAL ga) be y_0.
  b. Return [ga] ++ $globalsxv(xv*).
4. Let [externval] ++ xv* be exter_u0*.
5. Return $globalsxv(xv*).

tablesxv exter_u0*
1. If (exter_u0* is []), then:
  a. Return [].
2. Let [y_0] ++ xv* be exter_u0*.
3. If y_0 is of the case TABLE, then:
  a. Let (TABLE ta) be y_0.
  b. Return [ta] ++ $tablesxv(xv*).
4. Let [externval] ++ xv* be exter_u0*.
5. Return $tablesxv(xv*).

memsxv exter_u0*
1. If (exter_u0* is []), then:
  a. Return [].
2. Let [y_0] ++ xv* be exter_u0*.
3. If y_0 is of the case MEM, then:
  a. Let (MEM ma) be y_0.
  b. Return [ma] ++ $memsxv(xv*).
4. Let [externval] ++ xv* be exter_u0*.
5. Return $memsxv(xv*).

store
1. Return.

frame
1. Let f be the current frame.
2. Return f.

funcaddr
1. Let f be the current frame.
2. Return f.MODULE.FUNC.

funcinst
1. Return s.FUNC.

globalinst
1. Return s.GLOBAL.

tableinst
1. Return s.TABLE.

meminst
1. Return s.MEM.

eleminst
1. Return s.ELEM.

datainst
1. Return s.DATA.

structinst
1. Return s.STRUCT.

arrayinst
1. Return s.ARRAY.

moduleinst
1. Let f be the current frame.
2. Return f.MODULE.

type x
1. Let f be the current frame.
2. Return f.MODULE.TYPE[x].

func x
1. Let f be the current frame.
2. Return s.FUNC[f.MODULE.FUNC[x]].

global x
1. Let f be the current frame.
2. Return s.GLOBAL[f.MODULE.GLOBAL[x]].

table x
1. Let f be the current frame.
2. Return s.TABLE[f.MODULE.TABLE[x]].

mem x
1. Let f be the current frame.
2. Return s.MEM[f.MODULE.MEM[x]].

elem x
1. Let f be the current frame.
2. Return s.ELEM[f.MODULE.ELEM[x]].

data x
1. Let f be the current frame.
2. Return s.DATA[f.MODULE.DATA[x]].

local x
1. Let f be the current frame.
2. Return f.LOCAL[x].

with_local x v
1. Let f be the current frame.
2. Replace f.LOCAL[x] with ?(v).

with_global x v
1. Let f be the current frame.
2. Replace s.GLOBAL[f.MODULE.GLOBAL[x]].VALUE with v.

with_table x i r
1. Let f be the current frame.
2. Replace s.TABLE[f.MODULE.TABLE[x]].ELEM[i] with r.

with_tableinst x ti
1. Let f be the current frame.
2. Replace s.TABLE[f.MODULE.TABLE[x]] with ti.

with_mem x i j b*
1. Let f be the current frame.
2. Replace s.MEM[f.MODULE.MEM[x]].DATA[i : j] with b*.

with_meminst x mi
1. Let f be the current frame.
2. Replace s.MEM[f.MODULE.MEM[x]] with mi.

with_elem x r*
1. Let f be the current frame.
2. Replace s.ELEM[f.MODULE.ELEM[x]].ELEM with r*.

with_data x b*
1. Let f be the current frame.
2. Replace s.DATA[f.MODULE.DATA[x]].DATA with b*.

with_struct a i fv
1. Replace s.STRUCT[a].FIELD[i] with fv.

with_array a i fv
1. Replace s.ARRAY[a].FIELD[i] with fv.

ext_structinst si*
1. Let f be the current frame.
2. Return (s with .STRUCT appended by si*, f).

ext_arrayinst ai*
1. Let f be the current frame.
2. Return (s with .ARRAY appended by ai*, f).

growtable ti n r
1. Let { TYPE: ((i, j), rt); ELEM: r'*; } be ti.
2. Let i' be (|r'*| + n).
3. If (i' ≤ j), then:
  a. Let ti' be { TYPE: ((i', j), rt); ELEM: r'* ++ r^n; }.
  b. Return ti'.

growmemory mi n
1. Let { TYPE: (I8 (i, j)); DATA: b*; } be mi.
2. Let i' be ((|b*| / (64 · $Ki())) + n).
3. If (i' ≤ j), then:
  a. Let mi' be { TYPE: (I8 (i', j)); DATA: b* ++ 0^((n · 64) · $Ki()); }.
  b. Return mi'.

with_locals C local_u0* local_u1*
1. If ((local_u0* is []) and (local_u1* is [])), then:
  a. Return C.
2. Assert: Due to validation, (|local_u1*| ≥ 1).
3. Let [lt_1] ++ lt* be local_u1*.
4. Assert: Due to validation, (|local_u0*| ≥ 1).
5. Let [x_1] ++ x* be local_u0*.
6. Return $with_locals(C with .LOCAL[x_1] replaced by lt_1, x*, lt*).

clostypes defty_u0*
1. If (defty_u0* is []), then:
  a. Return [].
2. Let dt* ++ [dt_N] be defty_u0*.
3. Let dt'* be $clostypes(dt*).
4. Return dt'* ++ [$subst_all_deftype(dt_N, dt'*)].

clostype C dt
1. Let dt'* be $clostypes(C.TYPE).
2. Return $subst_all_deftype(dt, dt'*).

before heapt_u0 x i
1. If the type of heapt_u0 is deftype, then:
  a. Return true.
2. If heapt_u0 is of the case _IDX, then:
  a. Let (_IDX typeidx) be heapt_u0.
  b. Return (typeidx < x).
3. Assert: Due to validation, heapt_u0 is of the case REC.
4. Let (REC j) be heapt_u0.
5. Return (j < i).

unrollht C heapt_u0
1. If the type of heapt_u0 is deftype, then:
  a. Let deftype be heapt_u0.
  b. Return $unrolldt(deftype).
2. If heapt_u0 is of the case _IDX, then:
  a. Let (_IDX typeidx) be heapt_u0.
  b. Return $unrolldt(C.TYPE[typeidx]).
3. Assert: Due to validation, heapt_u0 is of the case REC.
4. Let (REC i) be heapt_u0.
5. Return C.REC[i].

in_binop nt binop binop_u0*
1. Return false.
2. Assert: Due to validation, (|binop_u0*| ≥ 1).
3. Let [ibinop_1] ++ ibinop'* be binop_u0*.
4. Return ((binop is ibinop_1) or $in_binop(nt, binop, ibinop'*)).

in_numtype nt numty_u0*
1. Return false.
2. Assert: Due to validation, (|numty_u0*| ≥ 1).
3. Let [nt_1] ++ nt'* be numty_u0*.
4. Return ((nt is nt_1) or $in_numtype(nt, nt'*)).

blocktype block_u1
1. If (block_u1 is (_RESULT ?())), then:
  a. Return ([] -> []).
2. If block_u1 is of the case _RESULT, then:
  a. Let (_RESULT y_0) be block_u1.
  b. If y_0 is defined, then:
    1) Let ?(t) be y_0.
    2) Return ([] -> [t]).
3. Assert: Due to validation, block_u1 is of the case _IDX.
4. Let (_IDX x) be block_u1.
5. Assert: Due to validation, $expanddt($type(x)) is of the case FUNC.
6. Let (FUNC ft) be $expanddt($type(x)).
7. Return ft.

alloctypes type_u0*
1. If (type_u0* is []), then:
  a. Return [].
2. Let type'* ++ [type] be type_u0*.
3. Let deftype'* be $alloctypes(type'*).
4. Assert: Due to validation, type is of the case TYPE.
5. Let (TYPE rectype) be type.
6. Let x be |deftype'*|.
7. Let deftype* be $subst_all_deftypes($rolldt(x, rectype), deftype'*).
8. Return deftype'* ++ deftype*.

allocfunc mm func
1. Assert: Due to validation, func is of the case FUNC.
2. Let (FUNC x local* expr) be func.
3. Let fi be { TYPE: mm.TYPE[x]; MODULE: mm; CODE: func; }.
4. Let a be |s.FUNC|.
5. Append fi to the s.FUNC.
6. Return a.

allocfuncs mm func_u0*
1. If (func_u0* is []), then:
  a. Return [].
2. Let [func] ++ func'* be func_u0*.
3. Let fa be $allocfunc(mm, func).
4. Let fa'* be $allocfuncs(mm, func'*).
5. Return [fa] ++ fa'*.

allocglobal globaltype val
1. Let gi be { TYPE: globaltype; VALUE: val; }.
2. Let a be |s.GLOBAL|.
3. Append gi to the s.GLOBAL.
4. Return a.

allocglobals globa_u0* val_u1*
1. If (globa_u0* is []), then:
  a. Assert: Due to validation, (val_u1* is []).
  b. Return [].
2. Else:
  a. Let [globaltype] ++ globaltype'* be globa_u0*.
  b. Assert: Due to validation, (|val_u1*| ≥ 1).
  c. Let [val] ++ val'* be val_u1*.
  d. Let ga be $allocglobal(globaltype, val).
  e. Let ga'* be $allocglobals(globaltype'*, val'*).
  f. Return [ga] ++ ga'*.

alloctable ((i, j), rt) ref
1. Let ti be { TYPE: ((i, j), rt); ELEM: ref^i; }.
2. Let a be |s.TABLE|.
3. Append ti to the s.TABLE.
4. Return a.

alloctables table_u0* ref_u1*
1. If ((table_u0* is []) and (ref_u1* is [])), then:
  a. Return [].
2. Assert: Due to validation, (|ref_u1*| ≥ 1).
3. Let [ref] ++ ref'* be ref_u1*.
4. Assert: Due to validation, (|table_u0*| ≥ 1).
5. Let [tabletype] ++ tabletype'* be table_u0*.
6. Let ta be $alloctable(tabletype, ref).
7. Let ta'* be $alloctables(tabletype'*, ref'*).
8. Return [ta] ++ ta'*.

allocmem (I8 (i, j))
1. Let mi be { TYPE: (I8 (i, j)); DATA: 0^((i · 64) · $Ki()); }.
2. Let a be |s.MEM|.
3. Append mi to the s.MEM.
4. Return a.

allocmems memty_u0*
1. If (memty_u0* is []), then:
  a. Return [].
2. Let [memtype] ++ memtype'* be memty_u0*.
3. Let ma be $allocmem(memtype).
4. Let ma'* be $allocmems(memtype'*).
5. Return [ma] ++ ma'*.

allocelem rt ref*
1. Let ei be { TYPE: rt; ELEM: ref*; }.
2. Let a be |s.ELEM|.
3. Append ei to the s.ELEM.
4. Return a.

allocelems refty_u0* ref_u1*
1. If ((refty_u0* is []) and (ref_u1* is [])), then:
  a. Return [].
2. Assert: Due to validation, (|ref_u1*| ≥ 1).
3. Let [ref*] ++ ref'** be ref_u1*.
4. Assert: Due to validation, (|refty_u0*| ≥ 1).
5. Let [rt] ++ rt'* be refty_u0*.
6. Let ea be $allocelem(rt, ref*).
7. Let ea'* be $allocelems(rt'*, ref'**).
8. Return [ea] ++ ea'*.

allocdata byte*
1. Let di be { DATA: byte*; }.
2. Let a be |s.DATA|.
3. Append di to the s.DATA.
4. Return a.

allocdatas byte_u0*
1. If (byte_u0* is []), then:
  a. Return [].
2. Let [byte*] ++ byte'** be byte_u0*.
3. Let da be $allocdata(byte*).
4. Let da'* be $allocdatas(byte'**).
5. Return [da] ++ da'*.

instexport fa* ga* ta* ma* (EXPORT name exter_u0)
1. If exter_u0 is of the case FUNC, then:
  a. Let (FUNC x) be exter_u0.
  b. Return { NAME: name; VALUE: (FUNC fa*[x]); }.
2. If exter_u0 is of the case GLOBAL, then:
  a. Let (GLOBAL x) be exter_u0.
  b. Return { NAME: name; VALUE: (GLOBAL ga*[x]); }.
3. If exter_u0 is of the case TABLE, then:
  a. Let (TABLE x) be exter_u0.
  b. Return { NAME: name; VALUE: (TABLE ta*[x]); }.
4. Assert: Due to validation, exter_u0 is of the case MEM.
5. Let (MEM x) be exter_u0.
6. Return { NAME: name; VALUE: (MEM ma*[x]); }.

allocmodule module externval* val_g* ref_t* ref_e**
1. Let fa_ex* be $funcsxv(externval*).
2. Let ga_ex* be $globalsxv(externval*).
3. Let ma_ex* be $memsxv(externval*).
4. Let ta_ex* be $tablesxv(externval*).
5. Assert: Due to validation, module is of the case MODULE.
6. Let (MODULE type* import* func^n_f y_0 y_1 y_2 y_3 y_4 start? export*) be module.
7. Let (DATA byte* datamode)^n_d be y_4.
8. Let (ELEM reftype expr_e* elemmode)^n_e be y_3.
9. Let (MEMORY memtype)^n_m be y_2.
10. Let (TABLE tabletype expr_t)^n_t be y_1.
11. Let (GLOBAL globaltype expr_g)^n_g be y_0.
12. Let dt* be $alloctypes(type*).
13. Let fa* be (|s.FUNC| + i_f)^(i_f<n_f).
14. Let ga* be (|s.GLOBAL| + i_g)^(i_g<n_g).
15. Let ta* be (|s.TABLE| + i_t)^(i_t<n_t).
16. Let ma* be (|s.MEM| + i_m)^(i_m<n_m).
17. Let ea* be (|s.ELEM| + i_e)^(i_e<n_e).
18. Let da* be (|s.DATA| + i_d)^(i_d<n_d).
19. Let xi* be $instexport(fa_ex* ++ fa*, ga_ex* ++ ga*, ta_ex* ++ ta*, ma_ex* ++ ma*, export)*.
20. Let mm be { TYPE: dt*; FUNC: fa_ex* ++ fa*; GLOBAL: ga_ex* ++ ga*; TABLE: ta_ex* ++ ta*; MEM: ma_ex* ++ ma*; ELEM: ea*; DATA: da*; EXPORT: xi*; }.
21. Let y_0 be $allocfuncs(mm, func^n_f).
22. Assert: Due to validation, (y_0 is fa*).
23. Let y_0 be $allocglobals(globaltype^n_g, val_g*).
24. Assert: Due to validation, (y_0 is ga*).
25. Let y_0 be $alloctables(tabletype^n_t, ref_t*).
26. Assert: Due to validation, (y_0 is ta*).
27. Let y_0 be $allocmems(memtype^n_m).
28. Assert: Due to validation, (y_0 is ma*).
29. Let y_0 be $allocelems(reftype^n_e, ref_e**).
30. Assert: Due to validation, (y_0 is ea*).
31. Let y_0 be $allocdatas(byte*^n_d).
32. Assert: Due to validation, (y_0 is da*).
33. Return mm.

runelem (ELEM reftype expr* elemm_u0) y
1. If (elemm_u0 is PASSIVE), then:
  a. Return [].
2. If (elemm_u0 is DECLARE), then:
  a. Return [(ELEM.DROP y)].
3. Assert: Due to validation, elemm_u0 is of the case ACTIVE.
4. Let (ACTIVE x instr*) be elemm_u0.
5. Return instr* ++ [(I32.CONST 0), (I32.CONST |expr*|), (TABLE.INIT x y), (ELEM.DROP y)].

rundata (DATA byte* datam_u0) y
1. If (datam_u0 is PASSIVE), then:
  a. Return [].
2. Assert: Due to validation, datam_u0 is of the case ACTIVE.
3. Let (ACTIVE x instr*) be datam_u0.
4. Return instr* ++ [(I32.CONST 0), (I32.CONST |byte*|), (MEMORY.INIT x y), (DATA.DROP y)].

instantiate module externval*
1. Assert: Due to validation, module is of the case MODULE.
2. Let (MODULE type* import* func* global* table* mem* elem* data* start? export*) be module.
3. Let n_D be |data*|.
4. Let n_E be |elem*|.
5. Let n_F be |func*|.
6. Let (START x)? be start?.
7. Let (GLOBAL globaltype expr_G)* be global*.
8. Let (TABLE tabletype expr_T)* be table*.
9. Let (ELEM reftype expr_E* elemmode)* be elem*.
10. Let instr_D* be $concat_($rundata(data*[j], j)^(j<n_D)).
11. Let instr_E* be $concat_($runelem(elem*[i], i)^(i<n_E)).
12. Let mm_init be { TYPE: $alloctypes(type*); FUNC: $funcsxv(externval*) ++ (|s.FUNC| + i_F)^(i_F<n_F); GLOBAL: $globalsxv(externval*); TABLE: []; MEM: []; ELEM: []; DATA: []; EXPORT: []; }.
13. Let z be { LOCAL: []; MODULE: mm_init; }.
14. Push the activation of z to the stack.
15. Let [val_G]* be $eval_expr(expr_G)*.
16. Pop the activation of z from the stack.
17. Push the activation of z to the stack.
18. Let [ref_T]* be $eval_expr(expr_T)*.
19. Pop the activation of z from the stack.
20. Push the activation of z to the stack.
21. Let [ref_E]** be $eval_expr(expr_E)**.
22. Pop the activation of z from the stack.
23. Let mm be $allocmodule(module, externval*, val_G*, ref_T*, ref_E**).
24. Let f be { LOCAL: []; MODULE: mm; }.
25. Enter the activation of f with arity 0 with label [FRAME_]:
  a. Execute the sequence (instr_E*).
  b. Execute the sequence (instr_D*).
  c. If x is defined, then:
    1) Let ?(x_0) be x.
    2) Execute (CALL x_0).
26. Return mm.

invoke fa val^n
1. Let f be { LOCAL: []; MODULE: { TYPE: []; FUNC: []; GLOBAL: []; TABLE: []; MEM: []; ELEM: []; DATA: []; EXPORT: []; }; }.
2. Assert: Due to validation, $expanddt(s.FUNC[fa].TYPE) is of the case FUNC.
3. Let (FUNC y_0) be $expanddt(s.FUNC[fa].TYPE).
4. Let (t_1^n -> t_2*) be y_0.
5. Assert: Due to validation, $funcinst()[fa].CODE is of the case FUNC.
6. Let k be |t_2*|.
7. Enter the activation of f with arity k with label [FRAME_]:
  a. Push val^n to the stack.
  b. Push (REF.FUNC_ADDR fa) to the stack.
  c. Execute (CALL_REF ?(0)).
8. Pop val^k from the stack.
9. Return val^k.

utf8 name_u0
1. If (|name_u0| is 1), then:
  a. Let [ch] be name_u0.
  b. If ((ch < 128) and the type of ch is byte), then:
    1) Let b be ch.
    2) Return [b].
  c. If ((128 ≤ ch) and ((ch < 2048) and (ch ≥ (b_2 - 128)))), then:
    1) Let ((2 ^ 6) · (b_1 - 192)) be (ch - (b_2 - 128)).
    2) Return [b_1, b_2].
  d. If ((((2048 ≤ ch) and (ch < 55296)) or ((57344 ≤ ch) and (ch < 65536))) and (ch ≥ (b_3 - 128))), then:
    1) Let (((2 ^ 12) · (b_1 - 224)) + ((2 ^ 6) · (b_2 - 128))) be (ch - (b_3 - 128)).
    2) Return [b_1, b_2, b_3].
  e. If ((65536 ≤ ch) and ((ch < 69632) and (ch ≥ (b_4 - 128)))), then:
    1) Let ((((2 ^ 18) · (b_1 - 240)) + ((2 ^ 12) · (b_2 - 128))) + ((2 ^ 6) · (b_3 - 128))) be (ch - (b_4 - 128)).
    2) Return [b_1, b_2, b_3, b_4].
2. Let ch* be name_u0.
3. Return $concat_($utf8([ch])*).

execution_of_UNREACHABLE
1. Trap.

execution_of_NOP
1. Do nothing.

execution_of_DROP
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop val from the stack.
3. Do nothing.

execution_of_SELECT t*?
1. Assert: Due to validation, a value of value type I32 is on the top of the stack.
2. Pop (I32.CONST c) from the stack.
3. Assert: Due to validation, a value is on the top of the stack.
4. Pop val_2 from the stack.
5. Assert: Due to validation, a value is on the top of the stack.
6. Pop val_1 from the stack.
7. If (c is not 0), then:
  a. Push val_1 to the stack.
8. Else:
  a. Push val_2 to the stack.

execution_of_IF bt instr_1* instr_2*
1. Assert: Due to validation, a value of value type I32 is on the top of the stack.
2. Pop (I32.CONST c) from the stack.
3. If (c is not 0), then:
  a. Execute (BLOCK bt instr_1*).
4. Else:
  a. Execute (BLOCK bt instr_2*).

execution_of_LABEL_
1. Pop all values val* from the stack.
2. Assert: Due to validation, a label is now on the top of the stack.
3. Exit current context.
4. Push val* to the stack.

execution_of_BR label_u0
1. Let L be the current label.
2. Let n be the arity of L.
3. Let instr'* be the continuation of L.
4. Pop all values admin_u1* from the stack.
5. Exit current context.
6. If ((label_u0 is 0) and (|admin_u1*| ≥ n)), then:
  a. Let val'* ++ val^n be admin_u1*.
  b. Push val^n to the stack.
  c. Execute the sequence (instr'*).
7. If (label_u0 ≥ 1), then:
  a. Let l be (label_u0 - 1).
  b. Let val* be admin_u1*.
  c. Push val* to the stack.
  d. Execute (BR l).

execution_of_BR_IF l
1. Assert: Due to validation, a value of value type I32 is on the top of the stack.
2. Pop (I32.CONST c) from the stack.
3. If (c is not 0), then:
  a. Execute (BR l).
4. Else:
  a. Do nothing.

execution_of_BR_TABLE l* l'
1. Assert: Due to validation, a value of value type I32 is on the top of the stack.
2. Pop (I32.CONST i) from the stack.
3. If (i < |l*|), then:
  a. Execute (BR l*[i]).
4. Else:
  a. Execute (BR l').

execution_of_BR_ON_NULL l
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop val from the stack.
3. If val is of the case REF.NULL, then:
  a. Execute (BR l).
4. Else:
  a. Push val to the stack.

execution_of_BR_ON_NON_NULL l
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop val from the stack.
3. If val is of the case REF.NULL, then:
  a. Do nothing.
4. Else:
  a. Push val to the stack.
  b. Execute (BR l).

execution_of_CALL_INDIRECT x y
1. Execute (TABLE.GET x).
2. Execute (REF.CAST (REF (NULL ?(())) $idx(y))).
3. Execute (CALL_REF ?(y)).

execution_of_RETURN_CALL_INDIRECT x y
1. Execute (TABLE.GET x).
2. Execute (REF.CAST (REF (NULL ?(())) $idx(y))).
3. Execute (RETURN_CALL_REF ?(y)).

execution_of_FRAME_
1. Let f be the current frame.
2. Let n be the arity of f.
3. Assert: Due to validation, there are at least n values on the top of the stack.
4. Pop val^n from the stack.
5. Assert: Due to validation, a frame is now on the top of the stack.
6. Exit current context.
7. Push val^n to the stack.

execution_of_RETURN
1. If the current context is frame, then:
  a. Let F be the current frame.
  b. Let n be the arity of F.
  c. Pop val^n from the stack.
  d. Pop all values val'* from the stack.
  e. Exit current context.
  f. Push val^n to the stack.
2. Else if the current context is label, then:
  a. Pop all values val* from the stack.
  b. Exit current context.
  c. Push val* to the stack.
  d. Execute RETURN.

execution_of_UNOP nt unop
1. Assert: Due to validation, a value of value type nt is on the top of the stack.
2. Pop (nt.CONST c_1) from the stack.
3. If (|$unop(nt, unop, c_1)| is 1), then:
  a. Let [c] be $unop(nt, unop, c_1).
  b. Push (nt.CONST c) to the stack.
4. If ($unop(nt, unop, c_1) is []), then:
  a. Trap.

execution_of_BINOP nt binop
1. Assert: Due to validation, a value of value type nt is on the top of the stack.
2. Pop (nt.CONST c_2) from the stack.
3. Assert: Due to validation, a value of value type nt is on the top of the stack.
4. Pop (nt.CONST c_1) from the stack.
5. If (|$binop(nt, binop, c_1, c_2)| is 1), then:
  a. Let [c] be $binop(nt, binop, c_1, c_2).
  b. Push (nt.CONST c) to the stack.
6. If ($binop(nt, binop, c_1, c_2) is []), then:
  a. Trap.

execution_of_TESTOP nt testop
1. Assert: Due to validation, a value of value type nt is on the top of the stack.
2. Pop (nt.CONST c_1) from the stack.
3. Let c be $testop(nt, testop, c_1).
4. Push (I32.CONST c) to the stack.

execution_of_RELOP nt relop
1. Assert: Due to validation, a value of value type nt is on the top of the stack.
2. Pop (nt.CONST c_2) from the stack.
3. Assert: Due to validation, a value of value type nt is on the top of the stack.
4. Pop (nt.CONST c_1) from the stack.
5. Let c be $relop(nt, relop, c_1, c_2).
6. Push (I32.CONST c) to the stack.

execution_of_CVTOP nt_2 cvtop nt_1 sx?
1. Assert: Due to validation, a value of value type nt_1 is on the top of the stack.
2. Pop (nt_1.CONST c_1) from the stack.
3. If (|$cvtop(nt_1, nt_2, cvtop, sx?, c_1)| is 1), then:
  a. Let [c] be $cvtop(nt_1, nt_2, cvtop, sx?, c_1).
  b. Push (nt_2.CONST c) to the stack.
4. If ($cvtop(nt_1, nt_2, cvtop, sx?, c_1) is []), then:
  a. Trap.

execution_of_REF.I31
1. Assert: Due to validation, a value of value type I32 is on the top of the stack.
2. Pop (I32.CONST i) from the stack.
3. Push (REF.I31_NUM $wrap(32, 31, i)) to the stack.

execution_of_REF.IS_NULL
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop val from the stack.
3. If val is of the case REF.NULL, then:
  a. Push (I32.CONST 1) to the stack.
4. Else:
  a. Push (I32.CONST 0) to the stack.

execution_of_REF.AS_NON_NULL
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop ref from the stack.
3. If ref is of the case REF.NULL, then:
  a. Trap.
4. Push ref to the stack.

execution_of_REF.EQ
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop ref_2 from the stack.
3. Assert: Due to validation, a value is on the top of the stack.
4. Pop ref_1 from the stack.
5. If (ref_1 is of the case REF.NULL and ref_2 is of the case REF.NULL), then:
  a. Push (I32.CONST 1) to the stack.
6. Else if (ref_1 is ref_2), then:
  a. Push (I32.CONST 1) to the stack.
7. Else:
  a. Push (I32.CONST 0) to the stack.

execution_of_I31.GET sx
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop admin_u0 from the stack.
3. If admin_u0 is of the case REF.NULL, then:
  a. Trap.
4. If admin_u0 is of the case REF.I31_NUM, then:
  a. Let (REF.I31_NUM i) be admin_u0.
  b. Push (I32.CONST $ext(31, 32, sx, i)) to the stack.

execution_of_EXTERN.CONVERT_ANY
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop admin_u0 from the stack.
3. If admin_u0 is of the case REF.NULL, then:
  a. Push (REF.NULL EXTERN) to the stack.
4. If the type of admin_u0 is addrref, then:
  a. Let addrref be admin_u0.
  b. Push (REF.EXTERN addrref) to the stack.

execution_of_ANY.CONVERT_EXTERN
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop admin_u0 from the stack.
3. If admin_u0 is of the case REF.NULL, then:
  a. Push (REF.NULL ANY) to the stack.
4. If admin_u0 is of the case REF.EXTERN, then:
  a. Let (REF.EXTERN addrref) be admin_u0.
  b. Push addrref to the stack.

execution_of_VVUNOP V128 vvunop
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop (V128.CONST c_1) from the stack.
3. Let c be $vvunop(V128, vvunop, c_1).
4. Push (V128.CONST c) to the stack.

execution_of_VVBINOP V128 vvbinop
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop (V128.CONST c_2) from the stack.
3. Assert: Due to validation, a value is on the top of the stack.
4. Pop (V128.CONST c_1) from the stack.
5. Let c be $vvbinop(V128, vvbinop, c_1, c_2).
6. Push (V128.CONST c) to the stack.

execution_of_VVTERNOP V128 vvternop
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop (V128.CONST c_3) from the stack.
3. Assert: Due to validation, a value is on the top of the stack.
4. Pop (V128.CONST c_2) from the stack.
5. Assert: Due to validation, a value is on the top of the stack.
6. Pop (V128.CONST c_1) from the stack.
7. Let c be $vvternop(V128, vvternop, c_1, c_2, c_3).
8. Push (V128.CONST c) to the stack.

execution_of_VVTESTOP V128 ANY_TRUE
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop (V128.CONST c_1) from the stack.
3. Let c be $ine($size(V128), c_1, 0).
4. Push (I32.CONST c) to the stack.

execution_of_VSWIZZLE (pnn X N)
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop (V128.CONST c_2) from the stack.
3. Assert: Due to validation, a value is on the top of the stack.
4. Pop (V128.CONST c_1) from the stack.
5. Let c* be $lanes_((pnn X N), c_1) ++ 0^(256 - N).
6. Let ci* be $lanes_((pnn X N), c_2).
7. Assert: Due to validation, (ci*[k] < |c*|)^(k<N).
8. Assert: Due to validation, (k < |ci*|)^(k<N).
9. Let c' be $invlanes_((pnn X N), c*[ci*[k]]^(k<N)).
10. Push (V128.CONST c') to the stack.

execution_of_VSHUFFLE (pnn X N) i*
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop (V128.CONST c_2) from the stack.
3. Assert: Due to validation, a value is on the top of the stack.
4. Pop (V128.CONST c_1) from the stack.
5. Assert: Due to validation, (k < |i*|)^(k<N).
6. Let c'* be $lanes_((pnn X N), c_1) ++ $lanes_((pnn X N), c_2).
7. Assert: Due to validation, (i*[k] < |c'*|)^(k<N).
8. Let c be $invlanes_((pnn X N), c'*[i*[k]]^(k<N)).
9. Push (V128.CONST c) to the stack.

execution_of_VSPLAT (lnn X N)
1. Assert: Due to validation, a value of value type $lunpack(lnn) is on the top of the stack.
2. Pop (nt_0.CONST c_1) from the stack.
3. Let c be $invlanes_((lnn X N), $packnum(lnn, c_1)^N).
4. Push (V128.CONST c) to the stack.

execution_of_VEXTRACT_LANE (lanet_u0 X N) sx_u1? i
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop (V128.CONST c_1) from the stack.
3. If (sx_u1? is not defined and the type of lanet_u0 is numtype), then:
  a. Let nt be lanet_u0.
  b. If (i < |$lanes_((nt X N), c_1)|), then:
    1) Let c_2 be $lanes_((nt X N), c_1)[i].
    2) Push (nt.CONST c_2) to the stack.
4. If the type of lanet_u0 is packtype, then:
  a. Let pt be lanet_u0.
  b. If sx_u1? is defined, then:
    1) Let ?(sx) be sx_u1?.
    2) If (i < |$lanes_((pt X N), c_1)|), then:
      a) Let c_2 be $ext($psize(pt), 32, sx, $lanes_((pt X N), c_1)[i]).
      b) Push (I32.CONST c_2) to the stack.

execution_of_VREPLACE_LANE (lnn X N) i
1. Assert: Due to validation, a value of value type $lunpack(lnn) is on the top of the stack.
2. Pop (nt_0.CONST c_2) from the stack.
3. Assert: Due to validation, a value is on the top of the stack.
4. Pop (V128.CONST c_1) from the stack.
5. Let c be $invlanes_((lnn X N), $lanes_((lnn X N), c_1) with [i] replaced by $packnum(lnn, c_2)).
6. Push (V128.CONST c) to the stack.

execution_of_VUNOP sh vunop
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop (V128.CONST c_1) from the stack.
3. Let c be $vunop(sh, vunop, c_1).
4. Push (V128.CONST c) to the stack.

execution_of_VBINOP sh vbinop
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop (V128.CONST c_2) from the stack.
3. Assert: Due to validation, a value is on the top of the stack.
4. Pop (V128.CONST c_1) from the stack.
5. If (|$vbinop(sh, vbinop, c_1, c_2)| is 1), then:
  a. Let [c] be $vbinop(sh, vbinop, c_1, c_2).
  b. Push (V128.CONST c) to the stack.
6. If ($vbinop(sh, vbinop, c_1, c_2) is []), then:
  a. Trap.

execution_of_VRELOP sh vrelop
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop (V128.CONST c_2) from the stack.
3. Assert: Due to validation, a value is on the top of the stack.
4. Pop (V128.CONST c_1) from the stack.
5. Let c be $vrelop(sh, vrelop, c_1, c_2).
6. Push (V128.CONST c) to the stack.

execution_of_VSHIFTOP (imm X N) vshiftop
1. Assert: Due to validation, a value of value type I32 is on the top of the stack.
2. Pop (I32.CONST n) from the stack.
3. Assert: Due to validation, a value is on the top of the stack.
4. Pop (V128.CONST c_1) from the stack.
5. Let c'* be $lanes_((imm X N), c_1).
6. Let c be $invlanes_((imm X N), $vishiftop((imm X N), vshiftop, c', n)*).
7. Push (V128.CONST c) to the stack.

execution_of_VTESTOP (imm X N) ALL_TRUE
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop (V128.CONST c) from the stack.
3. Let ci_1* be $lanes_((imm X N), c).
4. If (ci_1 is not 0)*, then:
  a. Push (I32.CONST 1) to the stack.
5. Else:
  a. Push (I32.CONST 0) to the stack.

execution_of_VBITMASK (imm X N)
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop (V128.CONST c) from the stack.
3. Let ci_1* be $lanes_((imm X N), c).
4. Let ci be $inverse_of_ibits(32, $ilt($lsize(imm), S, ci_1, 0)*).
5. Push (I32.CONST ci) to the stack.

execution_of_VNARROW (imm_1 X N_1) (imm_2 X N_2) sx
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop (V128.CONST c_2) from the stack.
3. Assert: Due to validation, a value is on the top of the stack.
4. Pop (V128.CONST c_1) from the stack.
5. Let ci_1* be $lanes_((imm_1 X N_1), c_1).
6. Let ci_2* be $lanes_((imm_1 X N_1), c_2).
7. Let cj_1* be $narrow($lsize(imm_1), $lsize(imm_2), sx, ci_1)*.
8. Let cj_2* be $narrow($lsize(imm_1), $lsize(imm_2), sx, ci_2)*.
9. Let c be $invlanes_((imm_2 X N_2), cj_1* ++ cj_2*).
10. Push (V128.CONST c) to the stack.

execution_of_VCVTOP (lanet_u0 X N_2) vcvtop half_u1? (lanet_u2 X N_1) sx_u3? (ZERO _u4?)
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop (V128.CONST c_1) from the stack.
3. If (half_u1? is not defined and _u4? is not defined), then:
  a. Let lnn_1 be lanet_u2.
  b. Let lnn_2 be lanet_u0.
  c. If sx_u3? is defined, then:
    1) Let ?(sx) be sx_u3?.
    2) Let c'* be $lanes_((lnn_1 X N_1), c_1).
    3) Let c be $invlanes_((lnn_2 X N_2), $vcvtop((lnn_1 X N_1), (lnn_2 X N_2), vcvtop, ?(sx), c')*).
    4) Push (V128.CONST c) to the stack.
4. If (_u4? is not defined and half_u1? is defined), then:
  a. Let ?(hf) be half_u1?.
  b. If the type of lanet_u2 is imm, then:
    1) Let imm_1 be lanet_u2.
    2) If the type of lanet_u0 is imm, then:
      a) Let imm_2 be lanet_u0.
      b) Let sx? be sx_u3?.
      c) Let ci* be $lanes_((imm_1 X N_1), c_1)[$halfop(hf, 0, N_2) : N_2].
      d) Let c be $invlanes_((imm_2 X N_2), $vcvtop((imm_1 X N_1), (imm_2 X N_2), vcvtop, sx?, ci)*).
      e) Push (V128.CONST c) to the stack.
5. If (half_u1? is not defined and ((_u4? is ?(())) and the type of lanet_u2 is inn)), then:
  a. Let inn_1 be lanet_u2.
  b. If the type of lanet_u0 is inn, then:
    1) Let inn_2 be lanet_u0.
    2) Let sx? be sx_u3?.
    3) Let ci* be $lanes_((inn_1 X N_1), c_1).
    4) Let c be $invlanes_((inn_2 X N_2), $vcvtop((inn_1 X N_1), (inn_2 X N_2), vcvtop, sx?, ci)* ++ 0^N_1).
    5) Push (V128.CONST c) to the stack.

execution_of_VEXTUNOP sh_1 sh_2 vextunop sx
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop (V128.CONST c_1) from the stack.
3. Let c be $vextunop(sh_1, sh_2, vextunop, sx, c_1).
4. Push (V128.CONST c) to the stack.

execution_of_VEXTBINOP sh_1 sh_2 vextbinop sx
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop (V128.CONST c_2) from the stack.
3. Assert: Due to validation, a value is on the top of the stack.
4. Pop (V128.CONST c_1) from the stack.
5. Let c be $vextbinop(sh_1, sh_2, vextbinop, sx, c_1, c_2).
6. Push (V128.CONST c) to the stack.

execution_of_LOCAL.TEE x
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop val from the stack.
3. Push val to the stack.
4. Push val to the stack.
5. Execute (LOCAL.SET x).

execution_of_BLOCK bt instr*
1. Let (t_1^k -> t_2^n) be $blocktype(bt).
2. Assert: Due to validation, there are at least k values on the top of the stack.
3. Pop val^k from the stack.
4. Let L be the label_n{[]}.
5. Enter L with label instr* ++ [LABEL_]:
  a. Push val^k to the stack.

execution_of_LOOP bt instr*
1. Let (t_1^k -> t_2^n) be $blocktype(bt).
2. Assert: Due to validation, there are at least k values on the top of the stack.
3. Pop val^k from the stack.
4. Let L be the label_k{[(LOOP bt instr*)]}.
5. Enter L with label instr* ++ [LABEL_]:
  a. Push val^k to the stack.

execution_of_BR_ON_CAST l rt_1 rt_2
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop ref from the stack.
3. Let rt be $ref_type_of(ref).
4. If not rt matches $inst_reftype($moduleinst(), rt_2), then:
  a. Push ref to the stack.
5. Else:
  a. Push ref to the stack.
  b. Execute (BR l).

execution_of_BR_ON_CAST_FAIL l rt_1 rt_2
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop ref from the stack.
3. Let rt be $ref_type_of(ref).
4. If rt matches $inst_reftype($moduleinst(), rt_2), then:
  a. Push ref to the stack.
5. Else:
  a. Push ref to the stack.
  b. Execute (BR l).

execution_of_CALL x
1. Assert: Due to validation, (x < |$funcaddr()|).
2. Push (REF.FUNC_ADDR $funcaddr()[x]) to the stack.
3. Execute (CALL_REF ?()).

execution_of_CALL_REF
1. YetI: TODO: It is likely that the value stack of two rules are different.

execution_of_RETURN_CALL x
1. Assert: Due to validation, (x < |$funcaddr()|).
2. Push (REF.FUNC_ADDR $funcaddr()[x]) to the stack.
3. Execute (RETURN_CALL_REF ?()).

execution_of_RETURN_CALL_REF x?
1. If the current context is label, then:
  a. Pop all values val* from the stack.
  b. Exit current context.
  c. Push val* to the stack.
  d. Execute (RETURN_CALL_REF x?).
2. Else if the current context is frame, then:
  a. Pop admin_u0 from the stack.
  b. Pop all values admin_u1* from the stack.
  c. Exit current context.
  d. If admin_u0 is of the case REF.NULL, then:
    1) Trap.
  e. If admin_u0 is of the case REF.FUNC_ADDR, then:
    1) Let (REF.FUNC_ADDR a) be admin_u0.
    2) If (a < |$funcinst()|), then:
      a) Assert: Due to validation, $expanddt($funcinst()[a].TYPE) is of the case FUNC.
      b) Let (FUNC y_0) be $expanddt($funcinst()[a].TYPE).
      c) Let (t_1^n -> t_2^m) be y_0.
      d) If (|admin_u1*| ≥ n), then:
        1. Let val'* ++ val^n be admin_u1*.
        2. Push val^n to the stack.
        3. Push (REF.FUNC_ADDR a) to the stack.
        4. Execute (CALL_REF x?).

execution_of_REF.FUNC x
1. Assert: Due to validation, (x < |$funcaddr()|).
2. Push (REF.FUNC_ADDR $funcaddr()[x]) to the stack.

execution_of_REF.TEST rt
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop ref from the stack.
3. Let rt' be $ref_type_of(ref).
4. If rt' matches $inst_reftype($moduleinst(), rt), then:
  a. Push (I32.CONST 1) to the stack.
5. Else:
  a. Push (I32.CONST 0) to the stack.

execution_of_REF.CAST rt
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop ref from the stack.
3. Let rt' be $ref_type_of(ref).
4. If not rt' matches $inst_reftype($moduleinst(), rt), then:
  a. Trap.
5. Push ref to the stack.

execution_of_STRUCT.NEW_DEFAULT x
1. Assert: Due to validation, $expanddt($type(x)) is of the case STRUCT.
2. Let (STRUCT y_0) be $expanddt($type(x)).
3. Let (mut, zt)* be y_0.
4. Assert: Due to validation, (|mut*| is |zt*|).
5. Assert: Due to validation, $default($unpack(zt)) is defined*.
6. Let ?(val)* be $default($unpack(zt))*.
7. Assert: Due to validation, (|val*| is |zt*|).
8. Push val* to the stack.
9. Execute (STRUCT.NEW x).

execution_of_STRUCT.GET sx? x i
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop admin_u0 from the stack.
3. If admin_u0 is of the case REF.NULL, then:
  a. Trap.
4. If admin_u0 is of the case REF.STRUCT_ADDR, then:
  a. Let (REF.STRUCT_ADDR a) be admin_u0.
  b. If (a < |$structinst()|), then:
    1) Let si be $structinst()[a].
    2) If (i < |si.FIELD|), then:
      a) Assert: Due to validation, $expanddt(si.TYPE) is of the case STRUCT.
      b) Let (STRUCT y_0) be $expanddt(si.TYPE).
      c) Let (mut, zt)* be y_0.
      d) If ((|mut*| is |zt*|) and (i < |zt*|)), then:
        1. Push $unpackval(zt*[i], sx?, si.FIELD[i]) to the stack.

execution_of_ARRAY.NEW x
1. Assert: Due to validation, a value of value type I32 is on the top of the stack.
2. Pop (I32.CONST n) from the stack.
3. Assert: Due to validation, a value is on the top of the stack.
4. Pop val from the stack.
5. Push val^n to the stack.
6. Execute (ARRAY.NEW_FIXED x n).

execution_of_ARRAY.NEW_DEFAULT x
1. Assert: Due to validation, a value of value type I32 is on the top of the stack.
2. Pop (I32.CONST n) from the stack.
3. Assert: Due to validation, $expanddt($type(x)) is of the case ARRAY.
4. Let (ARRAY y_0) be $expanddt($type(x)).
5. Let (mut, zt) be y_0.
6. Assert: Due to validation, $default($unpack(zt)) is defined.
7. Let ?(val) be $default($unpack(zt)).
8. Push val^n to the stack.
9. Execute (ARRAY.NEW_FIXED x n).

execution_of_ARRAY.NEW_ELEM x y
1. Assert: Due to validation, a value of value type I32 is on the top of the stack.
2. Pop (I32.CONST n) from the stack.
3. Assert: Due to validation, a value of value type I32 is on the top of the stack.
4. Pop (I32.CONST i) from the stack.
5. If ((i + n) > |$elem(y).ELEM|), then:
  a. Trap.
6. Let ref^n be $elem(y).ELEM[i : n].
7. Push ref^n to the stack.
8. Execute (ARRAY.NEW_FIXED x n).

execution_of_ARRAY.NEW_DATA x y
1. Assert: Due to validation, a value of value type I32 is on the top of the stack.
2. Pop (I32.CONST n) from the stack.
3. Assert: Due to validation, a value of value type I32 is on the top of the stack.
4. Pop (I32.CONST i) from the stack.
5. Assert: Due to validation, $expanddt($type(x)) is of the case ARRAY.
6. Let (ARRAY y_0) be $expanddt($type(x)).
7. Let (mut, zt) be y_0.
8. If ((i + ((n · $zsize(zt)) / 8)) > |$data(y).DATA|), then:
  a. Trap.
9. Let $nbytes(nt, c)^n be $inverse_of_concat_($data(y).DATA[i : ((n · $zsize(zt)) / 8)]).
10. Push (nt.CONST c)^n to the stack.
11. Execute (ARRAY.NEW_FIXED x n).
12. Let $vbytes(vt, c)^n be $inverse_of_concat_($data(y).DATA[i : ((n · $zsize(zt)) / 8)]).
13. Push (vt.CONST c)^n to the stack.
14. Execute (ARRAY.NEW_FIXED x n).

execution_of_ARRAY.GET sx? x
1. Assert: Due to validation, a value of value type I32 is on the top of the stack.
2. Pop (I32.CONST i) from the stack.
3. Assert: Due to validation, a value is on the top of the stack.
4. Pop admin_u0 from the stack.
5. If admin_u0 is of the case REF.NULL, then:
  a. Trap.
6. If admin_u0 is of the case REF.ARRAY_ADDR, then:
  a. Let (REF.ARRAY_ADDR a) be admin_u0.
  b. If ((a < |$arrayinst()|) and (i ≥ |$arrayinst()[a].FIELD|)), then:
    1) Trap.
  c. If ((i < |$arrayinst()[a].FIELD|) and (a < |$arrayinst()|)), then:
    1) Let fv be $arrayinst()[a].FIELD[i].
    2) Assert: Due to validation, $expanddt($arrayinst()[a].TYPE) is of the case ARRAY.
    3) Let (ARRAY y_0) be $expanddt($arrayinst()[a].TYPE).
    4) Let (mut, zt) be y_0.
    5) Push $unpackval(zt, sx?, fv) to the stack.

execution_of_ARRAY.LEN
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop admin_u0 from the stack.
3. If admin_u0 is of the case REF.NULL, then:
  a. Trap.
4. If admin_u0 is of the case REF.ARRAY_ADDR, then:
  a. Let (REF.ARRAY_ADDR a) be admin_u0.
  b. If (a < |$arrayinst()|), then:
    1) Let n be |$arrayinst()[a].FIELD|.
    2) Push (I32.CONST n) to the stack.

execution_of_ARRAY.FILL x
1. Assert: Due to validation, a value of value type I32 is on the top of the stack.
2. Pop (I32.CONST n) from the stack.
3. Assert: Due to validation, a value is on the top of the stack.
4. Pop val from the stack.
5. Assert: Due to validation, a value of value type I32 is on the top of the stack.
6. Pop (I32.CONST i) from the stack.
7. Assert: Due to validation, a value is on the top of the stack.
8. Pop admin_u0 from the stack.
9. If admin_u0 is of the case REF.NULL, then:
  a. Trap.
10. If admin_u0 is of the case REF.ARRAY_ADDR, then:
  a. Let (REF.ARRAY_ADDR a) be admin_u0.
  b. If ((a < |$arrayinst()|) and ((i + n) > |$arrayinst()[a].FIELD|)), then:
    1) Trap.
  c. If (n is 0), then:
    1) Do nothing.
  d. Else:
    1) Let (REF.ARRAY_ADDR a) be admin_u0.
    2) Push (REF.ARRAY_ADDR a) to the stack.
    3) Push (I32.CONST i) to the stack.
    4) Push val to the stack.
    5) Execute (ARRAY.SET x).
    6) Push (REF.ARRAY_ADDR a) to the stack.
    7) Push (I32.CONST (i + 1)) to the stack.
    8) Push val to the stack.
    9) Push (I32.CONST (n - 1)) to the stack.
    10) Execute (ARRAY.FILL x).

execution_of_ARRAY.COPY x_1 x_2
1. Assert: Due to validation, a value of value type I32 is on the top of the stack.
2. Pop (I32.CONST n) from the stack.
3. Assert: Due to validation, a value of value type I32 is on the top of the stack.
4. Pop (I32.CONST i_2) from the stack.
5. Assert: Due to validation, a value is on the top of the stack.
6. Pop admin_u1 from the stack.
7. Assert: Due to validation, a value of value type I32 is on the top of the stack.
8. Pop (I32.CONST i_1) from the stack.
9. Assert: Due to validation, a value is on the top of the stack.
10. Pop admin_u0 from the stack.
11. If (admin_u0 is of the case REF.NULL and the type of admin_u1 is ref), then:
  a. Trap.
12. If (admin_u1 is of the case REF.NULL and the type of admin_u0 is ref), then:
  a. Trap.
13. If admin_u0 is of the case REF.ARRAY_ADDR, then:
  a. Let (REF.ARRAY_ADDR a_1) be admin_u0.
  b. If admin_u1 is of the case REF.ARRAY_ADDR, then:
    1) If ((a_1 < |$arrayinst()|) and ((i_1 + n) > |$arrayinst()[a_1].FIELD|)), then:
      a) Trap.
    2) Let (REF.ARRAY_ADDR a_2) be admin_u1.
    3) If ((a_2 < |$arrayinst()|) and ((i_2 + n) > |$arrayinst()[a_2].FIELD|)), then:
      a) Trap.
  c. If (n is 0), then:
    1) If admin_u1 is of the case REF.ARRAY_ADDR, then:
      a) Do nothing.
  d. Else if (i_1 > i_2), then:
    1) Assert: Due to validation, $expanddt($type(x_2)) is of the case ARRAY.
    2) Let (ARRAY y_0) be $expanddt($type(x_2)).
    3) Let (mut, zt_2) be y_0.
    4) Let (REF.ARRAY_ADDR a_1) be admin_u0.
    5) If admin_u1 is of the case REF.ARRAY_ADDR, then:
      a) Let (REF.ARRAY_ADDR a_2) be admin_u1.
      b) Let sx? be $sxfield(zt_2).
      c) Push (REF.ARRAY_ADDR a_1) to the stack.
      d) Push (I32.CONST ((i_1 + n) - 1)) to the stack.
      e) Push (REF.ARRAY_ADDR a_2) to the stack.
      f) Push (I32.CONST ((i_2 + n) - 1)) to the stack.
      g) Execute (ARRAY.GET sx? x_2).
      h) Execute (ARRAY.SET x_1).
      i) Push (REF.ARRAY_ADDR a_1) to the stack.
      j) Push (I32.CONST i_1) to the stack.
      k) Push (REF.ARRAY_ADDR a_2) to the stack.
      l) Push (I32.CONST i_2) to the stack.
      m) Push (I32.CONST (n - 1)) to the stack.
      n) Execute (ARRAY.COPY x_1 x_2).
  e. Else:
    1) Assert: Due to validation, $expanddt($type(x_2)) is of the case ARRAY.
    2) Let (ARRAY y_0) be $expanddt($type(x_2)).
    3) Let (mut, zt_2) be y_0.
    4) Let (REF.ARRAY_ADDR a_1) be admin_u0.
    5) If admin_u1 is of the case REF.ARRAY_ADDR, then:
      a) Let (REF.ARRAY_ADDR a_2) be admin_u1.
      b) Let sx? be $sxfield(zt_2).
      c) Push (REF.ARRAY_ADDR a_1) to the stack.
      d) Push (I32.CONST i_1) to the stack.
      e) Push (REF.ARRAY_ADDR a_2) to the stack.
      f) Push (I32.CONST i_2) to the stack.
      g) Execute (ARRAY.GET sx? x_2).
      h) Execute (ARRAY.SET x_1).
      i) Push (REF.ARRAY_ADDR a_1) to the stack.
      j) Push (I32.CONST (i_1 + 1)) to the stack.
      k) Push (REF.ARRAY_ADDR a_2) to the stack.
      l) Push (I32.CONST (i_2 + 1)) to the stack.
      m) Push (I32.CONST (n - 1)) to the stack.
      n) Execute (ARRAY.COPY x_1 x_2).

execution_of_ARRAY.INIT_ELEM x y
1. Assert: Due to validation, a value of value type I32 is on the top of the stack.
2. Pop (I32.CONST n) from the stack.
3. Assert: Due to validation, a value of value type I32 is on the top of the stack.
4. Pop (I32.CONST j) from the stack.
5. Assert: Due to validation, a value of value type I32 is on the top of the stack.
6. Pop (I32.CONST i) from the stack.
7. Assert: Due to validation, a value is on the top of the stack.
8. Pop admin_u0 from the stack.
9. If admin_u0 is of the case REF.NULL, then:
  a. Trap.
10. If admin_u0 is of the case REF.ARRAY_ADDR, then:
  a. Let (REF.ARRAY_ADDR a) be admin_u0.
  b. If ((a < |$arrayinst()|) and ((i + n) > |$arrayinst()[a].FIELD|)), then:
    1) Trap.
11. If ((j + n) > |$elem(y).ELEM|), then:
  a. If admin_u0 is of the case REF.ARRAY_ADDR, then:
    1) Trap.
  b. If ((n is 0) and (j < |$elem(y).ELEM|)), then:
    1) Let ref be $elem(y).ELEM[j].
    2) If admin_u0 is of the case REF.ARRAY_ADDR, then:
      a) Let (REF.ARRAY_ADDR a) be admin_u0.
      b) Push (REF.ARRAY_ADDR a) to the stack.
      c) Push (I32.CONST i) to the stack.
      d) Push ref to the stack.
      e) Execute (ARRAY.SET x).
      f) Push (REF.ARRAY_ADDR a) to the stack.
      g) Push (I32.CONST (i + 1)) to the stack.
      h) Push (I32.CONST (j + 1)) to the stack.
      i) Push (I32.CONST (n - 1)) to the stack.
      j) Execute (ARRAY.INIT_ELEM x y).
12. Else if (n is 0), then:
  a. If admin_u0 is of the case REF.ARRAY_ADDR, then:
    1) Do nothing.
13. Else:
  a. If (j < |$elem(y).ELEM|), then:
    1) Let ref be $elem(y).ELEM[j].
    2) If admin_u0 is of the case REF.ARRAY_ADDR, then:
      a) Let (REF.ARRAY_ADDR a) be admin_u0.
      b) Push (REF.ARRAY_ADDR a) to the stack.
      c) Push (I32.CONST i) to the stack.
      d) Push ref to the stack.
      e) Execute (ARRAY.SET x).
      f) Push (REF.ARRAY_ADDR a) to the stack.
      g) Push (I32.CONST (i + 1)) to the stack.
      h) Push (I32.CONST (j + 1)) to the stack.
      i) Push (I32.CONST (n - 1)) to the stack.
      j) Execute (ARRAY.INIT_ELEM x y).

execution_of_ARRAY.INIT_DATA x y
1. Assert: Due to validation, a value of value type I32 is on the top of the stack.
2. Pop (I32.CONST n) from the stack.
3. Assert: Due to validation, a value of value type I32 is on the top of the stack.
4. Pop (I32.CONST j) from the stack.
5. Assert: Due to validation, a value of value type I32 is on the top of the stack.
6. Pop (I32.CONST i) from the stack.
7. Assert: Due to validation, a value is on the top of the stack.
8. Pop admin_u0 from the stack.
9. If admin_u0 is of the case REF.NULL, then:
  a. Trap.
10. If admin_u0 is of the case REF.ARRAY_ADDR, then:
  a. Let (REF.ARRAY_ADDR a) be admin_u0.
  b. If ((a < |$arrayinst()|) and ((i + n) > |$arrayinst()[a].FIELD|)), then:
    1) Trap.
11. If $expanddt($type(x)) is not of the case ARRAY, then:
  a. If ((n is 0) and admin_u0 is of the case REF.ARRAY_ADDR), then:
    1) Do nothing.
12. Else:
  a. Let (ARRAY y_0) be $expanddt($type(x)).
  b. Let (mut, zt) be y_0.
  c. If admin_u0 is of the case REF.ARRAY_ADDR, then:
    1) If ((j + ((n · $zsize(zt)) / 8)) > |$data(y).DATA|), then:
      a) Trap.
    2) If (n is 0), then:
      a) Do nothing.
    3) Else:
      a) Let (ARRAY y_0) be $expanddt($type(x)).
      b) Let (mut, zt) be y_0.
      c) Let (REF.ARRAY_ADDR a) be admin_u0.
      d) Let nt be $nunpack(zt).
      e) Let c be $inverse_of_nbytes(nt, $data(y).DATA[j : ($zsize(zt) / 8)]).
      f) Push (REF.ARRAY_ADDR a) to the stack.
      g) Push (I32.CONST i) to the stack.
      h) Push (nt.CONST c) to the stack.
      i) Execute (ARRAY.SET x).
      j) Push (REF.ARRAY_ADDR a) to the stack.
      k) Push (I32.CONST (i + 1)) to the stack.
      l) Push (I32.CONST (j + ($zsize(zt) / 8))) to the stack.
      m) Push (I32.CONST (n - 1)) to the stack.
      n) Execute (ARRAY.INIT_DATA x y).

execution_of_LOCAL.GET x
1. Assert: Due to validation, $local(x) is defined.
2. Let ?(val) be $local(x).
3. Push val to the stack.

execution_of_GLOBAL.GET x
1. Push $global(x).VALUE to the stack.

execution_of_TABLE.GET x
1. Assert: Due to validation, a value of value type I32 is on the top of the stack.
2. Pop (I32.CONST i) from the stack.
3. If (i ≥ |$table(x).ELEM|), then:
  a. Trap.
4. Push $table(x).ELEM[i] to the stack.

execution_of_TABLE.SIZE x
1. Let n be |$table(x).ELEM|.
2. Push (I32.CONST n) to the stack.

execution_of_TABLE.FILL x
1. Assert: Due to validation, a value of value type I32 is on the top of the stack.
2. Pop (I32.CONST n) from the stack.
3. Assert: Due to validation, a value is on the top of the stack.
4. Pop val from the stack.
5. Assert: Due to validation, a value of value type I32 is on the top of the stack.
6. Pop (I32.CONST i) from the stack.
7. If ((i + n) > |$table(x).ELEM|), then:
  a. Trap.
8. If (n is 0), then:
  a. Do nothing.
9. Else:
  a. Push (I32.CONST i) to the stack.
  b. Push val to the stack.
  c. Execute (TABLE.SET x).
  d. Push (I32.CONST (i + 1)) to the stack.
  e. Push val to the stack.
  f. Push (I32.CONST (n - 1)) to the stack.
  g. Execute (TABLE.FILL x).

execution_of_TABLE.COPY x y
1. Assert: Due to validation, a value of value type I32 is on the top of the stack.
2. Pop (I32.CONST n) from the stack.
3. Assert: Due to validation, a value of value type I32 is on the top of the stack.
4. Pop (I32.CONST i) from the stack.
5. Assert: Due to validation, a value of value type I32 is on the top of the stack.
6. Pop (I32.CONST j) from the stack.
7. If ((i + n) > |$table(y).ELEM|), then:
  a. Trap.
8. If ((j + n) > |$table(x).ELEM|), then:
  a. Trap.
9. If (n is 0), then:
  a. Do nothing.
10. Else:
  a. If (j ≤ i), then:
    1) Push (I32.CONST j) to the stack.
    2) Push (I32.CONST i) to the stack.
    3) Execute (TABLE.GET y).
    4) Execute (TABLE.SET x).
    5) Push (I32.CONST (j + 1)) to the stack.
    6) Push (I32.CONST (i + 1)) to the stack.
  b. Else:
    1) Push (I32.CONST ((j + n) - 1)) to the stack.
    2) Push (I32.CONST ((i + n) - 1)) to the stack.
    3) Execute (TABLE.GET y).
    4) Execute (TABLE.SET x).
    5) Push (I32.CONST j) to the stack.
    6) Push (I32.CONST i) to the stack.
  c. Push (I32.CONST (n - 1)) to the stack.
  d. Execute (TABLE.COPY x y).

execution_of_TABLE.INIT x y
1. Assert: Due to validation, a value of value type I32 is on the top of the stack.
2. Pop (I32.CONST n) from the stack.
3. Assert: Due to validation, a value of value type I32 is on the top of the stack.
4. Pop (I32.CONST i) from the stack.
5. Assert: Due to validation, a value of value type I32 is on the top of the stack.
6. Pop (I32.CONST j) from the stack.
7. If ((i + n) > |$elem(y).ELEM|), then:
  a. Trap.
8. If ((j + n) > |$table(x).ELEM|), then:
  a. Trap.
9. If (n is 0), then:
  a. Do nothing.
10. Else if (i < |$elem(y).ELEM|), then:
  a. Push (I32.CONST j) to the stack.
  b. Push $elem(y).ELEM[i] to the stack.
  c. Execute (TABLE.SET x).
  d. Push (I32.CONST (j + 1)) to the stack.
  e. Push (I32.CONST (i + 1)) to the stack.
  f. Push (I32.CONST (n - 1)) to the stack.
  g. Execute (TABLE.INIT x y).

execution_of_LOAD numty_u0 n_sx_u1? x mo
1. Assert: Due to validation, a value of value type I32 is on the top of the stack.
2. Pop (I32.CONST i) from the stack.
3. If n_sx_u1? is not defined, then:
  a. Let nt be numty_u0.
  b. If (((i + mo.OFFSET) + ($size(nt) / 8)) > |$mem(x).DATA|), then:
    1) Trap.
  c. Let c be $inverse_of_nbytes(nt, $mem(x).DATA[(i + mo.OFFSET) : ($size(nt) / 8)]).
  d. Push (nt.CONST c) to the stack.
4. If the type of numty_u0 is inn, then:
  a. If n_sx_u1? is defined, then:
    1) Let ?(y_0) be n_sx_u1?.
    2) Let (n, sx) be y_0.
    3) If (((i + mo.OFFSET) + (n / 8)) > |$mem(x).DATA|), then:
      a) Trap.
  b. Let inn be numty_u0.
  c. If n_sx_u1? is defined, then:
    1) Let ?(y_0) be n_sx_u1?.
    2) Let (n, sx) be y_0.
    3) Let c be $inverse_of_ibytes(n, $mem(x).DATA[(i + mo.OFFSET) : (n / 8)]).
    4) Push (inn.CONST $ext(n, $size(inn), sx, c)) to the stack.

execution_of_VLOAD vload_u0? x mo
1. Assert: Due to validation, a value of value type I32 is on the top of the stack.
2. Pop (I32.CONST i) from the stack.
3. If ((((i + mo.OFFSET) + ($size(V128) / 8)) > |$mem(x).DATA|) and vload_u0? is not defined), then:
  a. Trap.
4. If vload_u0? is not defined, then:
  a. Let c be $inverse_of_vbytes(V128, $mem(x).DATA[(i + mo.OFFSET) : ($size(V128) / 8)]).
  b. Push (V128.CONST c) to the stack.
5. Else:
  a. Let ?(y_0) be vload_u0?.
  b. If y_0 is of the case SHAPE, then:
    1) Let (SHAPE M N sx) be y_0.
    2) If (((i + mo.OFFSET) + ((M · N) / 8)) > |$mem(x).DATA|), then:
      a) Trap.
    3) If the type of $inverse_of_size((M · 2)) is inn, then:
      a) Let inn be $inverse_of_size((M · 2)).
      b) Let j^N be $inverse_of_ibytes(M, $mem(x).DATA[((i + mo.OFFSET) + ((k · M) / 8)) : (M / 8)])^(k<N).
      c) Let c be $invlanes_((inn X N), $ext(M, $size(inn), sx, j)^N).
      d) Push (V128.CONST c) to the stack.
  c. If y_0 is of the case SPLAT, then:
    1) Let (SPLAT N) be y_0.
    2) If (((i + mo.OFFSET) + (N / 8)) > |$mem(x).DATA|), then:
      a) Trap.
    3) Let M be (128 / N).
    4) If the type of $inverse_of_lsize(N) is imm, then:
      a) Let imm be $inverse_of_lsize(N).
      b) Let j be $inverse_of_ibytes(N, $mem(x).DATA[(i + mo.OFFSET) : (N / 8)]).
      c) Let c be $invlanes_((imm X M), j^M).
      d) Push (V128.CONST c) to the stack.
  d. If y_0 is of the case ZERO, then:
    1) Let (ZERO N) be y_0.
    2) If (((i + mo.OFFSET) + (N / 8)) > |$mem(x).DATA|), then:
      a) Trap.
    3) Let j be $inverse_of_ibytes(N, $mem(x).DATA[(i + mo.OFFSET) : (N / 8)]).
    4) Let c be $ext(N, 128, U, j).
    5) Push (V128.CONST c) to the stack.

execution_of_VLOAD_LANE N x mo j
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop (V128.CONST c_1) from the stack.
3. Assert: Due to validation, a value of value type I32 is on the top of the stack.
4. Pop (I32.CONST i) from the stack.
5. If (((i + mo.OFFSET) + (N / 8)) > |$mem(x).DATA|), then:
  a. Trap.
6. Let M be ($size(V128) / N).
7. If the type of $inverse_of_lsize(N) is imm, then:
  a. Let imm be $inverse_of_lsize(N).
  b. Let k be $inverse_of_ibytes(N, $mem(x).DATA[(i + mo.OFFSET) : (N / 8)]).
  c. Let c be $invlanes_((imm X M), $lanes_((imm X M), c_1) with [j] replaced by k).
  d. Push (V128.CONST c) to the stack.

execution_of_MEMORY.SIZE x
1. Let ((n · 64) · $Ki()) be |$mem(x).DATA|.
2. Push (I32.CONST n) to the stack.

execution_of_MEMORY.FILL x
1. Assert: Due to validation, a value of value type I32 is on the top of the stack.
2. Pop (I32.CONST n) from the stack.
3. Assert: Due to validation, a value is on the top of the stack.
4. Pop val from the stack.
5. Assert: Due to validation, a value of value type I32 is on the top of the stack.
6. Pop (I32.CONST i) from the stack.
7. If ((i + n) > |$mem(x).DATA|), then:
  a. Trap.
8. If (n is 0), then:
  a. Do nothing.
9. Else:
  a. Push (I32.CONST i) to the stack.
  b. Push val to the stack.
  c. Execute (STORE I32 ?(8) x $memop0()).
  d. Push (I32.CONST (i + 1)) to the stack.
  e. Push val to the stack.
  f. Push (I32.CONST (n - 1)) to the stack.
  g. Execute (MEMORY.FILL x).

execution_of_MEMORY.COPY x_1 x_2
1. Assert: Due to validation, a value of value type I32 is on the top of the stack.
2. Pop (I32.CONST n) from the stack.
3. Assert: Due to validation, a value of value type I32 is on the top of the stack.
4. Pop (I32.CONST i_2) from the stack.
5. Assert: Due to validation, a value of value type I32 is on the top of the stack.
6. Pop (I32.CONST i_1) from the stack.
7. If ((i_1 + n) > |$mem(x_1).DATA|), then:
  a. Trap.
8. If ((i_2 + n) > |$mem(x_2).DATA|), then:
  a. Trap.
9. If (n is 0), then:
  a. Do nothing.
10. Else:
  a. If (i_1 ≤ i_2), then:
    1) Push (I32.CONST i_1) to the stack.
    2) Push (I32.CONST i_2) to the stack.
    3) Execute (LOAD I32 ?((8, U)) x_2 $memop0()).
    4) Execute (STORE I32 ?(8) x_1 $memop0()).
    5) Push (I32.CONST (i_1 + 1)) to the stack.
    6) Push (I32.CONST (i_2 + 1)) to the stack.
  b. Else:
    1) Push (I32.CONST ((i_1 + n) - 1)) to the stack.
    2) Push (I32.CONST ((i_2 + n) - 1)) to the stack.
    3) Execute (LOAD I32 ?((8, U)) x_2 $memop0()).
    4) Execute (STORE I32 ?(8) x_1 $memop0()).
    5) Push (I32.CONST i_1) to the stack.
    6) Push (I32.CONST i_2) to the stack.
  c. Push (I32.CONST (n - 1)) to the stack.
  d. Execute (MEMORY.COPY x_1 x_2).

execution_of_MEMORY.INIT x y
1. Assert: Due to validation, a value of value type I32 is on the top of the stack.
2. Pop (I32.CONST n) from the stack.
3. Assert: Due to validation, a value of value type I32 is on the top of the stack.
4. Pop (I32.CONST i) from the stack.
5. Assert: Due to validation, a value of value type I32 is on the top of the stack.
6. Pop (I32.CONST j) from the stack.
7. If ((i + n) > |$data(y).DATA|), then:
  a. Trap.
8. If ((j + n) > |$mem(x).DATA|), then:
  a. Trap.
9. If (n is 0), then:
  a. Do nothing.
10. Else if (i < |$data(y).DATA|), then:
  a. Push (I32.CONST j) to the stack.
  b. Push (I32.CONST $data(y).DATA[i]) to the stack.
  c. Execute (STORE I32 ?(8) x $memop0()).
  d. Push (I32.CONST (j + 1)) to the stack.
  e. Push (I32.CONST (i + 1)) to the stack.
  f. Push (I32.CONST (n - 1)) to the stack.
  g. Execute (MEMORY.INIT x y).

execution_of_STRUCT.NEW x
1. Assert: Due to validation, $expanddt($type(x)) is of the case STRUCT.
2. Let (STRUCT y_0) be $expanddt($type(x)).
3. Let (mut, zt)^n be y_0.
4. Assert: Due to validation, there are at least n values on the top of the stack.
5. Pop val^n from the stack.
6. Let si be { TYPE: $type(x); FIELD: $packval(zt, val)^n; }.
7. Push (REF.STRUCT_ADDR |$structinst()|) to the stack.
8. Perform $ext_structinst([si]).

execution_of_STRUCT.SET x i
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop val from the stack.
3. Assert: Due to validation, a value is on the top of the stack.
4. Pop admin_u0 from the stack.
5. If admin_u0 is of the case REF.NULL, then:
  a. Trap.
6. If admin_u0 is of the case REF.STRUCT_ADDR, then:
  a. Let (REF.STRUCT_ADDR a) be admin_u0.
  b. If (a < |$structinst()|), then:
    1) Assert: Due to validation, $expanddt($structinst()[a].TYPE) is of the case STRUCT.
    2) Let (STRUCT y_0) be $expanddt($structinst()[a].TYPE).
    3) Let (mut, zt)* be y_0.
    4) If ((|mut*| is |zt*|) and (i < |zt*|)), then:
      a) Let fv be $packval(zt*[i], val).
      b) Perform $with_struct(a, i, fv).

execution_of_ARRAY.NEW_FIXED x n
1. Assert: Due to validation, there are at least n values on the top of the stack.
2. Pop val^n from the stack.
3. Assert: Due to validation, $expanddt($type(x)) is of the case ARRAY.
4. Let (ARRAY y_0) be $expanddt($type(x)).
5. Let (mut, zt) be y_0.
6. Let ai be { TYPE: $type(x); FIELD: $packval(zt, val)^n; }.
7. Push (REF.ARRAY_ADDR |$arrayinst()|) to the stack.
8. Perform $ext_arrayinst([ai]).

execution_of_ARRAY.SET x
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop val from the stack.
3. Assert: Due to validation, a value of value type I32 is on the top of the stack.
4. Pop (I32.CONST i) from the stack.
5. Assert: Due to validation, a value is on the top of the stack.
6. Pop admin_u0 from the stack.
7. If admin_u0 is of the case REF.NULL, then:
  a. Trap.
8. If admin_u0 is of the case REF.ARRAY_ADDR, then:
  a. Let (REF.ARRAY_ADDR a) be admin_u0.
  b. If (a < |$arrayinst()|), then:
    1) If (i ≥ |$arrayinst()[a].FIELD|), then:
      a) Trap.
    2) Assert: Due to validation, $expanddt($arrayinst()[a].TYPE) is of the case ARRAY.
    3) Let (ARRAY y_0) be $expanddt($arrayinst()[a].TYPE).
    4) Let (mut, zt) be y_0.
    5) Let fv be $packval(zt, val).
    6) Perform $with_array(a, i, fv).

execution_of_LOCAL.SET x
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop val from the stack.
3. Perform $with_local(x, val).

execution_of_GLOBAL.SET x
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop val from the stack.
3. Perform $with_global(x, val).

execution_of_TABLE.SET x
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop ref from the stack.
3. Assert: Due to validation, a value of value type I32 is on the top of the stack.
4. Pop (I32.CONST i) from the stack.
5. If (i ≥ |$table(x).ELEM|), then:
  a. Trap.
6. Perform $with_table(x, i, ref).

execution_of_TABLE.GROW x
1. Assert: Due to validation, a value of value type I32 is on the top of the stack.
2. Pop (I32.CONST n) from the stack.
3. Assert: Due to validation, a value is on the top of the stack.
4. Pop ref from the stack.
5. Either:
  a. Let ti be $growtable($table(x), n, ref).
  b. Push (I32.CONST |$table(x).ELEM|) to the stack.
  c. Perform $with_tableinst(x, ti).
6. Or:
  a. Push (I32.CONST $invsigned(32, (- 1))) to the stack.

execution_of_ELEM.DROP x
1. Perform $with_elem(x, []).

execution_of_STORE nt n_u1? x mo
1. Assert: Due to validation, a value of value type numty_u0 is on the top of the stack.
2. Pop (numty_u0.CONST c) from the stack.
3. Assert: Due to validation, a value of value type I32 is on the top of the stack.
4. Pop (I32.CONST i) from the stack.
5. If (numty_u0 is nt), then:
  a. If ((((i + mo.OFFSET) + ($size(nt) / 8)) > |$mem(x).DATA|) and n_u1? is not defined), then:
    1) Trap.
  b. If n_u1? is not defined, then:
    1) Let b* be $nbytes(nt, c).
    2) Perform $with_mem(x, (i + mo.OFFSET), ($size(nt) / 8), b*).
6. If the type of numty_u0 is inn, then:
  a. If n_u1? is defined, then:
    1) Let ?(n) be n_u1?.
    2) If (((i + mo.OFFSET) + (n / 8)) > |$mem(x).DATA|), then:
      a) Trap.
  b. Let inn be numty_u0.
  c. If n_u1? is defined, then:
    1) Let ?(n) be n_u1?.
    2) Let b* be $ibytes(n, $wrap($size(inn), n, c)).
    3) Perform $with_mem(x, (i + mo.OFFSET), (n / 8), b*).

execution_of_VSTORE x mo
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop (V128.CONST c) from the stack.
3. Assert: Due to validation, a value of value type I32 is on the top of the stack.
4. Pop (I32.CONST i) from the stack.
5. If (((i + mo.OFFSET) + ($size(V128) / 8)) > |$mem(x).DATA|), then:
  a. Trap.
6. Let b* be $vbytes(V128, c).
7. Perform $with_mem(x, (i + mo.OFFSET), ($size(V128) / 8), b*).

execution_of_VSTORE_LANE N x mo j
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop (V128.CONST c) from the stack.
3. Assert: Due to validation, a value of value type I32 is on the top of the stack.
4. Pop (I32.CONST i) from the stack.
5. If (((i + mo.OFFSET) + N) > |$mem(x).DATA|), then:
  a. Trap.
6. Let M be (128 / N).
7. If the type of $inverse_of_lsize(N) is imm, then:
  a. Let imm be $inverse_of_lsize(N).
  b. If (j < |$lanes_((imm X M), c)|), then:
    1) Let b* be $ibytes(N, $lanes_((imm X M), c)[j]).
    2) Perform $with_mem(x, (i + mo.OFFSET), (N / 8), b*).

execution_of_MEMORY.GROW x
1. Assert: Due to validation, a value of value type I32 is on the top of the stack.
2. Pop (I32.CONST n) from the stack.
3. Either:
  a. Let mi be $growmemory($mem(x), n).
  b. Push (I32.CONST (|$mem(x).DATA| / (64 · $Ki()))) to the stack.
  c. Perform $with_meminst(x, mi).
4. Or:
  a. Push (I32.CONST $invsigned(32, (- 1))) to the stack.

execution_of_DATA.DROP x
1. Perform $with_data(x, []).

eval_expr instr*
1. Execute the sequence (instr*).
2. Pop val from the stack.
3. Return [val].

execution_of_CALL_REF x
1. Assert: Due to validation, a value is on the top of the stack.
2. Pop ref from the stack.
3. If ref is of the case REF.NULL, then:
  a. Trap.
4. Assert: Due to validation, ref is of the case REF.FUNC_ADDR.
5. Let (REF.FUNC_ADDR a) be ref.
6. If (a < |$funcinst()|), then:
  a. Let fi be $funcinst()[a].
  b. Assert: Due to validation, fi.CODE is of the case FUNC.
  c. Let (FUNC y_0 y_1 instr*) be fi.CODE.
  d. Let (LOCAL t)* be y_1.
  e. Assert: Due to validation, $expanddt(fi.TYPE) is of the case FUNC.
  f. Let (FUNC y_0) be $expanddt(fi.TYPE).
  g. Let (t_1^n -> t_2^m) be y_0.
  h. Assert: Due to validation, there are at least n values on the top of the stack.
  i. Pop val^n from the stack.
  j. Let f be { LOCAL: ?(val)^n ++ $default(t)*; MODULE: fi.MODULE; }.
  k. Let F be the activation of f with arity m.
  l. Enter F with label [FRAME_]:
    1) Let L be the label_m{[]}.
    2) Enter L with label instr* ++ [LABEL_]:

group_bytes_by n byte*
1. Let n' be |byte*|.
2. If (n' ≥ n), then:
  a. Return [byte*[0 : n]] ++ $group_bytes_by(n, byte*[n : (n' - n)]).
3. Return [].

execution_of_ARRAY.NEW_DATA x y
1. Assert: Due to validation, a value of value type I32 is on the top of the stack.
2. Pop (I32.CONST n) from the stack.
3. Assert: Due to validation, a value of value type I32 is on the top of the stack.
4. Pop (I32.CONST i) from the stack.
5. If $expanddt($type(x)) is of the case ARRAY, then:
  a. Let (ARRAY y_0) be $expanddt($type(x)).
  b. Let (mut, zt) be y_0.
  c. If ((i + ((n · $storagesize(zt)) / 8)) > |$data(y).DATA|), then:
    1) Trap.
  d. Let nt be $unpacknumtype(zt).
  e. Let b* be $data(y).DATA[i : ((n · $storagesize(zt)) / 8)].
  f. Let gb* be $group_bytes_by(($storagesize(zt) / 8), b*).
  g. Let c^n be $inverse_of_ibytes($storagesize(zt), gb)*.
  h. Push (nt.CONST c)^n to the stack.
  i. Execute (ARRAY.NEW_FIXED x n).
== Complete.
```
