open Util.Source


(* Terminals *)

type nat = int
type text = string
type id = string phrase

type atom =
  | Atom of string               (* atomid *)
  | Bot                          (* `_|_` *)
  | Dot                          (* `.` *)
  | Dot2                         (* `..` *)
  | Dot3                         (* `...` *)
  | Semicolon                    (* `;` *)
  | Arrow                        (* `->` *)
  | Colon                        (* `:` *)
  | Sub                          (* `<:` *)
  | SqArrow                      (* `~>` *)
  | Turnstile                    (* `|-` *)
  | Tilesturn                    (* `-|` *)

type brack =
  | Paren                        (* ``(` ... `)` *)
  | Brack                        (* ``[` ... `]` *)
  | Brace                        (* ``{` ... `}` *)


(* Iteration *)

type iter =
  | Opt                          (* `?` *)
  | List                         (* `*` *)
  | List1                        (* `+` *)
  | ListN of exp                 (* `^` exp *)


(* Types *)

and typ = typ' phrase
and typ' =
  | VarT of id                   (* varid *)
  | BoolT                        (* `bool` *)
  | NatT                         (* `nat` *)
  | TextT                        (* `text` *)
  | ParenT of typ                (* `(` typ `)` *)
  | TupT of typ list             (* `(` list2(typ, `,`) `)` *)
  | IterT of typ * iter          (* typ iter *)

and deftyp = deftyp' phrase
and deftyp' =
  | NotationT of nottyp                    (* nottyp *)
  | StructT of typfield list               (* `{` list(typfield,`,`') `}` *)
  | VariantT of id list * typcase list     (* `|` list(varid|typcase, `|`) *)

and nottyp = nottyp' phrase
and nottyp' =
  | TypT of typ
  | AtomT of atom                          (* atom *)
  | SeqT of nottyp list                    (* `epsilon` / nottyp nottyp *)
  | InfixT of nottyp * atom * nottyp       (* nottyp atom nottyp *)
  | BrackT of brack * nottyp               (* ``` ([{ nottyp }]) *)
  | ParenNT of nottyp                      (* `(` nottyp `)` *)
  | IterNT of nottyp * iter                (* nottyp iter *)

and typfield = atom * typ * hint list         (* atom typ hint* *)
and typcase = atom * nottyp list * hint list  (* atom nottyp* hint* *)


(* Expressions *)

and unop =
  | NotOp   (* `~` *)
  | PlusOp  (* `+` *)
  | MinusOp (* `-` *)

and binop =
  | AndOp  (* `/\` *)
  | OrOp   (* `\/` *)
  | ImplOp (* `=>` *)
  | AddOp  (* `+` *)
  | SubOp  (* `-` *)
  | MulOp  (* `*` *)
  | DivOp  (* `/` *)
  | ExpOp  (* `^` *)

and cmpop =
  | EqOp (* `=` *)
  | NeOp (* `=/=` *)
  | LtOp (* `<` *)
  | GtOp (* `>` *)
  | LeOp (* `<=` *)
  | GeOp (* `>=` *)

and exp = exp' phrase
and exp' =
  | VarE of id                   (* varid *)
  | AtomE of atom                (* atom *)
  | BoolE of bool                (* bool *)
  | NatE of nat                  (* nat *)
  | TextE of text                (* text *)
  | UnE of unop * exp            (* unop exp *)
  | BinE of exp * binop * exp    (* exp binop exp *)
  | CmpE of exp * cmpop * exp    (* exp cmpop exp *)
  | SeqE of exp list             (* `epsilon` / exp exp *)
  | IdxE of exp * exp            (* exp `[` exp `]` *)
  | SliceE of exp * exp * exp    (* exp `[` exp `:` exp `]` *)
  | UpdE of exp * path * exp     (* exp `[` path `=` exp `]` *)
  | ExtE of exp * path * exp     (* exp `[` path `=..` exp `]` *)
  | StrE of expfield list        (* `{` list(expfield, `,`) `}` *)
  | DotE of exp * atom           (* exp `.` atom *)
  | CommaE of exp * exp          (* exp `,` exp *)
  | CompE of exp * exp           (* exp `++` exp *)
  | LenE of exp                  (* `|` exp `|` *)
  | ParenE of exp                (* `(` exp `)` *)
  | TupE of exp list             (* `(` list2(exp, `,`) `)` *)
  | InfixE of exp * atom * exp   (* exp atom exp *)
  | BrackE of brack * exp        (* ``` ([{ exp }]) *)
  | CallE of id * exp            (* `$` defid exp? *)
  | IterE of exp * iter          (* exp iter *)
  | HoleE                        (* `%` *)
  | FuseE of exp * exp           (* exp `#` exp *)

and expfield = atom * exp        (* atom exp *)

and path = path' phrase
and path' =
  | RootP                        (*  *)
  | IdxP of path * exp           (* path `[` exp `]` *)
  | DotP of path * atom          (* path `.` atom *)


(* Definitions *)

and def = def' phrase
and def' =
  | SynD of id * deftyp * hint list          (* `syntax` synid hint* `=` deftyp *)
  | RelD of id * nottyp * hint list          (* `relation` relid `:` nottyp hint* *)
  | RuleD of id * id * exp * premise list    (* `rule` relid ruleid? `:` exp (`--` premise)* *)
  | VarD of id * typ * hint list             (* `var` varid `:` typ *)
  | DecD of id * exp * typ * hint list       (* `def` `$` defid exp? `:` typ hint* *)
  | DefD of id * exp * exp * premise option  (* `def` `$` defid exp? `=` exp *)

and premise = premise' phrase
and premise' =
  | RulePr of id * exp * iter option         (* `(` metaid exp `)` iter? *)
  | IffPr of exp * iter option               (* `iff` exp *)
  | ElsePr                                   (* `otherwise` *)

and hint = hint' phrase
and hint' = {hintid : id; hintexp : exp}     (* `(` `hint` hintid exp `)` *)


(* Scripts *)

type script = def list