open Util
open Source
open Ast

module type Arg =
sig
  val visit_atom : atom -> unit
  val visit_typid : id -> unit
  val visit_gramid : id -> unit
  val visit_relid : id -> unit
  val visit_ruleid : id -> unit
  val visit_varid : id -> unit
  val visit_defid : id -> unit

  val visit_typ : typ -> unit
  val visit_exp : exp -> unit
  val visit_path : path -> unit
  val visit_prem : prem -> unit
  val visit_sym : sym -> unit
  val visit_def : def -> unit

  val visit_hint : hint -> unit
end

module Skip =
struct
  let visit_atom _ = ()
  let visit_typid _ = ()
  let visit_gramid _ = ()
  let visit_relid _ = ()
  let visit_ruleid _ = ()
  let visit_varid _ = ()
  let visit_defid _ = ()

  let visit_typ _ = ()
  let visit_exp _ = ()
  let visit_path _ = ()
  let visit_prem _ = ()
  let visit_sym _ = ()
  let visit_def _ = ()

  let visit_hint _ = ()
end


module Make(X : Arg) =
struct
open X

let opt = Option.iter
let list = List.iter

let nl_elem f = function Nl -> () | Elem x -> f x
let nl_list f = list (nl_elem f)


(* Identifiers, operators, literals *)

let bool _b = ()
let nat _n = ()
let text _s = ()

let atom at = visit_atom at
let typid x = visit_typid x
let gramid x = visit_gramid x
let relid x = visit_relid x
let ruleid x = visit_ruleid x
let varid x = visit_varid x
let defid x = visit_defid x

let natop _op = ()
let unop _op = ()
let binop _op = ()
let cmpop _op = ()

let hint h = visit_hint h
let hints = list hint


(* Iterations *)

let rec iter it =
  match it with
  | Opt | List | List1 -> ()
  | ListN (e, xo) -> exp e; opt varid xo


(* Types *)

and dots _ = ()
and numtyp _t = ()

and typ t =
  visit_typ t;
  match t.it with
  | VarT (x, as_) -> typid x; args as_
  | BoolT | TextT -> ()
  | NumT nt -> numtyp nt
  | ParenT t1 -> typ t1
  | TupT ts -> list typ ts
  | IterT (t1, it) -> typ t1; iter it
  | StrT tfs -> nl_list typfield tfs
  | CaseT (dots1, ts, tcs, dots2) ->
    dots dots1; nl_list typ ts; nl_list typcase tcs; dots dots2
  | RangeT tes -> nl_list typenum tes
  | AtomT at -> atom at
  | SeqT ts -> list typ ts
  | InfixT (t1, at, t2) -> typ t1; atom at; typ t2
  | BrackT (at1, t1, at2) -> atom at1; typ t1; atom at2

and typfield (at, (t, prs), hs) = atom at; typ t; prems prs; hints hs
and typcase (at, (t, prs), hs) = atom at; typ t; prems prs; hints hs
and typenum (e, eo) = exp e; opt exp eo


(* Expressions *)

and exp e =
  visit_exp e;
  match e.it with
  | VarE (x, as_) -> varid x; args as_
  | BoolE b -> bool b
  | NatE (op, n) -> natop op; nat n
  | TextE s -> text s
  | EpsE | HoleE _ -> ()
  | UnE (op, e1) -> unop op; exp e1
  | LenE e1 | ParenE (e1, _) -> exp e1
  | DotE (e1, at) -> exp e1; atom at
  | SizeE x -> gramid x
  | BinE (e1, op, e2) -> exp e1; binop op; exp e2
  | CmpE (e1, op, e2) -> exp e1; cmpop op; exp e2
  | IdxE (e1, e2) | CommaE (e1, e2) | CompE (e1, e2)
  | FuseE (e1, e2) -> exp e1; exp e2
  | SliceE (e1, e2, e3) -> exp e1; exp e2; exp e3
  | SeqE es | TupE es -> list exp es
  | UpdE (e1, p, e2) | ExtE (e1, p, e2) -> exp e1; path p; exp e2
  | StrE efs -> nl_list expfield efs
  | CallE (x, as_) -> defid x; args as_
  | IterE (e1, it) -> exp e1; iter it
  | TypE (e1, t) -> exp e1; typ t
  | AtomE at -> atom at
  | InfixE (e1, at1, e2) -> exp e1; atom at1; exp e2
  | BrackE (at1, e1, at2) -> atom at1; exp e1; atom at2

and expfield (_, e) = exp e

and path p =
  visit_path p;
  match p.it with
  | RootP -> ()
  | IdxP (p1, e) -> path p1; exp e
  | SliceP (p1, e1, e2) -> path p1; exp e1; exp e2
  | DotP (p1, at) -> path p1; atom at


(* Premises *)

and prem pr =
  visit_prem pr;
  match pr.it with
  | VarPr (x, t) -> varid x; typ t
  | RulePr (x, e) -> relid x; exp e
  | IfPr e -> exp e
  | ElsePr -> ()
  | IterPr (pr1, it) -> prem pr1; iter it

and prems prs = nl_list prem prs


(* Grammars *)

and sym g =
  visit_sym g;
  match g.it with
  | VarG (x, as_) -> gramid x; args as_
  | NatG (op, n) -> natop op; nat n
  | TextG s -> text s
  | EpsG -> ()
  | SeqG gs | AltG gs -> nl_list sym gs
  | RangeG (g1, g2) | FuseG (g1, g2) -> sym g1; sym g2
  | ParenG g1 -> sym g1
  | TupG gs -> list sym gs
  | IterG (g1, it) -> sym g1; iter it
  | ArithG e -> exp e
  | AttrG (e, g1) -> exp e; sym g1

and prod pr =
  let (g, e, prs) = pr.it in
  sym g; exp e; prems prs

and gram gr =
  let (dots1, prs, dots2) = gr.it in
  dots dots1; nl_list prod prs; dots dots2


(* Definitions *)

and arg a =
  match !(a.it) with
  | ExpA e -> exp e
  | TypA t -> typ t
  | GramA g -> sym g

and param p =
  match p.it with
  | ExpP (x, t) -> varid x; typ t
  | TypP x -> typid x
  | GramP (x, t) -> gramid x; typ t

and args as_ = list arg as_
and params ps = list param ps

let hintdef d =
  match d.it with
  | AtomH (x, hs) -> varid x; hints hs
  | TypH (x1, x2, hs) -> typid x1; ruleid x2; hints hs
  | GramH (x1, x2, hs) -> gramid x1; ruleid x2; hints hs
  | RelH (x, hs) -> relid x; hints hs
  | VarH (x, hs) -> varid x; hints hs
  | DecH (x, hs) -> defid x; hints hs

let def d =
  visit_def d;
  match d.it with
  | FamD (x, ps, hs) -> typid x; params ps; hints hs
  | TypD (x1, x2, as_, t, hs) -> typid x1; ruleid x2; args as_; typ t; hints hs
  | GramD (x1, x2, ps, t, gr, hs) -> typid x1; ruleid x2; params ps; typ t; gram gr; hints hs
  | VarD (x, t, hs) -> varid x; typ t; hints hs
  | SepD -> ()
  | RelD (x, t, hs) -> relid x; typ t; hints hs
  | RuleD (x1, x2, e, prs) -> relid x1; ruleid x2; exp e; prems prs
  | DecD (x, ps, t, hs) -> defid x; params ps; typ t; hints hs
  | DefD (x, as_, e, prs) -> defid x; args as_; exp e; prems prs
  | HintD hd -> hintdef hd
end
