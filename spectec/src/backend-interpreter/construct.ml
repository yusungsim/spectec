open Reference_interpreter
open Ast
open Types
open Value
open Al.Ast
open Source
open Util.Record

(* Constant *)

let default_table_max = 4294967295L
let default_memory_max = 65536L
let version = ref 3

(* Constructor Shorthands *)

let _nid_count = ref 0
let gen_nid () =
  let nid = !_nid_count in
  _nid_count := nid + 1;
  nid

let mk_instr it = Util.Source.($$) it (Util.Source.no_region, gen_nid())

let ifI (c, il1, il2) = IfI (c, il1, il2) |> mk_instr
let eitherI (il1, il2) = EitherI (il1, il2) |> mk_instr
let enterI (e1, e2, il) = EnterI (e1, e2, il) |> mk_instr
let assertI c = AssertI c |> mk_instr
let pushI e = PushI e |> mk_instr
let popI e = PopI e |> mk_instr
let popallI e = PopAllI e |> mk_instr
let letI (e1, e2) = LetI (e1, e2) |> mk_instr
let trapI = TrapI |> mk_instr
let nopI = NopI |> mk_instr
let returnI e_opt = ReturnI e_opt |> mk_instr
let executeI e = ExecuteI e |> mk_instr
let executeseqI e = ExecuteSeqI e |> mk_instr
let performI (id, el) = PerformI (id, el) |> mk_instr
let exitI = ExitI |> mk_instr
let replaceI (e1, p, e2) = ReplaceI (e1, p, e2) |> mk_instr
let appendI (e1, e2) = AppendI (e1, e2) |> mk_instr
let otherwiseI il = OtherwiseI il |> mk_instr
let yetI s = YetI s |> mk_instr

let mk_expr it = Util.Source.($) it Util.Source.no_region

let varE id = VarE id |> mk_expr
let numE i = NumE i |> mk_expr
let unE (unop, e) = UnE (unop, e) |> mk_expr
let binE (binop, e1, e2) = BinE (binop, e1, e2) |> mk_expr
let accE (e, p) = AccE (e, p) |> mk_expr
let updE (e1, pl, e2) = UpdE (e1, pl, e2) |> mk_expr
let extE (e1, pl, e2, dir) = ExtE (e1, pl, e2, dir) |> mk_expr
let strE r = StrE r |> mk_expr
let catE (e1, e2) = CatE (e1, e2) |> mk_expr
let lenE e = LenE e |> mk_expr
let tupE el = TupE el |> mk_expr
let caseE (kwd, el) = CaseE (kwd, el) |> mk_expr
let callE (id, el) = CallE (id, el) |> mk_expr
let iterE (e, idl, it) = IterE (e, idl, it) |> mk_expr
let optE e_opt = OptE e_opt |> mk_expr
let listE el = ListE el |> mk_expr
let arrowE (e1, e2) = ArrowE (e1, e2) |> mk_expr
let arityE e = ArityE e |> mk_expr
let frameE (e_opt, e) = FrameE (e_opt, e) |> mk_expr
let labelE (e1, e2) = LabelE (e1, e2) |> mk_expr
let getCurFrameE = GetCurFrameE |> mk_expr
let getCurLabelE = GetCurLabelE |> mk_expr
let getCurContextE = GetCurContextE |> mk_expr
let contE e = ContE e |> mk_expr
let subE (id, ty) = SubE (id, ty) |> mk_expr
let yetE s = YetE s |> mk_expr

let mk_path it = Util.Source.($) it Util.Source.no_region

let idxP e = IdxP e |> mk_path
let sliceP (e1, e2) = SliceP (e1, e2) |> mk_path
let dotP kwd = DotP kwd |> mk_path

let mk_cond it = Util.Source.($) it Util.Source.no_region

let iterC (cond, ids, iter) = IterC (cond, ids, iter) |> mk_cond
let unC (unop, c) = UnC (unop, c) |> mk_cond
let binC (binop, c1, c2) = BinC (binop, c1, c2) |> mk_cond
let cmpC (cmpop, e1, e2) = CmpC (cmpop, e1, e2) |> mk_cond
let isCaseOfC (e, kwd) = IsCaseOfC (e, kwd) |> mk_cond
let isValidC e = IsValidC e |> mk_cond
let contextKindC (kwd, e) = ContextKindC (kwd, e) |> mk_cond
let isDefinedC e = IsDefinedC e |> mk_cond
let matchC (e1, e2) = MatchC (e1, e2) |> mk_cond
let hasTypeC (e, ty) = HasTypeC (e, ty) |> mk_cond
let topLabelC = TopLabelC |> mk_cond
let topFrameC = TopFrameC |> mk_cond
let topValueC e_opt = TopValueC e_opt |> mk_cond
let topValuesC e = TopValuesC e |> mk_cond
let yetC s = YetC s |> mk_cond

let singleton x = CaseV (String.uppercase_ascii x, [])
let listV l = ListV (ref (Array.of_list l))
let id str = VarE str 
let zero = NumV 0L

let get_name = function
  | RuleA ((name, _), _, _) -> name
  | FuncA (name, _, _) -> name

let get_param = function
  | RuleA (_, params, _) -> params
  | FuncA (_, params, _) -> params

let get_body = function
  | RuleA (_, _, body) -> body
  | FuncA (_, _, body) -> body


(* Failure *)

let fail ty v =
  Al.Print.string_of_value v
  |> Printf.sprintf "Invalid %s: %s" ty
  |> failwith

let fail_list ty l = listV l |> fail ty


(* Construct *)

(* Construct data structure *)

let al_of_list f l = List.map f l |> listV
let al_of_seq f s = List.of_seq s |> al_of_list f
let al_of_opt f opt = OptV (Option.map f opt)


(* Construct minor *)

let al_of_int64 i64 = NumV i64
let al_of_int i = Int64.of_int i |> al_of_int64
let al_of_int32 i32 =
  (* NOTE: int32 is considered to be unsigned *)
  Int64.of_int32 i32 |> Int64.logand 0x0000_0000_ffff_ffffL |> al_of_int64
let al_of_float32 f32 = F32.to_bits f32 |> al_of_int32
let al_of_float64 f64 = F64.to_bits f64 |> al_of_int64
let al_of_idx idx = al_of_int32 idx.it
let al_of_byte byte = Char.code byte |> al_of_int
let al_of_bytes bytes_ = String.to_seq bytes_ |> al_of_seq al_of_byte
let al_of_name name = TextV (Utf8.encode name)
let al_with_version vs f a = if (List.mem !version vs) then [ f a ] else []
let al_of_memidx () = al_with_version [ 3 ] (fun v -> v) zero

