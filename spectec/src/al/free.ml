open Ast
open Util
open Source

(* TODO: Change list to set *)
module IdSet = Set.Make (String)

(* Expressions *)

let (@) = IdSet.union
let free_opt free_x xo = Option.(value (map free_x xo) ~default:IdSet.empty)
let free_list free_x xs = List.(fold_left IdSet.union IdSet.empty (map free_x xs))

let rec free_expr expr =
  match expr.it with
  | NumE _
  | BoolE _
  | GetCurLabelE
  | GetCurContextE
  | GetCurFrameE
  | YetE _ -> IdSet.empty
  | VarE id
  | SubE (id, _) -> IdSet.singleton id
  | UnE (_, e)
  | LenE e
  | ArityE e
  | ContE e -> free_expr e
  | BinE (_, e1, e2)
  | CatE (e1, e2)
  | InfixE (e1, _, e2)
  | LabelE (e1, e2) -> free_expr e1 @ free_expr e2
  | FrameE (e_opt, e) -> free_opt free_expr e_opt @ free_expr e
  | CallE (_, el)
  | TupE el
  | ListE el
  | CaseE (_, el) -> free_list free_expr el
  | StrE r -> free_list (fun (_, e) -> free_expr !e) r
  | AccE (e, p) -> free_expr e @ free_path p
  | ExtE (e1, ps, e2, _)
  | UpdE (e1, ps, e2) -> free_expr e1 @ free_list free_path ps @ free_expr e2
  | OptE e_opt -> free_opt free_expr e_opt
  | IterE (e, _, i) -> free_expr e @ free_iter i
  | MatchE (e1, e2) -> free_expr e1 @ free_expr e2
  | TopLabelE
  | TopFrameE
  | TopValueE None -> IdSet.empty
  | ContextKindE (_, e)
  | IsDefinedE e
  | IsCaseOfE (e, _)
  | HasTypeE (e, _)
  | IsValidE e
  | TopValueE (Some e)
  | TopValuesE e -> free_expr e


(* Iters *)

and free_iter = function
  | Opt
  | List
  | List1 -> IdSet.empty
  | ListN (e, id_opt) -> free_opt IdSet.singleton id_opt @ free_expr e


(* Paths *)

and free_path path =
  match path.it with
  | IdxP e -> free_expr e
  | SliceP (e1, e2) -> free_expr e1 @ free_expr e2
  | DotP _ -> IdSet.empty


(* Instructions *)

let rec free_instr instr =
  match instr.it with
  | IfI (e, il1, il2) -> free_expr e @ free_list free_instr il1 @ free_list free_instr il2
  | OtherwiseI il -> free_list free_instr il
  | EitherI (il1, il2) -> free_list free_instr il1 @ free_list free_instr il2
  | TrapI | NopI | ReturnI None | ExitI | YetI _ -> IdSet.empty
  | PushI e | PopI e | PopAllI e | ReturnI (Some e)
  | ExecuteI e | ExecuteSeqI e ->
    free_expr e
  | LetI (e1, e2) | AppendI (e1, e2) -> free_expr e1 @ free_expr e2
  | EnterI (e1, e2, il) -> free_expr e1 @ free_expr e2 @ free_list free_instr il
  | AssertI e -> free_expr e
  | PerformI (_, el) -> free_list free_expr el
  | ReplaceI (e1, p, e2) -> free_expr e1 @ free_path p @ free_expr e2
