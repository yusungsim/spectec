open Ast

module Map : Map.S with type key = string with type 'a t = 'a Map.Make(String).t

type subst = {varid : exp Map.t; typid : typ Map.t}
type t = subst

val empty : subst
val union : subst -> subst -> subst (* right overrides *)

val add_varid : subst -> id -> exp -> subst
val add_typid : subst -> id -> typ -> subst

val mem_varid : subst -> id -> bool
val mem_typid : subst -> id -> bool

val subst_iter : subst -> iter -> iter
val subst_typ : subst -> typ -> typ
val subst_exp : subst -> exp -> exp
val subst_path : subst -> path -> path
val subst_prem : subst -> prem -> prem
val subst_arg : subst -> arg -> arg
val subst_param : subst -> param -> param
val subst_deftyp : subst -> deftyp -> deftyp
val subst_typcase : subst -> typcase -> typcase
val subst_typfield : subst -> typfield -> typfield
val subst_typbind : subst -> id * typ -> id * typ

val subst_args : subst -> arg list -> arg list
val subst_binds : subst -> bind list -> bind list * subst
val subst_params : subst -> param list -> param list * subst

val subst_list : (subst -> 'a -> 'a) -> subst -> 'a list -> 'a list