(* Helper *)
let arg_of_case case i = function
| CaseV (case', args) when case = case' -> List.nth args i
| _ -> failwith "invalid arg_of_case"
let arg_of_tup i = function
| TupV args -> List.nth args i
| _ -> failwith "invalid arg_of_tup"
let case_v case v = CaseV (case, [ v ])
let al_to_list = function
| ListV a -> Array.to_list !a
| _ -> failwith "invalid al_to_list"

(* Construct type *)

let al_of_null = function
  | NoNull -> CaseV ("NULL", [ OptV None ])
  | Null -> CaseV ("NULL", [ OptV (Some (TupV [])) ])

let al_of_final = function
  | NoFinal -> OptV None
  | Final -> OptV (Some (singleton "FINAL"))

let al_of_mut = function
  | Cons -> OptV None
  | Var -> OptV (Some (singleton "MUT"))

let rec al_of_storage_type = function
  | ValStorageT vt -> al_of_val_type vt
  | PackStorageT _ as st -> string_of_storage_type st |> singleton

and al_of_field_type = function
  | FieldT (mut, st) -> TupV [ al_of_mut mut; al_of_storage_type st ]

and al_of_result_type rt = al_of_list al_of_val_type rt

and al_of_str_type = function
  | DefStructT (StructT ftl) -> CaseV ("STRUCT", [ al_of_list al_of_field_type ftl ])
  | DefArrayT (ArrayT ft) -> CaseV ("ARRAY", [ al_of_field_type ft ])
  | DefFuncT (FuncT (rt1, rt2)) ->
    CaseV ("FUNC", [ ArrowV (al_of_result_type rt1, al_of_result_type rt2) ])

and al_of_sub_type = function
  | SubT (fin, htl, st) ->
    CaseV ("SUBD", [ al_of_final fin; al_of_list al_of_heap_type htl; al_of_str_type st ])

and al_of_rec_type = function
  | RecT stl -> CaseV ("REC", [ al_of_list al_of_sub_type stl ])

and al_of_def_type = function
  | DefT (rt, i) -> CaseV ("DEF", [al_of_rec_type rt; al_of_int32 i])

and al_of_heap_type = function
  | VarHT (StatX i) -> CaseV ("_IDX", [ al_of_int32 i ])
  | VarHT (RecX i) -> CaseV ("REC", [ al_of_int32 i ])
  | DefHT dt -> al_of_def_type dt
  | BotHT -> singleton "BOT"
  | ht -> string_of_heap_type ht |> singleton

and al_of_ref_type (null, ht) =
  if !version = 3 then
    CaseV ("REF", [ al_of_null null; al_of_heap_type ht ])
  else
    match al_of_heap_type ht with
    | CaseV ("FUNC", []) -> singleton "FUNC" (* TODO: "FUNCREF" *)
    | CaseV ("EXTERN", []) -> singleton "EXTERN" (* TODO: "EXTERNREF" *)
    | _ -> failwith "Not supported reftype for wasm <= 2.0"

and al_of_num_type nt = string_of_num_type nt |> singleton

and al_of_vec_type vt = string_of_vec_type vt |> singleton

and al_of_val_type = function
  | RefT rt -> al_of_ref_type rt
  | NumT nt -> al_of_num_type nt
  | VecT vt -> al_of_vec_type vt
  | BotT -> singleton "BOT"

let al_of_blocktype = function
  | VarBlockType idx -> CaseV ("_IDX", [ al_of_idx idx ])
  | ValBlockType vt_opt ->
    if !version = 1 then
      al_of_opt al_of_val_type vt_opt
    else
      CaseV ("_RESULT", [ al_of_opt al_of_val_type vt_opt ])

let al_of_limits default limits =
  let max =
    match limits.max with
    | Some v -> al_of_int32 v
    | None -> al_of_int64 default
  in

  TupV [ al_of_int32 limits.min; max ]

let al_of_global_type = function
  | GlobalT (mut, vt) -> TupV [ al_of_mut mut; al_of_val_type vt ]

let al_of_table_type = function
  | TableT (limits, rt) -> TupV [ al_of_limits default_table_max limits; al_of_ref_type rt ]

let al_of_memory_type = function
  | MemoryT limits -> CaseV ("I8", [ al_of_limits default_memory_max limits ])

(* Construct value *)

let al_of_num = function
  | I32 i32 -> CaseV ("CONST", [ singleton "I32"; al_of_int32 i32 ])
  | I64 i64 -> CaseV ("CONST", [ singleton "I64"; al_of_int64 i64 ])
  | F32 f32 -> CaseV ("CONST", [ singleton "F32"; al_of_float32 f32 ])
  | F64 f64 -> CaseV ("CONST", [ singleton "F64"; al_of_float64 f64 ])

let al_of_vec = function
  | V128 v128 -> (*
    CaseV ("VVCONST", [singleton "V128"; CaseV ("I32x4", List.map (fun i -> NumV (Int64.of_int32 i)) (V128.I32x4.to_lanes v128))])
    *)
    CaseV ("VVCONST", [ singleton "V128"; VecV (V128.to_string v128)])

let al_of_vec_shape shape (lanes: int64 list) =
  al_of_vec (V128 (
    match shape with
    | V128.I8x16() -> V128.I8x16.of_lanes (List.map Int64.to_int32 lanes)
    | V128.I16x8() -> V128.I16x8.of_lanes (List.map Int64.to_int32 lanes)
    | V128.I32x4() -> V128.I32x4.of_lanes (List.map Int64.to_int32 lanes)
    | V128.I64x2() -> V128.I64x2.of_lanes lanes
    | V128.F32x4() -> V128.F32x4.of_lanes (List.map (fun i -> i |> Int64.to_int32 |> F32.of_bits) lanes)
    | V128.F64x2() -> V128.F64x2.of_lanes (List.map F64.of_bits lanes)
  ))

let rec al_of_ref = function
  | NullRef ht -> CaseV ("REF.NULL", [ al_of_heap_type ht ])
  (*
  | I31.I31Ref i ->
    CaseV ("REF.I31_NUM", [ NumV (Int64.of_int i) ])
  | Aggr.StructRef a ->
    CaseV ("REF.STRUCT_ADDR", [ NumV (int64_of_int32_u a) ])
  | Aggr.ArrayRef a ->
    CaseV ("REF.ARRAY_ADDR", [ NumV (int64_of_int32_u a) ])
  | Instance.FuncRef a ->
    CaseV ("REF.FUNC_ADDR", [ NumV (int64_of_int32_u a) ])
  *)
  | Script.HostRef i32 -> CaseV ("REF.HOST_ADDR", [ al_of_int32 i32 ])
  | Extern.ExternRef r -> CaseV ("REF.EXTERN", [ al_of_ref r ])
  | r -> string_of_ref r |> failwith

let al_of_value = function
  | Num n -> al_of_num n
  | Vec v -> al_of_vec v
  | Ref r -> al_of_ref r


(* Construct operation *)

let al_of_op f1 f2 = function
  | I32 op -> [ singleton "I32"; f1 op ]
  | I64 op -> [ singleton "I64"; f1 op ]
  | F32 op -> [ singleton "F32"; f2 op ]
  | F64 op -> [ singleton "F64"; f2 op ]

let al_of_int_unop = function
  | IntOp.Clz -> TextV "Clz"
  | IntOp.Ctz -> TextV "Ctz"
  | IntOp.Popcnt -> TextV "Popcnt"
  | IntOp.ExtendS Pack.Pack8 -> TextV "Extend8S"
  | IntOp.ExtendS Pack.Pack16 -> TextV "Extend16S"
  | IntOp.ExtendS Pack.Pack32 -> TextV "Extend32S"
  | IntOp.ExtendS Pack.Pack64 -> TextV "Extend64S"
let al_of_float_unop = function
  | FloatOp.Neg -> TextV "Neg"
  | FloatOp.Abs -> TextV "Abs"
  | FloatOp.Ceil -> TextV "Ceil"
  | FloatOp.Floor -> TextV "Floor"
  | FloatOp.Trunc -> TextV "Trunc"
  | FloatOp.Nearest -> TextV "Nearest"
  | FloatOp.Sqrt -> TextV "Sqrt"
let al_of_unop = al_of_op al_of_int_unop al_of_float_unop

let al_of_int_binop = function
  | IntOp.Add -> TextV "Add"
  | IntOp.Sub -> TextV "Sub"
  | IntOp.Mul -> TextV "Mul"
  | IntOp.DivS -> TextV "DivS"
  | IntOp.DivU -> TextV "DivU"
  | IntOp.RemS -> TextV "RemS"
  | IntOp.RemU -> TextV "RemU"
  | IntOp.And -> TextV "And"
  | IntOp.Or -> TextV "Or"
  | IntOp.Xor -> TextV "Xor"
  | IntOp.Shl -> TextV "Shl"
  | IntOp.ShrS -> TextV "ShrS"
  | IntOp.ShrU -> TextV "ShrU"
  | IntOp.Rotl -> TextV "Rotl"
  | IntOp.Rotr -> TextV "Rotr"
let al_of_float_binop = function
  | FloatOp.Add -> TextV "Add"
  | FloatOp.Sub -> TextV "Sub"
  | FloatOp.Mul -> TextV "Mul"
  | FloatOp.Div -> TextV "Div"
  | FloatOp.Min -> TextV "Min"
  | FloatOp.Max -> TextV "Max"
  | FloatOp.CopySign -> TextV "CopySign"
let al_of_binop = al_of_op al_of_int_binop al_of_float_binop

let al_of_int_testop = function
  | IntOp.Eqz -> TextV "Eqz"
let al_of_testop: testop -> value list = function
  | I32 op -> [ singleton "I32"; al_of_int_testop op ]
  | I64 op -> [ singleton "I64"; al_of_int_testop op ]
  | _ -> .

let al_of_int_relop = function
  | IntOp.Eq -> TextV "Eq"
  | IntOp.Ne -> TextV "Ne"
  | IntOp.LtS -> TextV "LtS"
  | IntOp.LtU -> TextV "LtU"
  | IntOp.GtS -> TextV "GtS"
  | IntOp.GtU -> TextV "GtU"
  | IntOp.LeS -> TextV "LeS"
  | IntOp.LeU -> TextV "LeU"
  | IntOp.GeS -> TextV "GeS"
  | IntOp.GeU -> TextV "GeU"
let al_of_float_relop = function
  | FloatOp.Eq -> TextV "Eq"
  | FloatOp.Ne -> TextV "Ne"
  | FloatOp.Lt -> TextV "Lt"
  | FloatOp.Gt -> TextV "Gt"
  | FloatOp.Le -> TextV "Le"
  | FloatOp.Ge -> TextV "Ge"
let al_of_relop = al_of_op al_of_int_relop al_of_float_relop

let al_of_int_cvtop num_bits = function
  | IntOp.ExtendSI32 -> "Extend", "I32", Some (singleton "S")
  | IntOp.ExtendUI32 -> "Extend", "I32", Some (singleton "U")
  | IntOp.WrapI64 -> "Wrap", "I64", None
  | IntOp.TruncSF32 -> "Trunc", "F32", Some (singleton "S")
  | IntOp.TruncUF32 -> "Trunc", "F32", Some (singleton "U")
  | IntOp.TruncSF64 -> "Trunc", "F64", Some (singleton "S")
  | IntOp.TruncUF64 -> "Trunc", "F64", Some (singleton "U")
  | IntOp.TruncSatSF32 -> "TruncSat", "F32", Some (singleton "S")
  | IntOp.TruncSatUF32 -> "TruncSat", "F32", Some (singleton "U")
  | IntOp.TruncSatSF64 -> "TruncSat", "F64", Some (singleton "S")
  | IntOp.TruncSatUF64 -> "TruncSat", "F64", Some (singleton "U")
  | IntOp.ReinterpretFloat -> "Reinterpret", "F" ^ num_bits, None
let al_of_float_cvtop num_bits = function
  | FloatOp.ConvertSI32 -> "Convert", "I32", Some (singleton ("S"))
  | FloatOp.ConvertUI32 -> "Convert", "I32", Some (singleton ("U"))
  | FloatOp.ConvertSI64 -> "Convert", "I64", Some (singleton ("S"))
  | FloatOp.ConvertUI64 -> "Convert", "I64", Some (singleton ("U"))
  | FloatOp.PromoteF32 -> "Promote", "F32", None
  | FloatOp.DemoteF64 -> "Demote", "F64", None
  | FloatOp.ReinterpretInt -> "Reinterpret", "I" ^ num_bits, None
let al_of_cvtop = function
  | I32 op ->
    let op', to_, ext = al_of_int_cvtop "32" op in
    [ singleton "I32"; TextV op'; singleton to_; OptV ext ]
  | I64 op ->
    let op', to_, ext = al_of_int_cvtop "64" op in
    [ singleton "I64"; TextV op'; singleton to_; OptV ext ]
  | F32 op ->
    let op', to_, ext = al_of_float_cvtop "32" op in
    [ singleton "F32"; TextV op'; singleton to_; OptV ext ]
  | F64 op ->
    let op', to_, ext = al_of_float_cvtop "64" op in
    [ singleton "F64"; TextV op'; singleton to_; OptV ext ]

(* Vector operator *)

let al_of_extension = function
  | Pack.SX -> singleton "S"
  | Pack.ZX -> singleton "U"

let al_of_vop f1 f2 = function
  | V128 vop -> (
    match vop with
    | V128.I8x16 op -> [ singleton "I8X16"; f1 op ]
    | V128.I16x8 op -> [ singleton "I16X8"; f1 op ]
    | V128.I32x4 op -> [ singleton "I32X4"; f1 op ]
    | V128.I64x2 op -> [ singleton "I64X2"; f1 op ]
    | V128.F32x4 op -> [ singleton "F32X4"; f2 op ]
    | V128.F64x2 op -> [ singleton "F64X2"; f2 op ]
  )

let al_of_viop f1:
    ('a, 'a, 'a, 'a, void, void) V128.laneop vecop -> Al.Ast.value list =
  function
  | V128 vop -> (
    match vop with
    | V128.I8x16 op -> [ singleton "I8X16"; f1 op ]
    | V128.I16x8 op -> [ singleton "I16X8"; f1 op ]
    | V128.I32x4 op -> [ singleton "I32X4"; f1 op ]
    | V128.I64x2 op -> [ singleton "I64X2"; f1 op ]
    | _ -> .
  )

let al_of_vtestop : vec_testop -> value list = function
  | V128 vop -> (
    match vop with
    | V128.I8x16 _ -> [ singleton "I8X16" ]
    | V128.I16x8 _ -> [ singleton "I16X8" ]
    | V128.I32x4 _ -> [ singleton "I32X4" ]
    | V128.I64x2 _ -> [ singleton "I64X2" ]
    | _ -> .
  )

let al_of_int_vrelop : V128Op.irelop -> value = function
  | V128Op.Eq -> case_v "_VI" (singleton "Eq")
  | V128Op.Ne -> case_v "_VI" (singleton "Ne")
  | V128Op.LtS -> case_v "_VI" (singleton "LtS")
  | V128Op.LtU -> case_v "_VI" (singleton "LtU")
  | V128Op.LeS -> case_v "_VI" (singleton "LeS")
  | V128Op.LeU -> case_v "_VI" (singleton "LeU")
  | V128Op.GtS -> case_v "_VI" (singleton "GtS")
  | V128Op.GtU -> case_v "_VI" (singleton "GtU")
  | V128Op.GeS -> case_v "_VI" (singleton "GeS")
  | V128Op.GeU -> case_v "_VI" (singleton "GeU")

let al_of_float_vrelop : V128Op.frelop -> value = function
  | V128Op.Eq -> case_v "_VF" (singleton "Eq")
  | V128Op.Ne -> case_v "_VF" (singleton "Ne")
  | V128Op.Lt -> case_v "_VF" (singleton "Lt")
  | V128Op.Le -> case_v "_VF" (singleton "Le")
  | V128Op.Gt -> case_v "_VF" (singleton "Gt")
  | V128Op.Ge -> case_v "_VF" (singleton "Ge")

let al_of_vrelop = al_of_vop al_of_int_vrelop al_of_float_vrelop

let al_of_int_vunop : V128Op.iunop -> value = function
  | V128Op.Abs -> case_v "_VI" (singleton "Abs")
  | V128Op.Neg -> case_v "_VI" (singleton "Neg")
  | V128Op.Popcnt -> case_v "_VI" (singleton "Popcnt")

let al_of_float_vunop : V128Op.funop -> value = function
  | V128Op.Abs -> case_v "_VF" (singleton "Abs")
  | V128Op.Neg -> case_v "_VF" (singleton "Neg")
  | V128Op.Sqrt -> case_v "_VF" (singleton "Sqrt")
  | V128Op.Ceil -> case_v "_VF" (singleton "Ceil")
  | V128Op.Floor -> case_v "_VF" (singleton "Floor")
  | V128Op.Trunc -> case_v "_VF" (singleton "Trunc")
  | V128Op.Nearest -> case_v "_VF" (singleton "Nearest")

let al_of_vunop = al_of_vop al_of_int_vunop al_of_float_vunop

let al_of_int_vbinop : V128Op.ibinop -> value = function
  | V128Op.Add -> case_v "_VI" (singleton "Add")
  | V128Op.Sub -> case_v "_VI" (singleton "Sub")
  | V128Op.Mul -> case_v "_VI" (singleton "Mul")
  | V128Op.MinS -> case_v "_VI" (singleton "MinS")
  | V128Op.MinU -> case_v "_VI" (singleton "MinU")
  | V128Op.MaxS -> case_v "_VI" (singleton "MaxS")
  | V128Op.MaxU -> case_v "_VI" (singleton "MaxU")
  | V128Op.AvgrU -> case_v "_VI" (singleton "AvgrU")
  | V128Op.AddSatS -> case_v "_VI" (singleton "AddSatS")
  | V128Op.AddSatU -> case_v "_VI" (singleton "AddSatU")
  | V128Op.SubSatS -> case_v "_VI" (singleton "SubSatS")
  | V128Op.SubSatU -> case_v "_VI" (singleton "SubSatU")
  | V128Op.DotS -> case_v "_VI" (singleton "DotS")
  | V128Op.Q15MulRSatS -> case_v "_VI" (singleton "Q15MulRSatS")
  | V128Op.ExtMulLowS -> case_v "_VI" (singleton "ExtMulLowS")
  | V128Op.ExtMulHighS -> case_v "_VI" (singleton "ExtMulHighS")
  | V128Op.ExtMulLowU -> case_v "_VI" (singleton "ExtMulLowU")
  | V128Op.ExtMulHighU -> case_v "_VI" (singleton "ExtMulHighU")
  | V128Op.Swizzle -> case_v "_VI" (singleton "Swizzle")
  | V128Op.Shuffle l -> case_v "Shuffle" (al_of_list al_of_int l)
  | V128Op.NarrowS -> case_v "_VI" (singleton "NarrowS")
  | V128Op.NarrowU -> case_v "_VI" (singleton "NarrowU")

let al_of_float_vbinop : V128Op.fbinop -> value = function
  | V128Op.Add -> case_v "_VF" (singleton "Add")
  | V128Op.Sub -> case_v "_VF" (singleton "Sub")
  | V128Op.Mul -> case_v "_VF" (singleton "Mul")
  | V128Op.Div -> case_v "_VF" (singleton "Div")
  | V128Op.Min -> case_v "_VF" (singleton "Min")
  | V128Op.Max -> case_v "_VF" (singleton "Max")
  | V128Op.Pmin -> case_v "_VF" (singleton "Pmin")
  | V128Op.Pmax -> case_v "_VF" (singleton "Pmax")

let al_of_vbinop = al_of_vop al_of_int_vbinop al_of_float_vbinop

let al_of_int_vcvtop : V128Op.icvtop -> value = function
  | V128Op.ExtendLowS -> case_v "_VI" (singleton "ExtendLowS")
  | V128Op.ExtendLowU -> case_v "_VI" (singleton "ExtendLowU")
  | V128Op.ExtendHighS -> case_v "_VI" (singleton "ExtendHighS")
  | V128Op.ExtendHighU -> case_v "_VI" (singleton "ExtendHighU")
  | V128Op.ExtAddPairwiseS -> case_v "_VI" (singleton "ExtAddPairwiseS")
  | V128Op.ExtAddPairwiseU -> case_v "_VI" (singleton "ExtAddPairwiseU")
  | V128Op.TruncSatSF32x4 -> case_v "_VI" (singleton "TruncSatSF32x4")
  | V128Op.TruncSatUF32x4 -> case_v "_VI" (singleton "TruncSatUF32x4")
  | V128Op.TruncSatSZeroF64x2 -> case_v "_VI" (singleton "TruncSatSZeroF64x2")
  | V128Op.TruncSatUZeroF64x2 -> case_v "_VI" (singleton "TruncSatUZeroF64x2")

let al_of_float_vcvtop : V128Op.fcvtop -> value = function
  | V128Op.DemoteZeroF64x2 -> case_v "_VF" (singleton "DemoteZeroF64x2")
  | V128Op.PromoteLowF32x4 -> case_v "_VF" (singleton "PromoteLowF32x4")
  | V128Op.ConvertSI32x4 -> case_v "_VF" (singleton "ConvertSI32x4")
  | V128Op.ConvertUI32x4 -> case_v "_VF" (singleton "ConvertUI32x4")

let al_of_vcvtop = al_of_vop al_of_int_vcvtop al_of_float_vcvtop

let al_of_int_vshiftop : V128Op.ishiftop -> value = function
  | V128Op.Shl -> case_v "_VI" (singleton "Shl")
  | V128Op.ShrS -> case_v "_VI" (singleton "ShrS")
  | V128Op.ShrU -> case_v "_VI" (singleton "ShrU")

let al_of_vshiftop = al_of_viop al_of_int_vshiftop

let al_of_int_vbitmaskop : V128Op.ibitmaskop -> value = function
  | V128Op.Bitmask -> case_v "_VI" (singleton "Bitmask")

let al_of_vbitmaskop = al_of_viop al_of_int_vbitmaskop

let al_of_vvtestop : vec_vtestop -> value list = function
  | V128 vop -> (
    match vop with
    | V128Op.AnyTrue ->
      [ singleton "V128"; case_v "_VV" (singleton "AnyTrue") ]
  )

let al_of_vvunop : vec_vunop -> value list = function
  | V128 vop -> (
    match vop with
    | V128Op.Not -> [ singleton "V128"; case_v "_VV" (singleton "Not") ]
  )

let al_of_vvbinop : vec_vbinop -> value list = function
  | V128 vop -> (
    match vop with
    | V128Op.And -> [ singleton "V128"; case_v "_VV" (singleton "And") ]
    | V128Op.Or -> [ singleton "V128"; case_v "_VV" (singleton "Or") ]
    | V128Op.Xor -> [ singleton "V128"; case_v "_VV" (singleton "Xor") ]
    | V128Op.AndNot -> [ singleton "V128"; case_v "_VV" (singleton "AndNot") ]
  )

let al_of_vvternop : vec_vternop -> value list = function
  | V128 vop -> (
    match vop with
    | V128Op.Bitselect ->
      [ singleton "V128"; case_v "_VV" (singleton "Bitselect") ]
  )

let al_of_vsplatop : vec_splatop -> value list = function
  | V128 vop -> (
    match vop with
    | V128.I8x16 _ -> [ singleton "I8X16" ]
    | V128.I16x8 _ -> [ singleton "I16X8" ]
    | V128.I32x4 _ -> [ singleton "I32X4" ]
    | V128.I64x2 _ -> [ singleton "I64X2" ]
    | V128.F32x4 _ -> [ singleton "F32X4" ]
    | V128.F64x2 _ -> [ singleton "F64X2" ]
  )

let al_of_vextractop : vec_extractop -> value list = function
  | V128 vop -> (
    match vop with
    | V128.I8x16 vop' -> (
      match vop' with
      | Extract (n, ext) ->
          [ singleton "I8X16"; OptV (Some (al_of_extension ext)); al_of_int n; ]
    )
    | V128.I16x8 vop' -> (
      match vop' with
      | Extract (n, ext) ->
          [ singleton "I16X8"; OptV (Some (al_of_extension ext)); al_of_int n; ]
    )
    | V128.I32x4 vop' -> (
      match vop' with
      | Extract (n, _) -> [ singleton "I32X4"; OptV None; al_of_int n ]
    )
    | V128.I64x2 vop' -> (
      match vop' with
      | Extract (n, _) -> [ singleton "I64X2"; OptV None; al_of_int n ]
    )
    | V128.F32x4 vop' -> (
      match vop' with
      | Extract (n, _) -> [ singleton "F32X4"; OptV None; al_of_int n ]
    )
    | V128.F64x2 vop' -> (
      match vop' with
      | Extract (n, _) -> [ singleton "F64X2"; OptV None; al_of_int n ]
    )
  )

