open Util
open Source
open Ast


let filter_nl xs = List.filter_map (function Nl -> None | Elem x -> Some x) xs
let find_nl_list f xs = List.find_opt f (filter_nl xs)
let iter_nl_list f xs = List.iter f (filter_nl xs)
let map_filter_nl_list f xs = List.map f (filter_nl xs)
let map_nl_list f xs = List.map (function Nl -> Nl | Elem x -> Elem (f x)) xs
let concat_map_nl_list f xs = List.concat_map (function Nl -> [Nl] | Elem x -> f x) xs


let strip_var_suffix id =
  match String.index_opt id.it '_', String.index_opt id.it '\'' with
  | None, None -> id
  | None, Some n | Some n, None -> String.sub id.it 0 n $ id.at
  | Some n1, Some n2 -> String.sub id.it 0 (min n1 n2) $ id.at


let arg_of_exp e =
  ref (ExpA e) $ e.at


let rec typ_of_exp e =
  (match e.it with
  | VarE (id, []) ->
    (match id.it with
    | "bool" -> BoolT
    | "nat" -> NumT NatT
    | "int" -> NumT IntT
    | "rat" -> NumT RatT
    | "real" -> NumT RealT
    | "text" -> TextT
    | _ -> VarT (id, [])
    )
  | VarE (id, args) -> VarT (id, args)
  | ParenE (e1, _) -> ParenT (typ_of_exp e1)
  | TupE es -> TupT (List.map typ_of_exp es)
  | IterE (e1, iter) -> IterT (typ_of_exp e1, iter)
  | StrE efs -> StrT (map_nl_list typfield_of_expfield efs)
  | AtomE atom -> AtomT atom
  | SeqE es -> SeqT (List.map typ_of_exp es)
  | InfixE (e1, atom, e2) -> InfixT (typ_of_exp e1, atom, typ_of_exp e2)
  | BrackE (l, e1, r) -> BrackT (l, typ_of_exp e1, r)
  | _ -> Source.error e.at "syntax" "malformed type"
  ) $ e.at

and typfield_of_expfield (atom, e) =
  (atom, (typ_of_exp e, []), [])


let rec exp_of_typ t =
  (match t.it with
  | VarT (id, args) -> VarE (id, args)
  | BoolT -> VarE ("bool" $ t.at, [])
  | NumT NatT -> VarE ("nat" $ t.at, [])
  | NumT IntT -> VarE ("int" $ t.at, [])
  | NumT RatT -> VarE ("rat" $ t.at, [])
  | NumT RealT -> VarE ("real" $ t.at, [])
  | TextT -> VarE ("text" $ t.at, [])
  | ParenT t1 -> ParenE (exp_of_typ t1, false)
  | TupT ts -> TupE (List.map exp_of_typ ts)
  | IterT (t1, iter) -> IterE (exp_of_typ t1, iter)
  | StrT tfs -> StrE (map_nl_list expfield_of_typfield tfs)
  | AtomT atom -> AtomE atom
  | SeqT ts -> SeqE (List.map exp_of_typ ts)
  | InfixT (t1, atom, t2) -> InfixE (exp_of_typ t1, atom, exp_of_typ t2)
  | BrackT (l, t1, r) -> BrackE (l, exp_of_typ t1, r)
  | CaseT _ | RangeT _ -> Source.error t.at "syntax" "malformed expression"
  ) $ t.at

and expfield_of_typfield (atom, (t, _prems), _) =
  (atom, exp_of_typ t)


let rec sym_of_exp e =
  (match e.it with
  | VarE (id, args) -> VarG (id, args)
  | AtomE (Atom id) -> VarG (id $ e.at, [])  (* for uppercase grammar ids in show hints *)
  | NatE (op, n) -> NatG (op, n)
  | TextE s -> TextG s
  | EpsE -> EpsG
  | SeqE es -> SeqG (List.map (fun e -> Elem (sym_of_exp e)) es)
  | ParenE (e1, _) -> ParenG (sym_of_exp e1)
  | TupE es -> TupG (List.map sym_of_exp es)
  | IterE (e1, iter) -> IterG (sym_of_exp e1, iter)
  | TypE (e1, t) -> AttrG (e1, sym_of_exp (exp_of_typ t))
  | FuseE (e1, e2) -> FuseG (sym_of_exp e1, sym_of_exp e2)
  | _ -> ArithG e
  ) $ e.at

let rec exp_of_sym g =
  (match g.it with
  | VarG (id, args) -> VarE (id, args)
  | NatG (op, n) -> NatE (op, n)
  | TextG t -> TextE t
  | EpsG -> EpsE
  | SeqG gs -> SeqE (map_filter_nl_list exp_of_sym gs)
  | ParenG g1 -> ParenE (exp_of_sym g1, false)
  | TupG gs -> TupE (List.map exp_of_sym gs)
  | IterG (g1, iter) -> IterE (exp_of_sym g1, iter)
  | ArithG e -> e.it
  | AttrG (e, g2) -> TypE (e, typ_of_exp (exp_of_sym g2))
  | FuseG (g1, g2) -> FuseE (exp_of_sym g1, exp_of_sym g2)
  | _ -> Source.error g.at "syntax" "malformed expression"
  ) $ g.at


let exp_of_arg a =
  match !(a.it) with
  | ExpA e -> e
  | _ -> Source.error a.at "syntax" "malformed expression"

let param_of_arg a =
  (match !(a.it) with
  | ExpA e -> ExpP ("" $ e.at, typ_of_exp e)
  | SynA {it = VarT (id, []); _} -> SynP id
  | GramA {it = AttrG ({it = VarE (id, []); _}, g); _} ->
    GramP (id, typ_of_exp (exp_of_sym g))
  | _ -> Source.error a.at "syntax" "malformed grammar"
  ) $ a.at

let arg_of_param p =
  (match p.it with
  | ExpP (id, t) -> ExpA (TypE(VarE (id, []) $ id.at, t) $ p.at)
  | SynP id -> SynA (VarT (id, []) $ id.at)
  | GramP (id, _t) -> GramA (VarG (id, []) $ id.at)
  ) |> ref $ p.at
