open Util
open Source
open El.Ast
open Config


(* Errors *)

let rec pos' file s i j (line, column) : Source.pos =
  if j = i then
    Source.{file; line; column}
  else
    pos' file s i (j + 1) (if s.[j] = '\n' then line + 1, 1 else line, column + 1)

let pos file s i = pos' file s i 0 (1, 1)

let error file s i msg =
  let pos = pos file s i in
  Source.error {left = pos; right = pos} "splice replacement" msg


(* Environment *)

module Map = Map.Make(String)

type syntax = {sdef : def}
type relation = {rdef : def; rules : def Map.t}
type definition = {fdef : def; clauses : def list}

type env =
  { config : config;
    mutable syn : syntax Map.t;
    mutable rel : relation Map.t;
    mutable def : definition Map.t;
  }

let env_def env def =
  match def.it with
  | SynD (id, _, _) ->
    env.syn <- Map.add id.it {sdef = def} env.syn
  | RelD (id, _, _) ->
    env.rel <- Map.add id.it {rdef = def; rules = Map.empty} env.rel
  | RuleD (id1, id2, _, _) ->
    let relation = Map.find id1.it env.rel in
    let rules = Map.add id2.it def relation.rules in
    env.rel <- Map.add id1.it {relation with rules} env.rel
  | DecD (id, _, _, _) ->
    env.def <- Map.add id.it {fdef = def; clauses = []} env.def
  | DefD (id, _, _, _) ->
    let definition = Map.find id.it env.def in
    let clauses = definition.clauses @ [def] in
    env.def <- Map.add id.it {definition with clauses} env.def
  | VarD _ | SepD ->
    ()

let env config script : env =
  let env = {config; syn = Map.empty; rel = Map.empty; def = Map.empty} in
  List.iter (env_def env) script;
  env


let find_syntax env file s (i, id1, _id2) =
  match Map.find_opt id1 env.syn with
  | None -> error file s i ("unknown syntax identifier `" ^ id1 ^ "`")
  | Some syntax -> syntax.sdef

let find_relation env file s (i, id1, _id2) =
  match Map.find_opt id1 env.rel with
  | None -> error file s i ("unknown relation identifier `" ^ id1 ^ "`")
  | Some relation -> relation.rdef

let find_rule env file s (i, id1, id2) =
  match Map.find_opt id1 env.rel with
  | None -> error file s i ("unknown relation identifier `" ^ id1 ^ "`")
  | Some relation ->
    match Map.find_opt id2 relation.rules with
    | None -> error file s i ("unknown relation identifier `" ^ id2 ^ "`")
    | Some rule -> rule

let find_func env file s (i, id1, _id2) =
  match Map.find_opt id1 env.def with
  | None -> error file s i ("unknown definition identifier `" ^ id1 ^ "`")
  | Some definition -> definition.fdef
    (* TODO: splice definition clauses *)


(* Splicing *)

let len = String.length

let rec skip_space s i =
  if !i < len s && (s.[!i] = ' ' || s.[!i] = '\t' || s.[!i] = '\n') then
    (incr i; skip_space s i)

let rec try_string' s i s' j : bool =
  j = len s' || s.[i] = s'.[j] && try_string' s (i + 1) s' (j + 1)

let try_string s i s' : bool =
  len s >= !i + len s' && try_string' s !i s' 0 && (i := !i + len s'; true)

let try_anchor_start s i anchor : bool =
  try_string s i (anchor ^ "{")

let rec match_anchor_end file s j i depth =
  if !i = len s then
    error file s j "unclosed anchor"
  else if s.[!i] = '{' then
    (incr i; match_anchor_end file s j i (depth + 1))
  else if s.[!i] <> '}' then
    (incr i; match_anchor_end file s j i depth)
  else if depth > 0 then
    (incr i; match_anchor_end file s j i (depth - 1))

let rec match_id' s i =
  if !i < len s then
  match s.[!i] with
  | 'A'..'Z' | 'a'..'z' | '0'..'9' | '_' | '\'' | '`' | '-' ->
    (incr i; match_id' s i)
  | _ -> ()

let match_id file s i space : string =
  let j = !i in
  match_id' s i;
  if j = !i then
    error file s j ("expected " ^ space ^ " identifier or `}`");
  String.sub s j (!i - j)

let match_id_id file s i space1 space2 : int * string * string =
  let j = !i in
  let id1 = match_id file s i (if space2 = "" then space1 else space2) in
  let id2 =
    if space2 <> "" && try_string s i "/" then match_id file s i space1 else ""
  in
  j, id1, id2

let rec match_id_id_list file s i space1 space2 : (int * string * string) list =
  skip_space s i;
  if try_string s i "}" then [] else
  let idid = match_id_id file s i space1 space2 in
  let idids = match_id_id_list file s i space1 space2 in
  idid::idids

let try_def_anchor env file s i buf space1 space2 find : bool =
  let b = try_string s i space1 in
  if b then (
    skip_space s i;
    if not (try_string s i ":") then
      error file s !i "colon `:` expected";
    let idids = match_id_id_list file s i space1 space2 in
    let defs = List.map (find env file s) idids in
    Buffer.add_string buf (Render.render_defs env.config defs);
  );
  b

let try_exp_anchor env file s i buf : bool =
  let b = try_string s i ":" in
  if b then (
  	let j = !i in
    match_anchor_end file s (j - 4) i 0;
    let src = String.sub s j (!i - j) in
    incr i;
    let exp =
      try Frontend.Parse.parse_exp src with Source.Error (at, msg) ->
        (* Translate relative positions *)
        let pos = pos file s j in
        let shift {file; line; column} =
          { file; line = line + pos.line;
            column = if line = 1 then column + pos.column else column} in
        let at' = {left = shift at.left; right = shift at.right} in
        raise (Source.Error (at', msg))
    in
    Buffer.add_string buf (Render.render_exp env.config exp);
  );
  b

let splice_anchor env file s i anchor buf =
  skip_space s i;
  Buffer.add_string buf anchor.prefix;
  ignore (
    try_exp_anchor env file s i buf ||
    try_def_anchor env file s i buf "syntax" "" find_syntax ||
    try_def_anchor env file s i buf "relation" "" find_relation ||
    try_def_anchor env file s i buf "rule" "relation" find_rule ||
    try_def_anchor env file s i buf "definition" "" find_func ||
    error file s !i "unknown definition sort";
  );
  Buffer.add_string buf anchor.suffix

let rec try_anchors env file s i buf = function
  | [] -> false
  | anchor::anchors ->
    if try_anchor_start s i anchor.token then
      (splice_anchor env file s i anchor buf; true)
    else
      try_anchors env file s i buf anchors

let rec splice env file s i buf =
  if !i < len s then (
  	if not (try_anchors env file s i buf env.config.anchors) then
      (Buffer.add_char buf s.[!i]; incr i);
    splice env file s i buf
  )


(* Entry points *)

let splice_string env file s : string =
  let buf = Buffer.create (String.length s) in
  splice env file s (ref 0) buf;
  Buffer.contents buf

let splice_file env file =
  let ic = In_channel.open_text file in
  let s =
    Fun.protect (fun () -> In_channel.input_all ic)
      ~finally:(fun () -> In_channel.close ic)
  in
  let s' = splice_string env file s in
  let oc = Out_channel.open_text file in
  Fun.protect (fun () -> Out_channel.output_string oc s')
    ~finally:(fun () -> Out_channel.close oc)