let al_of_vreplaceop : vec_replaceop -> value list = function
  | V128 vop -> (
    match vop with
    | V128.I8x16 (Replace n) -> [ singleton "I8X16"; al_of_int n ]
    | V128.I16x8 (Replace n) -> [ singleton "I16X8"; al_of_int n ]
    | V128.I32x4 (Replace n) -> [ singleton "I32X4"; al_of_int n ]
    | V128.I64x2 (Replace n) -> [ singleton "I64X2"; al_of_int n ]
    | V128.F32x4 (Replace n) -> [ singleton "F32X4"; al_of_int n ]
    | V128.F64x2 (Replace n) -> [ singleton "F64X2"; al_of_int n ]
  )

let al_of_pack_size = function
  | Pack.Pack8 -> al_of_int 8
  | Pack.Pack16 -> al_of_int 16
  | Pack.Pack32 -> al_of_int 32
  | Pack.Pack64 -> al_of_int 64

let al_of_memop f memop =
  let str =
    Record.empty
    |> Record.add "ALIGN" (al_of_int memop.align)
    |> Record.add "OFFSET" (al_of_int32 memop.offset)
  in
  [ al_of_num_type memop.ty; f memop.pack ] @ al_of_memidx () @ [ StrV str ]

let al_of_pack_size_extension (p, s) = TupV [ al_of_pack_size p; al_of_extension s ]

let al_of_loadop = al_of_opt al_of_pack_size_extension |> al_of_memop

let al_of_storeop = al_of_opt al_of_pack_size |> al_of_memop


(* Construct instruction *)

