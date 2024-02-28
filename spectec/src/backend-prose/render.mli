open Al.Ast


(* Environment *)

type env

val env : Config.t -> string list -> string list -> Backend_latex.Render.env -> El.Ast.script -> Prose.prose -> env


(* Generators *)

val gen_macro : env -> unit

val render_expr : env -> expr -> string
val render_al_instr : env -> id -> int ref -> int -> instr -> string
val render_prose_instr : env -> int -> Prose.instr -> string
val render_def : env -> Prose.def -> string
val render_prose : env -> Prose.prose -> string