let rec al_of_instr instr =
  match instr.it with
  (* wasm values *)
  | Const num -> al_of_num num.it
  | VecConst vec -> al_of_vec vec.it
  | RefNull ht -> CaseV ("REF.NULL", [ al_of_heap_type ht ])
  (* wasm instructions *)
  | Unreachable -> singleton "UNREACHABLE"
  | Nop -> singleton "NOP"
  | Drop -> singleton "DROP"
  | Unary op -> CaseV ("UNOP", al_of_unop op)
  | Binary op -> CaseV ("BINOP", al_of_binop op)
  | Test op -> CaseV ("TESTOP", al_of_testop op)
  | Compare op -> CaseV ("RELOP", al_of_relop op)
  | Convert op -> CaseV ("CVTOP", al_of_cvtop op)
  | VecTest vop -> CaseV ("ALL_TRUE", al_of_vtestop vop)
  | VecCompare vop -> CaseV ("VRELOP", al_of_vrelop vop)
  | VecUnary vop -> CaseV ("VUNOP", al_of_vunop vop)
  | VecBinary vop -> CaseV ("VBINOP", al_of_vbinop vop)
  | VecConvert vop -> CaseV ("VCVTOP", al_of_vcvtop vop)
  | VecShift vop -> CaseV ("VISHIFTOP", al_of_vshiftop vop)
  | VecBitmask vop -> CaseV ("BITMASK", al_of_vbitmaskop vop)
  | VecTestBits vop -> CaseV ("VVTESTOP", al_of_vvtestop vop)
  | VecUnaryBits vop -> CaseV ("VVUNOP", al_of_vvunop vop)
  | VecBinaryBits vop -> CaseV ("VVBINOP", al_of_vvbinop vop)
  | VecTernaryBits vop -> CaseV ("VVTERNOP", al_of_vvternop vop)
  | VecSplat vop -> CaseV ("SPLAT", al_of_vsplatop vop)
  | VecExtract vop -> CaseV ("EXTRACT_LANE", al_of_vextractop vop)
  | VecReplace vop -> CaseV ("REPLACE_LANE", al_of_vreplaceop vop)
  | RefIsNull -> singleton "REF.IS_NULL"
  | RefFunc idx -> CaseV ("REF.FUNC", [ al_of_idx idx ])
  | Select vtl_opt -> CaseV ("SELECT", [ al_of_opt (al_of_list al_of_val_type) vtl_opt ])
  | LocalGet idx -> CaseV ("LOCAL.GET", [ al_of_idx idx ])
  | LocalSet idx -> CaseV ("LOCAL.SET", [ al_of_idx idx ])
  | LocalTee idx -> CaseV ("LOCAL.TEE", [ al_of_idx idx ])
  | GlobalGet idx -> CaseV ("GLOBAL.GET", [ al_of_idx idx ])
  | GlobalSet idx -> CaseV ("GLOBAL.SET", [ al_of_idx idx ])
  | TableGet idx -> CaseV ("TABLE.GET", [ al_of_idx idx ])
  | TableSet idx -> CaseV ("TABLE.SET", [ al_of_idx idx ])
  | TableSize idx -> CaseV ("TABLE.SIZE", [ al_of_idx idx ])
  | TableGrow idx -> CaseV ("TABLE.GROW", [ al_of_idx idx ])
  | TableFill idx -> CaseV ("TABLE.FILL", [ al_of_idx idx ])
  | TableCopy (idx1, idx2) -> CaseV ("TABLE.COPY", [ al_of_idx idx1; al_of_idx idx2 ])
  | TableInit (idx1, idx2) -> CaseV ("TABLE.INIT", [ al_of_idx idx1; al_of_idx idx2 ])
  | ElemDrop idx -> CaseV ("ELEM.DROP", [ al_of_idx idx ])
  | Block (bt, instrs) ->
    CaseV ("BLOCK", [ al_of_blocktype bt; al_of_list al_of_instr instrs ])
  | Loop (bt, instrs) ->
    CaseV ("LOOP", [ al_of_blocktype bt; al_of_list al_of_instr instrs ])
  | If (bt, instrs1, instrs2) ->
    CaseV ("IF", [
      al_of_blocktype bt;
      al_of_list al_of_instr instrs1;
      al_of_list al_of_instr instrs2;
    ])
  | Br idx -> CaseV ("BR", [ al_of_idx idx ])
  | BrIf idx -> CaseV ("BR_IF", [ al_of_idx idx ])
  | BrTable (idxs, idx) ->
    CaseV ("BR_TABLE", [ al_of_list al_of_idx idxs; al_of_idx idx ])
  | BrOnNull idx -> CaseV ("BR_ON_NULL", [ al_of_idx idx ])
  | BrOnNonNull idx -> CaseV ("BR_ON_NON_NULL", [ al_of_idx idx ])
  | BrOnCast (idx, rt1, rt2) ->
    CaseV ("BR_ON_CAST", [ al_of_idx idx; al_of_ref_type rt1; al_of_ref_type rt2 ])
  | BrOnCastFail (idx, rt1, rt2) ->
    CaseV ("BR_ON_CAST_FAIL", [ al_of_idx idx; al_of_ref_type rt1; al_of_ref_type rt2 ])
  | Return -> singleton "RETURN"
  | Call idx -> CaseV ("CALL", [ al_of_idx idx ])
  | CallRef idx -> CaseV ("CALL_REF", [ OptV (Some (al_of_idx idx)) ])
  | CallIndirect (idx1, idx2) ->
    let args = al_with_version [ 2; 3 ] al_of_idx idx1 @ [ al_of_idx idx2 ] in
    CaseV ("CALL_INDIRECT", args)
  | ReturnCall idx -> CaseV ("RETURN_CALL", [ al_of_idx idx ])
  | ReturnCallRef idx -> CaseV ("RETURN_CALL_REF", [ OptV (Some (al_of_idx idx)) ])
  | ReturnCallIndirect (idx1, idx2) ->
    CaseV ("RETURN_CALL_INDIRECT", [ al_of_idx idx1; al_of_idx idx2 ])
  | Load loadop -> CaseV ("LOAD", al_of_loadop loadop)
  | Store storeop -> CaseV ("STORE", al_of_storeop storeop)
  | MemorySize -> CaseV ("MEMORY.SIZE", al_of_memidx ())
  | MemoryGrow -> CaseV ("MEMORY.GROW", al_of_memidx ())
  | MemoryFill -> CaseV ("MEMORY.FILL", al_of_memidx ())
  | MemoryCopy -> CaseV ("MEMORY.COPY", al_of_memidx () @ al_of_memidx ())
  | MemoryInit i32 -> CaseV ("MEMORY.INIT", (al_of_memidx ()) @ [ al_of_idx i32 ])
  | DataDrop idx -> CaseV ("DATA.DROP", [ al_of_idx idx ])
  | RefAsNonNull -> singleton "REF.AS_NON_NULL"
  | RefTest rt -> CaseV ("REF.TEST", [ al_of_ref_type rt ])
  | RefCast rt -> CaseV ("REF.CAST", [ al_of_ref_type rt ])
  | RefEq -> singleton "REF.EQ"
  | RefI31 -> singleton "REF.I31"
  | I31Get ext -> CaseV ("I31.GET", [ al_of_extension ext ])
  | StructNew (idx, Explicit) -> CaseV ("STRUCT.NEW", [ al_of_idx idx ])
  | StructNew (idx, Implicit) -> CaseV ("STRUCT.NEW_DEFAULT", [ al_of_idx idx ])
  | StructGet (idx1, idx2, ext_opt) ->
    CaseV ("STRUCT.GET", [
      al_of_opt al_of_extension ext_opt;
      al_of_idx idx1;
      al_of_idx idx2;
    ])
  | StructSet (idx1, idx2) -> CaseV ("STRUCT.SET", [ al_of_idx idx1; al_of_idx idx2 ])
  | ArrayNew (idx, Explicit) -> CaseV ("ARRAY.NEW", [ al_of_idx idx ])
  | ArrayNew (idx, Implicit) -> CaseV ("ARRAY.NEW_DEFAULT", [ al_of_idx idx ])
  | ArrayNewFixed (idx, i32) ->
    CaseV ("ARRAY.NEW_FIXED", [ al_of_idx idx; al_of_int32 i32 ])
  | ArrayNewElem (idx1, idx2) ->
    CaseV ("ARRAY.NEW_ELEM", [ al_of_idx idx1; al_of_idx idx2 ])
  | ArrayNewData (idx1, idx2) ->
    CaseV ("ARRAY.NEW_DATA", [ al_of_idx idx1; al_of_idx idx2 ])
  | ArrayGet (idx, ext_opt) ->
    CaseV ("ARRAY.GET", [ al_of_opt al_of_extension ext_opt; al_of_idx idx ])
  | ArraySet idx -> CaseV ("ARRAY.SET", [ al_of_idx idx ])
  | ArrayLen -> singleton "ARRAY.LEN"
  | ArrayCopy (idx1, idx2) -> CaseV ("ARRAY.COPY", [ al_of_idx idx1; al_of_idx idx2 ])
  | ArrayFill idx -> CaseV ("ARRAY.FILL", [ al_of_idx idx ])
  | ArrayInitData (idx1, idx2) ->
    CaseV ("ARRAY.INIT_DATA", [ al_of_idx idx1; al_of_idx idx2 ])
  | ArrayInitElem (idx1, idx2) ->
    CaseV ("ARRAY.INIT_ELEM", [ al_of_idx idx1; al_of_idx idx2 ])
  | ExternConvert Internalize -> singleton "ANY.CONVERT_EXTERN"
  | ExternConvert Externalize -> singleton "EXTERN.CONVERT_ANY"
  | _ -> CaseV ("TODO: Unconstructed Wasm instruction (al_of_instr)", [])

let al_of_const const = al_of_list al_of_instr const.it


(* Construct module *)

let al_of_type ty =
  match !version with
  | 3 ->
    CaseV ("TYPE", [ al_of_rec_type ty.it ])
  | _ ->
    let sub_types =
      al_of_rec_type ty.it
      |> arg_of_case "REC" 0
      |> al_to_list
    in

    match sub_types with
    | [ subtype ] ->
      subtype
      |> arg_of_case "SUBD" 2
      |> arg_of_case "FUNC" 0
      |> case_v "TYPE"
    | _ -> failwith ("Rectype is no supported in Wasm " ^ (string_of_int !version))

let al_of_local l = CaseV ("LOCAL", [ al_of_val_type l.it.ltype ])

let al_of_func func =
  CaseV ("FUNC", [
    al_of_idx func.it.ftype;
    al_of_list al_of_local func.it.locals;
    al_of_list al_of_instr func.it.body;
  ])

let al_of_global global =
  CaseV ("GLOBAL", [
    al_of_global_type global.it.gtype;
    al_of_const global.it.ginit;
  ])

let al_of_table table =
  match !version with
  | 1 -> CaseV ("TABLE", [ al_of_table_type table.it.ttype |> arg_of_tup 0 ])
  | 2 -> CaseV ("TABLE", [ al_of_table_type table.it.ttype ])
  | 3 -> CaseV ("TABLE", [ al_of_table_type table.it.ttype; al_of_const table.it.tinit ])
  | _ -> failwith "Unsupported version"

let al_of_memory memory =
  let arg = al_of_memory_type memory.it.mtype in
  let arg' =
    if !version = 1 then
      arg_of_case "I8" 0 arg
    else arg
  in
  CaseV ("MEMORY", [ arg' ])

let al_of_segment segment =
  match segment.it with
  | Passive -> singleton "PASSIVE"
  | Active { index; offset } ->
    CaseV ("ACTIVE", [ al_of_idx index; al_of_const offset ])
  | Declarative -> singleton "DECLARE"

let al_of_elem elem =
  if !version = 1 then
    CaseV ("ELEM", [
      al_of_segment elem.it.emode |> arg_of_case "ACTIVE" 1;
      al_of_list al_of_const elem.it.einit
      |> al_to_list
      |> List.map (fun expr -> expr |> al_to_list |> List.hd |> (arg_of_case "REF.FUNC" 0))
      |> listV;
    ])
  else
    CaseV ("ELEM", [
      al_of_ref_type elem.it.etype;
      al_of_list al_of_const elem.it.einit;
      al_of_segment elem.it.emode;
    ])

let al_of_data data =
  let seg = al_of_segment data.it.dmode in
  let bytes_ = al_of_bytes data.it.dinit in
  if !version = 1 then
    CaseV ("DATA", [ arg_of_case "ACTIVE" 1 seg; bytes_ ])
  else
    CaseV ("DATA", [ bytes_; seg ])

let al_of_import_desc module_ idesc =
  match idesc.it with
  | FuncImport x ->
      let dts = def_types_of module_ in
      let dt = Lib.List32.nth dts x.it |> al_of_def_type in
      CaseV ("FUNC", [ dt ])
  | TableImport tt -> CaseV ("TABLE", [ al_of_table_type tt ])
  | MemoryImport mt -> CaseV ("MEM", [ al_of_memory_type mt ])
  | GlobalImport gt -> CaseV ("GLOBAL", [ al_of_global_type gt ])

let al_of_import module_ import =
  CaseV ("IMPORT", [
    al_of_name import.it.module_name;
    al_of_name import.it.item_name;
    al_of_import_desc module_ import.it.idesc;
  ])

let al_of_export_desc export_desc = match export_desc.it with
  | FuncExport idx -> CaseV ("FUNC", [ al_of_idx idx ])
  | TableExport idx -> CaseV ("TABLE", [ al_of_idx idx ])
  | MemoryExport idx -> CaseV ("MEM", [ al_of_idx idx ])
  | GlobalExport idx -> CaseV ("GLOBAL", [ al_of_idx idx ])

let al_of_start start = CaseV ("START", [ al_of_idx start.it.sfunc ])

let al_of_export export =
  CaseV ("EXPORT", [ al_of_name export.it.name; al_of_export_desc export.it.edesc ])

let al_of_module module_ =
  CaseV ("MODULE", [
    al_of_list al_of_type module_.it.types;
    al_of_list (al_of_import module_) module_.it.imports;
    al_of_list al_of_func module_.it.funcs;
    al_of_list al_of_global module_.it.globals;
    al_of_list al_of_table module_.it.tables;
    al_of_list al_of_memory module_.it.memories;
    al_of_list al_of_elem module_.it.elems;
    al_of_list al_of_data module_.it.datas;
    al_of_opt al_of_start module_.it.start;
    al_of_list al_of_export module_.it.exports;
  ])


(* Destruct *)

(* Destruct data structure *)

let al_to_list (f: value -> 'a): value -> 'a list = function
  | ListV arr_ref -> Array.to_list !arr_ref |> List.map f
  | v -> fail "list" v
let al_to_seq f s = al_to_list f s |> List.to_seq
let al_to_opt (f: value -> 'a): value -> 'a option = function
  | OptV opt -> Option.map f opt
  | v -> fail "option" v
let al_to_phrase (f: value -> 'a) (v: value): 'a phrase = f v @@ no_region


(* Destruct minor *)

let al_to_int64: value -> int64 = function
  | NumV i64 -> i64
  | v -> fail "int64" v
let al_to_int (v: value): int = al_to_int64 v |> Int64.to_int
let al_to_int32 (v: value): int32 = al_to_int64 v |> Int64.to_int32
let al_to_float32 (v: value): F32.t = al_to_int32 v |> F32.of_bits
let al_to_float64 (v: value): F64.t = al_to_int64 v |> F64.of_bits
let al_to_idx: value -> idx = al_to_phrase al_to_int32
let al_to_byte (v: value): Char.t = al_to_int v |> Char.chr
let al_to_bytes (v: value): string = al_to_seq al_to_byte v |> String.of_seq
let al_to_name = function
  | TextV name -> Utf8.decode name
  | v -> fail "name" v


(* Destruct type *)

let al_to_null: value -> null = function
  | CaseV ("NULL", [ OptV None ]) -> NoNull
  | CaseV ("NULL", [ OptV _ ]) -> Null
  | v -> fail "null" v

let al_to_final: value -> final = function
  | OptV None -> NoFinal
  | OptV (Some (CaseV ("FINAL", []))) -> Final
  | v -> fail "final" v

let al_to_mut: value -> mut = function
  | OptV None -> Cons
  | OptV (Some (CaseV ("MUT", []))) -> Var
  | v -> fail "mut" v

let rec al_to_storage_type: value -> storage_type = function
  | CaseV ("I8", []) -> PackStorageT Pack8
  | CaseV ("I16", []) -> PackStorageT Pack16
  | v -> ValStorageT (al_to_val_type v)

and al_to_field_type: value -> field_type = function
  | TupV [ mut; st ] -> FieldT (al_to_mut mut, al_to_storage_type st)
  | v -> fail "field type" v

and al_to_result_type: value -> result_type = function
  v -> al_to_list al_to_val_type v

and al_to_str_type: value -> str_type = function
  | CaseV ("STRUCT", [ ftl ]) -> DefStructT (StructT (al_to_list al_to_field_type ftl))
  | CaseV ("ARRAY", [ ft ]) -> DefArrayT (ArrayT (al_to_field_type ft))
  | CaseV ("FUNC", [ ArrowV (rt1, rt2) ]) ->
    DefFuncT (FuncT (al_to_result_type rt1, (al_to_result_type rt2)))
  | v -> fail "str type" v

and al_to_sub_type: value -> sub_type = function
  | CaseV ("SUBD", [ fin; htl; st ]) ->
    SubT (al_to_final fin, al_to_list al_to_heap_type htl, al_to_str_type st)
  | v -> fail "sub type" v

and al_to_rec_type: value -> rec_type = function
  | CaseV ("REC", [ stl ]) -> RecT (al_to_list al_to_sub_type stl)
  | v -> fail "rec type" v

and al_to_def_type: value -> def_type = function
  | CaseV ("DEF", [ rt; i32 ]) -> DefT (al_to_rec_type rt, al_to_int32 i32)
  | v -> fail "def type" v

and al_to_heap_type: value -> heap_type = function
  | CaseV ("_IDX", [ i32 ]) -> VarHT (StatX (al_to_int32 i32))
  | CaseV ("REC", [ i32 ]) -> VarHT (RecX (al_to_int32 i32))
  | CaseV ("DEF", _) as v -> DefHT (al_to_def_type v)
  | CaseV (tag, []) as v ->
    (match tag with
    | "BOT" -> BotHT
    | "ANY" -> AnyHT
    | "NONE" -> NoneHT
    | "EQ" -> EqHT
    | "I31" -> I31HT
    | "STRUCT" -> StructHT
    | "ARRAY" -> ArrayHT
    | "FUNC" -> FuncHT
    | "NOFUNC" -> NoFuncHT
    | "EXTERN" -> ExternHT
    | "NOEXTERN" -> NoExternHT
    | _ -> fail "abstract heap type" v)
  | v -> fail "heap type" v

and al_to_ref_type: value -> ref_type = function
  | CaseV ("REF", [ n; ht ]) -> al_to_null n, al_to_heap_type ht
  | v -> fail "ref type" v

and al_to_num_type: value -> num_type = function
  | CaseV ("I32", []) -> I32T
  | CaseV ("I64", []) -> I64T
  | CaseV ("F32", []) -> F32T
  | CaseV ("F64", []) -> F64T
  | v -> fail "num type" v

and al_to_val_type: value -> val_type = function
  | CaseV ("I32", _) | CaseV ("I64", _)
  | CaseV ("F32", _) | CaseV ("F64", _) as v -> NumT (al_to_num_type v)
  | CaseV ("V128", []) -> VecT V128T
  | CaseV ("REF", _) as v -> RefT (al_to_ref_type v)
  | CaseV ("BOT", []) -> BotT
  | v -> fail "val type" v

let al_to_block_type: value -> block_type = function
  | CaseV ("_IDX", [ idx ]) -> VarBlockType (al_to_idx idx)
  | CaseV ("_RESULT", [ vt_opt ]) -> ValBlockType (al_to_opt al_to_val_type vt_opt)
  | v -> fail "block type" v

let al_to_limits (default: int64): value -> int32 limits = function
  | TupV [ min; max ] ->
    let max' =
      match al_to_int64 max with
      | i64 when default = i64 -> None
      | _ -> Some (al_to_int32 max)
    in
    { min = al_to_int32 min; max = max' }
  | v -> fail "limits" v


let al_to_global_type: value -> global_type = function
  | TupV [ mut; vt ] -> GlobalT (al_to_mut mut, al_to_val_type vt)
  | v -> fail "global type" v

let al_to_table_type: value -> table_type = function
  | TupV [ limits; rt ] -> TableT (al_to_limits default_table_max limits, al_to_ref_type rt)
  | v -> fail "table type" v

let al_to_memory_type: value -> memory_type = function
  | CaseV ("I8", [ limits ]) -> MemoryT (al_to_limits default_memory_max limits)
  | v -> fail "memory type" v


(* Destruct value *)

let al_to_num: value -> num = function
  | CaseV ("CONST", [ CaseV ("I32", []); i32 ]) -> I32 (al_to_int32 i32)
  | CaseV ("CONST", [ CaseV ("I64", []); i64 ]) -> I64 (al_to_int64 i64)
  | CaseV ("CONST", [ CaseV ("F32", []); f32 ]) -> F32 (al_to_float32 f32)
  | CaseV ("CONST", [ CaseV ("F64", []); f64 ]) -> F64 (al_to_float64 f64)
  | v -> fail "num" v

let al_to_vec: value -> vec = function
  | CaseV ("VVCONST", [ CaseV ("V128", []); VecV (v128)]) -> V128 (V128.of_bits v128)
  | v -> fail "vec" v

let rec al_to_ref: value -> ref_ = function
  | CaseV ("REF.NULL", [ ht ]) -> NullRef (al_to_heap_type ht)
  | CaseV ("REF.HOST_ADDR", [ i32 ]) -> Script.HostRef (al_to_int32 i32)
  | CaseV ("REF.EXTERN", [ r ]) -> Extern.ExternRef (al_to_ref r)
  | v -> fail "ref" v

let al_to_value: value -> Value.value = function
  | CaseV ("CONST", _) as v -> Num (al_to_num v)
  | CaseV (ref_, _) as v when String.sub ref_ 0 4 = "REF." -> Ref (al_to_ref v)
  | v -> fail "value" v


(* Destruct operator *)

let al_to_op f1 f2 = function
  | [ CaseV ("I32", []); op ] -> I32 (f1 op)
  | [ CaseV ("I64", []); op ] -> I64 (f1 op)
  | [ CaseV ("F32", []); op ] -> F32 (f2 op)
  | [ CaseV ("F64", []); op ] -> F64 (f2 op)
  | l -> fail_list "op" l

let al_to_int_unop: value -> IntOp.unop = function
  | TextV "Clz" -> IntOp.Clz
  | TextV "Ctz" -> IntOp.Ctz
  | TextV "Popcnt" -> IntOp.Popcnt
  | TextV "Extend8S" -> IntOp.ExtendS Pack.Pack8
  | TextV "Extend16S" -> IntOp.ExtendS Pack.Pack16
  | TextV "Extend32S" -> IntOp.ExtendS Pack.Pack32
  | TextV "Extend64S" -> IntOp.ExtendS Pack.Pack64
  | v -> fail "integer unop" v
let al_to_float_unop: value -> FloatOp.unop = function
  | TextV "Neg" -> FloatOp.Neg
  | TextV "Abs" -> FloatOp.Abs
  | TextV "Ceil" -> FloatOp.Ceil
  | TextV "Floor" -> FloatOp.Floor
  | TextV "Trunc" -> FloatOp.Trunc
  | TextV "Nearest" -> FloatOp.Nearest
  | TextV "Sqrt" -> FloatOp.Sqrt
  | v -> fail "float unop" v
let al_to_unop: value list -> Ast.unop = al_to_op al_to_int_unop al_to_float_unop

let al_to_int_binop: value -> IntOp.binop = function
  | TextV "Add" -> IntOp.Add
  | TextV "Sub" -> IntOp.Sub
  | TextV "Mul" -> IntOp.Mul
  | TextV "DivS" -> IntOp.DivS
  | TextV "DivU" -> IntOp.DivU
  | TextV "RemS" -> IntOp.RemS
  | TextV "RemU" -> IntOp.RemU
  | TextV "And" -> IntOp.And
  | TextV "Or" -> IntOp.Or
  | TextV "Xor" -> IntOp.Xor
  | TextV "Shl" -> IntOp.Shl
  | TextV "ShrS" -> IntOp.ShrS
  | TextV "ShrU" -> IntOp.ShrU
  | TextV "Rotl" -> IntOp.Rotl
  | TextV "Rotr" -> IntOp.Rotr
  | v -> fail "integer binop" v
let al_to_float_binop: value -> FloatOp.binop = function
  | TextV "Add" -> FloatOp.Add
  | TextV "Sub" -> FloatOp.Sub
  | TextV "Mul" -> FloatOp.Mul
  | TextV "Div" -> FloatOp.Div
  | TextV "Min" -> FloatOp.Min
  | TextV "Max" -> FloatOp.Max
  | TextV "CopySign" -> FloatOp.CopySign
  | v -> fail "float binop" v
let al_to_binop: value list -> Ast.binop = al_to_op al_to_int_binop al_to_float_binop

let al_to_int_testop: value -> IntOp.testop = function
  | TextV "Eqz" -> IntOp.Eqz
  | v -> fail "integer testop" v
let al_to_testop: value list -> Ast.testop = function
  | [ CaseV ("I32", []); op ] -> Value.I32 (al_to_int_testop op)
  | [ CaseV ("I64", []); op ] -> Value.I64 (al_to_int_testop op)
  | l -> fail_list "testop" l

let al_to_int_relop: value -> IntOp.relop = function
  | TextV "Eq" -> IntOp.Eq
  | TextV "Ne" -> IntOp.Ne
  | TextV "LtS" -> IntOp.LtS
  | TextV "LtU" -> IntOp.LtU
  | TextV "GtS" -> IntOp.GtS
  | TextV "GtU" -> IntOp.GtU
  | TextV "LeS" -> IntOp.LeS
  | TextV "LeU" -> IntOp.LeU
  | TextV "GeS" -> IntOp.GeS
  | TextV "GeU" -> IntOp.GeU
  | v -> fail "integer relop" v
let al_to_float_relop: value -> FloatOp.relop = function
  | TextV "Eq" -> FloatOp.Eq
  | TextV "Ne" -> FloatOp.Ne
  | TextV "Lt" -> FloatOp.Lt
  | TextV "Gt" -> FloatOp.Gt
  | TextV "Le" -> FloatOp.Le
  | TextV "Ge" -> FloatOp.Ge
  | v -> fail "float relop" v
let al_to_relop: value list -> relop = al_to_op al_to_int_relop al_to_float_relop

let al_to_int_cvtop: value list -> IntOp.cvtop = function
  | TextV "Extend" :: args ->
    (match args with
    | [ CaseV ("I32", []); OptV (Some (CaseV ("S", []))) ] -> IntOp.ExtendSI32
    | [ CaseV ("I32", []); OptV (Some (CaseV ("U", []))) ] -> IntOp.ExtendUI32
    | l -> fail_list "extend" l)
  | [ TextV "Wrap"; CaseV ("I64", []); OptV None ] -> IntOp.WrapI64
  | TextV "Trunc" :: args ->
    (match args with
    | [ CaseV ("F32", []); OptV (Some (CaseV ("S", []))) ] -> IntOp.TruncSF32
    | [ CaseV ("F32", []); OptV (Some (CaseV ("U", []))) ] -> IntOp.TruncUF32
    | [ CaseV ("F64", []); OptV (Some (CaseV ("S", []))) ] -> IntOp.TruncSF64
    | [ CaseV ("F64", []); OptV (Some (CaseV ("U", []))) ] -> IntOp.TruncUF64
    | l -> fail_list "trunc" l)
  | TextV "TruncSat" :: args ->
    (match args with
    | [ CaseV ("F32", []); OptV (Some (CaseV ("S", []))) ] -> IntOp.TruncSatSF32
    | [ CaseV ("F32", []); OptV (Some (CaseV ("U", []))) ] -> IntOp.TruncSatUF32
    | [ CaseV ("F64", []); OptV (Some (CaseV ("S", []))) ] -> IntOp.TruncSatSF64
    | [ CaseV ("F64", []); OptV (Some (CaseV ("U", []))) ] -> IntOp.TruncSatUF64
    | l -> fail_list "truncsat" l)
  | [ TextV "Reinterpret"; _; OptV None ] -> IntOp.ReinterpretFloat
  | l -> fail_list "integer cvtop" l
let al_to_float_cvtop : value list -> FloatOp.cvtop = function
  | TextV "Convert" :: args ->
    (match args with
    | [ CaseV ("I32", []); OptV (Some (CaseV (("S", [])))) ] -> FloatOp.ConvertSI32
    | [ CaseV ("I32", []); OptV (Some (CaseV (("U", [])))) ] -> FloatOp.ConvertUI32
    | [ CaseV ("I64", []); OptV (Some (CaseV (("S", [])))) ] -> FloatOp.ConvertSI64
    | [ CaseV ("I64", []); OptV (Some (CaseV (("U", [])))) ] -> FloatOp.ConvertUI64
    | l -> fail_list "convert" l)
  | [ TextV "Promote"; CaseV ("F32", []); OptV None ] -> FloatOp.PromoteF32
  | [ TextV "Demote"; CaseV ("F64", []); OptV None ] -> FloatOp.DemoteF64
  | [ TextV "Reinterpret"; _; OptV None ] -> FloatOp.ReinterpretInt
  | l -> fail_list "float cvtop" l
let al_to_cvtop: value list -> cvtop = function
  | CaseV ("I32", []) :: op -> I32 (al_to_int_cvtop op)
  | CaseV ("I64", []) :: op -> I64 (al_to_int_cvtop op)
  | CaseV ("F32", []) :: op -> F32 (al_to_float_cvtop op)
  | CaseV ("F64", []) :: op -> F64 (al_to_float_cvtop op)
  | l -> fail_list "cvtop" l

let al_to_vop i8 i16 i32 i64 f32 f64 = function
  | [ CaseV ("I8x16", []); vop ] -> V128.I8x16 (i8 vop)
  | [ CaseV ("I16x8", []); vop ] -> V128.I16x8 (i16 vop)
  | [ CaseV ("I32x4", []); vop ] -> V128.I32x4 (i32 vop)
  | [ CaseV ("I64x2", []); vop ] -> V128.I64x2 (i64 vop)
  | [ CaseV ("F32x4", []); vop ] -> V128.F32x4 (f32 vop)
  | [ CaseV ("F64x2", []); vop ] -> V128.F64x2 (f64 vop)
  | l -> fail_list "vop" l

let al_to_ishape_vtestop: value -> V128Op.itestop = function
  | TextV "AllTrue" -> V128Op.AllTrue
  | v -> fail "vector testop" v
let al_to_vtestop: value list -> vec_testop = function
  | [ CaseV ("I8x16", []); vop ] -> V128 (V128.I8x16 (al_to_ishape_vtestop vop))
  | [ CaseV ("I16x8", []); vop ] -> V128 (V128.I16x8 (al_to_ishape_vtestop vop))
  | [ CaseV ("I32x4", []); vop ] -> V128 (V128.I32x4 (al_to_ishape_vtestop vop))
  | [ CaseV ("I64x2", []); vop ] -> V128 (V128.I64x2 (al_to_ishape_vtestop vop))
  | l -> fail_list "vtestop" l

(* Vector operator *)

let al_to_extension : value -> Pack.extension = function
  | CaseV ("S", []) -> Pack.SX
  | CaseV ("U", []) -> Pack.ZX
  | v -> fail "extension" v

let al_to_vop f1 f2 = function
  | [ CaseV ("I8X16", []); vop ] -> V128 (V128.I8x16 (f1 vop))
  | [ CaseV ("I16X8", []); vop ] -> V128 (V128.I16x8 (f1 vop))
  | [ CaseV ("I32X4", []); vop ] -> V128 (V128.I32x4 (f1 vop))
  | [ CaseV ("I64X2", []); vop ] -> V128 (V128.I64x2 (f1 vop))
  | [ CaseV ("F32X4", []); vop ] -> V128 (V128.F32x4 (f2 vop))
  | [ CaseV ("F64X2", []); vop ] -> V128 (V128.F64x2 (f2 vop))
  | l -> fail_list "vop" l

let al_to_viop f1:
    Al.Ast.value list -> ('a, 'a, 'a, 'a, void, void) V128.laneop vecop =
  function
  | [ CaseV ("I8X16", []); vop ] -> V128 (V128.I8x16 (f1 vop))
  | [ CaseV ("I16X8", []); vop ] -> V128 (V128.I16x8 (f1 vop))
  | [ CaseV ("I32X4", []); vop ] -> V128 (V128.I32x4 (f1 vop))
  | [ CaseV ("I64X2", []); vop ] -> V128 (V128.I64x2 (f1 vop))
  | l -> fail_list "vop" l

let al_to_ishape_vtestop : value -> V128Op.itestop = function
  | TextV "AllTrue" -> V128Op.AllTrue
  | v -> fail "vector testop" v

let al_to_vtestop : value list -> vec_testop = function
  | [ CaseV ("I8X16", []); vop ] -> V128 (V128.I8x16 (al_to_ishape_vtestop vop))
  | [ CaseV ("I16X8", []); vop ] -> V128 (V128.I16x8 (al_to_ishape_vtestop vop))
  | [ CaseV ("I32X4", []); vop ] -> V128 (V128.I32x4 (al_to_ishape_vtestop vop))
  | [ CaseV ("I64X2", []); vop ] -> V128 (V128.I64x2 (al_to_ishape_vtestop vop))
  | l -> fail_list "vtestop" l

let al_to_int_vrelop : value -> V128Op.irelop = function
  | v -> (
    match v with
    | CaseV ("_VI", [ CaseV (vop, []) ]) -> (
      match vop with
      | "Eq" -> V128Op.Eq
      | "Ne" -> V128Op.Ne
      | "LtS" -> V128Op.LtS
      | "LtU" -> V128Op.LtU
      | "LeS" -> V128Op.LeS
      | "LeU" -> V128Op.LeU
      | "GtS" -> V128Op.GtS
      | "GtU" -> V128Op.GtU
      | "GeS" -> V128Op.GeS
      | "GeU" -> V128Op.GeU
      | _ -> fail "integer vrelop" v
    )
    | _ -> fail "integer vrelop" v
  )

let al_to_float_vrelop : value -> V128Op.frelop = function
  | v -> (
    match v with
    | CaseV ("_VF", [ CaseV (vop, []) ]) -> (
      match vop with
      | "Eq" -> V128Op.Eq
      | "Ne" -> V128Op.Ne
      | "Lt" -> V128Op.Lt
      | "Le" -> V128Op.Le
      | "Gt" -> V128Op.Gt
      | "Ge" -> V128Op.Ge
      | _ -> fail "float vrelop" v
    )
    | _ -> fail "float vrelop" v
  )

let al_to_vrelop : value list -> vec_relop =
  al_to_vop al_to_int_vrelop al_to_float_vrelop

let al_to_int_vunop : value -> V128Op.iunop = function
  | v -> (
    match v with
    | CaseV ("_VI", [ CaseV (vop, []) ]) -> (
      match vop with
      | "Abs" -> V128Op.Abs
      | "Neg" -> V128Op.Neg
      | "Popcnt" -> V128Op.Popcnt
      | _ -> fail "integer vunop" v
    )
    | _ -> fail "integer vunop" v
  )

let al_to_float_vunop : value -> V128Op.funop = function
  | v -> (
    match v with
    | CaseV ("_VF", [ CaseV (vop, []) ]) -> (
      match vop with
      | "Abs" -> V128Op.Abs
      | "Neg" -> V128Op.Neg
      | "Sqrt" -> V128Op.Sqrt
      | "Ceil" -> V128Op.Ceil
      | "Floor" -> V128Op.Floor
      | "Trunc" -> V128Op.Trunc
      | "Nearest" -> V128Op.Nearest
      | _ -> fail "float vunop" v
    )
    | _ -> fail "float vunop" v
  )

let al_to_vunop : value list -> vec_unop =
  al_to_vop al_to_int_vunop al_to_float_vunop

let al_to_int_vbinop : value -> V128Op.ibinop = function
  | v -> (
    match v with
    | CaseV ("_VI", [ CaseV (vop, []) ]) -> (
      match vop with
      | "Add" -> V128Op.Add
      | "Sub" -> V128Op.Sub
      | "Mul" -> V128Op.Mul
      | "MinS" -> V128Op.MinS
      | "MinU" -> V128Op.MinU
      | "MaxS" -> V128Op.MaxS
      | "MaxU" -> V128Op.MaxU
      | "AvgrU" -> V128Op.AvgrU
      | "AddSatS" -> V128Op.AddSatS
      | "AddSatU" -> V128Op.AddSatU
      | "SubSatS" -> V128Op.SubSatS
      | "SubSatU" -> V128Op.SubSatU
      | "DotS" -> V128Op.DotS
      | "Q15MulRSatS" -> V128Op.Q15MulRSatS
      | "ExtMulLowS" -> V128Op.ExtMulLowS
      | "ExtMulHighS" -> V128Op.ExtMulHighS
      | "ExtMulLowU" -> V128Op.ExtMulLowU
      | "ExtMulHighU" -> V128Op.ExtMulHighU
      | "Swizzle" -> V128Op.Swizzle
      | "NarrowS" -> V128Op.NarrowS
      | "NarrowU" -> V128Op.NarrowU
      | _ -> fail "integer vbinop" v
    )
    | CaseV ("Shuffle", [ l ]) -> V128Op.Shuffle (al_to_list al_to_int l)
    | _ -> fail "integer vbinop" v
  )

let al_to_float_vbinop : value -> V128Op.fbinop = function
  | v -> (
    match v with
    | CaseV ("_VF", [ CaseV (vop, []) ]) -> (
      match vop with
      | "Add" -> V128Op.Add
      | "Sub" -> V128Op.Sub
      | "Mul" -> V128Op.Mul
      | "Div" -> V128Op.Div
      | "Min" -> V128Op.Min
      | "Max" -> V128Op.Max
      | "Pmin" -> V128Op.Pmin
      | "Pmax" -> V128Op.Pmax
      | _ -> fail "float vbinop" v
    )
    | _ -> fail "float vbinop" v
  )

let al_to_vbinop : value list -> vec_binop =
  al_to_vop al_to_int_vbinop al_to_float_vbinop

let al_to_int_vcvtop : value -> V128Op.icvtop = function
  | v -> (
    match v with
    | CaseV ("_VI", [ CaseV (vop, []) ]) -> (
      match vop with
      | "ExtendLowS" -> V128Op.ExtendLowS
      | "ExtendLowU" -> V128Op.ExtendLowU
      | "ExtendHighS" -> V128Op.ExtendHighS
      | "ExtendHighU" -> V128Op.ExtendHighU
      | "ExtAddPairwiseS" -> V128Op.ExtAddPairwiseS
      | "ExtAddPairwiseU" -> V128Op.ExtAddPairwiseU
      | "TruncSatSF32x4" -> V128Op.TruncSatSF32x4
      | "TruncSatUF32x4" -> V128Op.TruncSatUF32x4
      | "TruncSatSZeroF64x2" -> V128Op.TruncSatSZeroF64x2
      | "TruncSatUZeroF64x2" -> V128Op.TruncSatUZeroF64x2
      | _ -> fail "integer vcvtop" v
    )
    | _ -> fail "integer vcvtop" v
  )

let al_to_float_vcvtop : value -> V128Op.fcvtop = function
  | v -> (
    match v with
    | CaseV ("_VF", [ CaseV (vop, []) ]) -> (
      match vop with
      | "DemoteZeroF64x2" -> V128Op.DemoteZeroF64x2
      | "PromoteLowF32x4" -> V128Op.PromoteLowF32x4
      | "ConvertSI32x4" -> V128Op.ConvertSI32x4
      | "ConvertUI32x4" -> V128Op.ConvertUI32x4
      | _ -> fail "float vcvtop" v
    )
    | _ -> fail "float vcvtop" v
  )

let al_to_vcvtop : value list -> vec_cvtop =
  al_to_vop al_to_int_vcvtop al_to_float_vcvtop

let al_to_int_vshiftop : value -> V128Op.ishiftop = function
  | v -> (
    match v with
    | CaseV ("_VI", [ CaseV (vop, []) ]) -> (
      match vop with
      | "Shl" -> V128Op.Shl
      | "ShrS" -> V128Op.ShrS
      | "ShrU" -> V128Op.ShrU
      | _ -> fail "integer vshiftop" v
    )
    | _ -> fail "integer vshiftop" v
  )

let al_to_vshiftop : value list -> vec_shiftop = al_to_viop al_to_int_vshiftop

let al_to_int_vbitmaskop : value -> V128Op.ibitmaskop = function
  | v -> (
    match v with
    | CaseV ("_VI", [ CaseV (vop, []) ]) -> (
      match vop with
      | "Bitmask" -> V128Op.Bitmask
      | _ -> fail "integer vbitmaskop" v
    )
    | _ -> fail "integer vbitmaskop" v
  )

let al_to_vbitmaskop : value list -> vec_bitmaskop =
  al_to_viop al_to_int_vbitmaskop

let al_to_vvtestop : value list -> vec_vtestop = function
  | vl -> (
    match vl with
    | [ CaseV ("V128", []); CaseV ("_VV", [ CaseV (vop, []) ]) ] -> (
      match vop with
      | "AnyTrue" -> V128 V128Op.AnyTrue
      | _ -> fail_list "vvtestop" vl
    )
    | _ -> fail_list "vvtestop" vl
  )

let al_to_vvunop : value list -> vec_vunop = function
  | vl -> (
    match vl with
    | [ CaseV ("V128", []); CaseV ("_VV", [ CaseV (vop, []) ]) ] -> (
      match vop with
      | "Not" -> V128 V128Op.Not
      | _ -> fail_list "vvunop" vl
    )
    | _ -> fail_list "vvunop" vl
  )

let al_to_vvbinop : value list -> vec_vbinop = function
  | vl -> (
    match vl with
    | [ CaseV ("V128", []); CaseV ("_VV", [ CaseV (vop, []) ]) ] -> (
      match vop with
      | "And" -> V128 V128Op.And
      | "Or" -> V128 V128Op.Or
      | "Xor" -> V128 V128Op.Xor
      | "AndNot" -> V128 V128Op.AndNot
      | _ -> fail_list "vvbinop" vl
    )
    | _ -> fail_list "vvbinop" vl
  )

let al_to_vvternop : value list -> vec_vternop = function
  | vl -> (
    match vl with
    | [ CaseV ("V128", []); CaseV ("_VV", [ CaseV (vop, []) ]) ] -> (
      match vop with
      | "Bitselect" -> V128 V128Op.Bitselect
      | _ -> fail_list "vvternop" vl
    )
    | _ -> fail_list "vvternop" vl
  )

let al_to_vsplatop : value list -> vec_splatop = function
  | vl -> (
    match vl with
    | [ CaseV ("I8X16", []) ] -> V128 (V128.I8x16 Splat)
    | _ -> fail_list "vsplatop" vl
  )

let al_to_vextractop : value list -> vec_extractop = function
  | vl -> (
    match vl with
    | [ CaseV ("I8X16", []); OptV (Some ext); n ] ->
        V128 (V128.I8x16 (Extract (al_to_int n, al_to_extension ext)))
    | [ CaseV ("I16X8", []); OptV (Some ext); n ] ->
        V128 (V128.I16x8 (Extract (al_to_int n, al_to_extension ext)))
    | [ CaseV ("I32X4", []); OptV None; n ] ->
        V128 (V128.I32x4 (Extract (al_to_int n, ())))
    | [ CaseV ("I64X2", []); OptV None; n ] ->
        V128 (V128.I64x2 (Extract (al_to_int n, ())))
    | [ CaseV ("F32X4", []); OptV None; n ] ->
        V128 (V128.F32x4 (Extract (al_to_int n, ())))
    | [ CaseV ("F64X2", []); OptV None; n ] ->
        V128 (V128.F64x2 (Extract (al_to_int n, ())))
    | _ -> fail_list "vextractop" vl
  )

let al_to_vreplaceop : value list -> vec_replaceop = function
  | vl -> (
    match vl with
    | [ CaseV ("I8X16", []); n ] -> V128 (V128.I8x16 (Replace (al_to_int n)))
    | [ CaseV ("I16X8", []); n ] -> V128 (V128.I16x8 (Replace (al_to_int n)))
    | [ CaseV ("I32X4", []); n ] -> V128 (V128.I32x4 (Replace (al_to_int n)))
    | [ CaseV ("I64X2", []); n ] -> V128 (V128.I64x2 (Replace (al_to_int n)))
    | [ CaseV ("F32X4", []); n ] -> V128 (V128.F32x4 (Replace (al_to_int n)))
    | [ CaseV ("F64X2", []); n ] -> V128 (V128.F64x2 (Replace (al_to_int n)))
    | _ -> fail_list "vreplaceop" vl
  )

let al_to_pack_size : value -> Pack.pack_size = function
  | NumV 8L -> Pack.Pack8
  | NumV 16L -> Pack.Pack16
  | NumV 32L -> Pack.Pack32
  | NumV 64L -> Pack.Pack64
  | v -> fail "pack_size" v

let al_to_memop (f: value -> 'p) : value list -> (num_type, 'p) memop = function
  | [ nt; p; NumV 0L; StrV str ] ->
    {
      ty = al_to_num_type nt;
      align = Record.find "ALIGN" str |> al_to_int;
      offset = Record.find "OFFSET" str |> al_to_int32;
      pack = f p;
    }
  | v -> fail_list "memop" v

let al_to_pack_size_extension: value -> Pack.pack_size * Pack.extension = function
  | TupV [ p; ext ] -> al_to_pack_size p, al_to_extension ext
  | v -> fail "pack size, extension" v

let al_to_loadop: value list -> loadop = al_to_opt al_to_pack_size_extension |> al_to_memop

let al_to_storeop: value list -> storeop = al_to_opt al_to_pack_size |> al_to_memop

let rec al_to_instr (v: value): Ast.instr = al_to_phrase al_to_instr' v
and al_to_instr' : value -> Ast.instr' = function
(* wasm values *)
| CaseV ("CONST", _) as v -> Const (al_to_phrase al_to_num v)
| CaseV ("VVCONST", _) as v -> VecConst (al_to_phrase al_to_vec v)
| CaseV ("REF.NULL", [ ht ]) -> RefNull (al_to_heap_type ht)
(* wasm instructions *)
| CaseV ("UNREACHABLE", []) -> Unreachable
| CaseV ("NOP", []) -> Nop
| CaseV ("DROP", []) -> Drop
| CaseV ("UNOP", op) -> Unary (al_to_unop op)
| CaseV ("BINOP", op) -> Binary (al_to_binop op)
| CaseV ("TESTOP", op) -> Test (al_to_testop op)
| CaseV ("RELOP", op) -> Compare (al_to_relop op)
| CaseV ("CVTOP", op) -> Convert (al_to_cvtop op)
| CaseV ("ALL_TRUE", vop) -> VecTest (al_to_vtestop vop)
| CaseV ("VRELOP", vop) -> VecCompare (al_to_vrelop vop)
| CaseV ("VUNOP", vop) -> VecUnary (al_to_vunop vop)
| CaseV ("VBINOP", vop) -> VecBinary (al_to_vbinop vop)
| CaseV ("VCVTOP", vop) -> VecConvert (al_to_vcvtop vop)
| CaseV ("VISHIFTOP", vop) -> VecShift (al_to_vshiftop vop)
| CaseV ("BITMASK", vop) -> VecBitmask (al_to_vbitmaskop vop)
| CaseV ("VVTESTOP", vop) -> VecTestBits (al_to_vvtestop vop)
| CaseV ("VVUNOP", vop) -> VecUnaryBits (al_to_vvunop vop)
| CaseV ("VVBINOP", vop) -> VecBinaryBits (al_to_vvbinop vop)
| CaseV ("VVTERNOP", vop) -> VecTernaryBits (al_to_vvternop vop)
| CaseV ("SPLAT", vop) -> VecSplat (al_to_vsplatop vop)
| CaseV ("EXTRACT_LANE", vop) -> VecExtract (al_to_vextractop vop)
| CaseV ("REPLACE_LANE", vop) -> VecReplace (al_to_vreplaceop vop)
| CaseV ("REF.IS_NULL", []) -> RefIsNull
  | CaseV ("REF.FUNC", [ idx ]) -> RefFunc (al_to_idx idx)
  | CaseV ("SELECT", [ vtl_opt ]) -> Select (al_to_opt (al_to_list al_to_val_type) vtl_opt)
  | CaseV ("LOCAL.GET", [ idx ]) -> LocalGet (al_to_idx idx)
  | CaseV ("LOCAL.SET", [ idx ]) -> LocalSet (al_to_idx idx)
  | CaseV ("LOCAL.TEE", [ idx ]) -> LocalTee (al_to_idx idx)
  | CaseV ("GLOBAL.GET", [ idx ]) -> GlobalGet (al_to_idx idx)
  | CaseV ("GLOBAL.SET", [ idx ]) -> GlobalSet (al_to_idx idx)
  | CaseV ("TABLE.GET", [ idx ]) -> TableGet (al_to_idx idx)
  | CaseV ("TABLE.SET", [ idx ]) -> TableSet (al_to_idx idx)
  | CaseV ("TABLE.SIZE", [ idx ]) -> TableSize (al_to_idx idx)
  | CaseV ("TABLE.GROW", [ idx ]) -> TableGrow (al_to_idx idx)
  | CaseV ("TABLE.FILL", [ idx ]) -> TableFill (al_to_idx idx)
  | CaseV ("TABLE.COPY", [ idx1; idx2 ]) -> TableCopy (al_to_idx idx1, al_to_idx idx2)
  | CaseV ("TABLE.INIT", [ idx1; idx2 ]) -> TableInit (al_to_idx idx1, al_to_idx idx2)
  | CaseV ("ELEM.DROP", [ idx ]) -> ElemDrop (al_to_idx idx)
  | CaseV ("BLOCK", [ bt; instrs ]) ->
    Block (al_to_block_type bt, al_to_list al_to_instr instrs)
  | CaseV ("LOOP", [ bt; instrs ]) ->
    Loop (al_to_block_type bt, al_to_list al_to_instr instrs)
  | CaseV ("IF", [ bt; instrs1; instrs2 ]) ->
    If (al_to_block_type bt, al_to_list al_to_instr instrs1, al_to_list al_to_instr instrs2)
  | CaseV ("BR", [ idx ]) -> Br (al_to_idx idx)
  | CaseV ("BR_IF", [ idx ]) -> BrIf (al_to_idx idx)
  | CaseV ("BR_TABLE", [ idxs; idx ]) -> BrTable (al_to_list al_to_idx idxs, al_to_idx idx)
  | CaseV ("BR_ON_NULL", [ idx ]) -> BrOnNull (al_to_idx idx)
  | CaseV ("BR_ON_NON_NULL", [ idx ]) -> BrOnNonNull (al_to_idx idx)
  | CaseV ("BR_ON_CAST", [ idx; rt1; rt2 ]) ->
    BrOnCast (al_to_idx idx, al_to_ref_type rt1, al_to_ref_type rt2)
  | CaseV ("BR_ON_CAST_FAIL", [ idx; rt1; rt2 ]) ->
    BrOnCastFail (al_to_idx idx, al_to_ref_type rt1, al_to_ref_type rt2)
  | CaseV ("RETURN", []) -> Return
  | CaseV ("CALL", [ idx ]) -> Call (al_to_idx idx)
  | CaseV ("CALL_REF", [ OptV (Some idx) ]) -> CallRef (al_to_idx idx)
  | CaseV ("CALL_INDIRECT", [ idx1; idx2 ]) ->
    CallIndirect (al_to_idx idx1, al_to_idx idx2)
  | CaseV ("RETURN_CALL", [ idx ]) -> ReturnCall (al_to_idx idx)
  | CaseV ("RETURN_CALL_REF", [ OptV (Some idx) ]) -> ReturnCallRef (al_to_idx idx)
  | CaseV ("RETURN_CALL_INDIRECT", [ idx1; idx2 ]) ->
    ReturnCallIndirect (al_to_idx idx1, al_to_idx idx2)
  | CaseV ("LOAD", loadop) -> Load (al_to_loadop loadop)
  | CaseV ("STORE", storeop) -> Store (al_to_storeop storeop)
  | CaseV ("MEMORY.SIZE", [ NumV 0L ]) -> MemorySize
  | CaseV ("MEMORY.GROW", [ NumV 0L ]) -> MemoryGrow
  | CaseV ("MEMORY.FILL", [ NumV 0L ]) -> MemoryFill
  | CaseV ("MEMORY.COPY", [ NumV 0L; NumV 0L ]) -> MemoryCopy
  | CaseV ("MEMORY.INIT", [ NumV 0L; idx ]) -> MemoryInit (al_to_idx idx)
  | CaseV ("DATA.DROP", [ idx ]) -> DataDrop (al_to_idx idx)
  | CaseV ("REF.AS_NON_NULL", []) -> RefAsNonNull
  | CaseV ("REF.TEST", [ rt ]) -> RefTest (al_to_ref_type rt)
  | CaseV ("REF.CAST", [ rt ]) -> RefCast (al_to_ref_type rt)
  | CaseV ("REF.EQ", []) -> RefEq
  | CaseV ("REF.I31", []) -> RefI31
  | CaseV ("I31.GET", [ ext ]) -> I31Get (al_to_extension ext)
  | CaseV ("STRUCT.NEW", [ idx ]) -> StructNew (al_to_idx idx, Explicit)
  | CaseV ("STRUCT.NEW_DEFAULT", [ idx ]) -> StructNew (al_to_idx idx, Implicit)
  | CaseV ("STRUCT.GET", [ ext_opt; idx1; idx2 ]) ->
    StructGet (al_to_idx idx1, al_to_idx idx2, al_to_opt al_to_extension ext_opt)
  | CaseV ("STRUCT.SET", [ idx1; idx2 ]) -> StructSet (al_to_idx idx1, al_to_idx idx2)
  | CaseV ("ARRAY.NEW", [ idx ]) -> ArrayNew (al_to_idx idx, Explicit)
  | CaseV ("ARRAY.NEW_DEFAULT", [ idx ]) -> ArrayNew (al_to_idx idx, Implicit)
  | CaseV ("ARRAY.NEW_FIXED", [ idx; i32 ]) ->
    ArrayNewFixed (al_to_idx idx, al_to_int32 i32)
  | CaseV ("ARRAY.NEW_ELEM", [ idx1; idx2 ]) ->
    ArrayNewElem (al_to_idx idx1, al_to_idx idx2)
  | CaseV ("ARRAY.NEW_DATA", [ idx1; idx2 ]) ->
    ArrayNewData (al_to_idx idx1, al_to_idx idx2)
  | CaseV ("ARRAY.GET", [ ext_opt; idx ]) ->
    ArrayGet (al_to_idx idx, al_to_opt al_to_extension ext_opt)
  | CaseV ("ARRAY.SET", [ idx ]) -> ArraySet (al_to_idx idx)
  | CaseV ("ARRAY.LEN", []) -> ArrayLen
  | CaseV ("ARRAY.COPY", [ idx1; idx2 ]) -> ArrayCopy (al_to_idx idx1, al_to_idx idx2)
  | CaseV ("ARRAY.FILL", [ idx ]) -> ArrayFill (al_to_idx idx)
  | CaseV ("ARRAY.INIT_DATA", [ idx1; idx2 ]) ->
    ArrayInitData (al_to_idx idx1, al_to_idx idx2)
  | CaseV ("ARRAY.INIT_ELEM", [ idx1; idx2 ]) ->
    ArrayInitElem (al_to_idx idx1, al_to_idx idx2)
  | CaseV ("ANY.CONVERT_EXTERN", []) -> ExternConvert Internalize
  | CaseV ("EXTERN.CONVERT_ANY", []) -> ExternConvert Externalize
  | v -> fail "instrunction" v

let al_to_const: value -> const = al_to_list al_to_instr |> al_to_phrase


(* Deconstruct module *)

let al_to_type: value -> type_ = function
  | CaseV ("TYPE", [ rt ]) -> al_to_phrase al_to_rec_type rt
  | v -> fail "type" v

let al_to_local': value -> local' = function
  | CaseV ("LOCAL", [ vt ]) -> { ltype = al_to_val_type vt }
  | v -> fail "local" v
let al_to_local: value -> local = al_to_phrase al_to_local'

let al_to_func': value -> func' = function
  | CaseV ("FUNC", [ idx; locals; instrs ]) ->
    {
      ftype = al_to_idx idx;
      locals = al_to_list al_to_local locals;
      body = al_to_list al_to_instr instrs;
    }
  | v -> fail "func" v
let al_to_func: value -> func = al_to_phrase al_to_func'

let al_to_global': value -> global' = function
  | CaseV ("GLOBAL", [ gt; const ]) ->
    { gtype = al_to_global_type gt; ginit = al_to_const const }
  | v -> fail "global" v
let al_to_global: value -> global = al_to_phrase al_to_global'

let al_to_table': value -> table' = function
  | CaseV ("TABLE", [ tt; const ]) ->
    { ttype = al_to_table_type tt; tinit = al_to_const const }
  | v -> fail "table" v
let al_to_table: value -> table = al_to_phrase al_to_table'

let al_to_memory': value -> memory' = function
  | CaseV ("MEMORY", [ mt ]) -> { mtype = al_to_memory_type mt }
  | v -> fail "memory" v
let al_to_memory: value -> memory = al_to_phrase al_to_memory'

let al_to_segment': value -> segment_mode' = function
  | CaseV ("PASSIVE", []) -> Passive
  | CaseV ("ACTIVE", [ idx; const ]) ->
    Active { index = al_to_idx idx; offset = al_to_const const }
  | CaseV ("DECLARE", []) -> Declarative
  | v -> fail "segment mode" v
let al_to_segment: value -> segment_mode = al_to_phrase al_to_segment'

let al_to_elem': value -> elem_segment' = function
  | CaseV ("ELEM", [ rt; consts; seg ]) ->
    {
      etype = al_to_ref_type rt;
      einit = al_to_list al_to_const consts;
      emode = al_to_segment seg
    }
  | v -> fail "elem segment" v
let al_to_elem: value -> elem_segment = al_to_phrase al_to_elem'

let al_to_data': value -> data_segment' = function
  | CaseV ("DATA", [ bytes_; seg ]) ->
    { dinit = al_to_bytes bytes_; dmode = al_to_segment seg }
  | v -> fail "data segment" v
let al_to_data: value -> data_segment = al_to_phrase al_to_data'

  (*

let al_to_import_desc module_ idesc =
  match idesc.it with
  | FuncImport x ->
      let dts = def_types_of module_ in
      let dt = Lib.List32.nth dts x.it |> al_to_def_type in
      CaseV ("FUNC", [ dt ])
  | TableImport tt -> CaseV ("TABLE", [ al_to_table_type tt ])
  | MemoryImport mt -> CaseV ("MEM", [ al_to_memory_type mt ])
  | GlobalImport gt -> CaseV ("GLOBAL", [ al_to_global_type gt ])

let al_to_import module_ import =
  CaseV ("IMPORT", [
    al_to_name import.it.module_name;
    al_to_name import.it.item_name;
    al_to_import_desc module_ import.it.idesc;
  ])
  *)

let al_to_export_desc': value -> export_desc' = function
  | CaseV ("FUNC", [ idx ]) -> FuncExport (al_to_idx idx)
  | CaseV ("TABLE", [ idx ]) -> TableExport (al_to_idx idx)
  | CaseV ("MEM", [ idx ]) -> MemoryExport (al_to_idx idx)
  | CaseV ("GLOBAL", [ idx ]) -> GlobalExport (al_to_idx idx)
  | v -> fail "export desc" v
let al_to_export_desc: value -> export_desc = al_to_phrase al_to_export_desc'

let al_to_start': value -> start' = function
  | CaseV ("START", [ idx ]) -> { sfunc = al_to_idx idx }
  | v -> fail "start" v
let al_to_start: value -> start = al_to_phrase al_to_start'

let al_to_export': value -> export' = function
  | CaseV ("EXPORT", [ name; ed ]) ->
    { name = al_to_name name; edesc = al_to_export_desc ed }
  | v -> fail "export" v
let al_to_export: value -> export = al_to_phrase al_to_export'

let al_to_module': value -> module_' = function
  | CaseV ("MODULE", [
    types; _imports; funcs; globals; tables; memories; elems; datas; start; exports
  ]) ->
    {
      types = al_to_list al_to_type types;
      (* TODO: imports = al_to_list (al_to_import module_) imports;*)
      imports = [];
      funcs = al_to_list al_to_func funcs;
      globals = al_to_list al_to_global globals;
      tables = al_to_list al_to_table tables;
      memories = al_to_list al_to_memory memories;
      elems = al_to_list al_to_elem elems;
      datas = al_to_list al_to_data datas;
      start = al_to_opt al_to_start start;
      exports = al_to_list al_to_export exports;
    }
  | v -> fail "module" v
let al_to_module: value -> module_ = al_to_phrase al_to_module'
