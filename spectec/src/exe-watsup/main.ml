open Util


(* Configuration *)

let name = "watsup"
let version = "0.4"


(* Flags and parameters *)

type target =
 | Check
 | Latex
 | Prose
 | Splice of Backend_splice.Config.t
 | Interpreter of string list

type pass =
  | Sub
  | Totalize
  | Unthe
  | Wild
  | Sideconditions
  | Animate

(* This list declares the intended order of passes.

Because passes have dependencies, and because some flags enable multiple
passers (--all-passes, some targets), we do _not_ want to use the order of
flags on the command line.
*)
let _skip_passes = [ Sub ]
let all_passes = [ Totalize; Unthe; Wild; Sideconditions; Animate ]

type file_kind =
  | Spec
  | Patch
  | Output

let target = ref Check
let log = ref false        (* log execution steps *)
let in_place = ref false   (* splice patch files in place *)
let dry = ref false        (* dry run for patching *)
let warn_math = ref false  (* warn about unused or reused math splices *)
let warn_prose = ref false (* warn about unused or reused prose splices *)

let file_kind = ref Spec
let srcs = ref []    (* spec src file arguments *)
let pdsts = ref []   (* patch file arguments *)
let odsts = ref []   (* output file arguments *)

let print_el = ref false
let print_elab_il = ref false
let print_final_il = ref false
let print_all_il = ref false
let print_al = ref false
let print_no_pos = ref false

module PS = Set.Make(struct type t = pass let compare = compare; end)
let selected_passes = ref (PS.empty)
let enable_pass pass = selected_passes := PS.add pass !selected_passes


let print_il il =
  Printf.printf "%s\n%!" (Il.Print.string_of_script ~suppress_pos:(!print_no_pos) il)


(* Il pass metadata *)

let pass_flag = function
  | Sub -> "sub"
  | Totalize -> "totalize"
  | Unthe -> "the-elimination"
  | Wild -> "wildcards"
  | Sideconditions -> "sideconditions"
  | Animate -> "animate"

let pass_desc = function
  | Sub -> "Synthesize explicit subtype coercions"
  | Totalize -> "Run function totalization"
  | Unthe -> "Eliminate the ! operator in relations"
  | Wild -> "Eliminate wildcards and equivalent expressions"
  | Sideconditions -> "Infer side conditions"
  | Animate -> "Animate equality conditions"

let run_pass : pass -> Il.Ast.script -> Il.Ast.script = function
  | Sub -> Middlend.Sub.transform
  | Totalize -> Middlend.Totalize.transform
  | Unthe -> Middlend.Unthe.transform
  | Wild -> Middlend.Wild.transform
  | Sideconditions -> Middlend.Sideconditions.transform
  | Animate -> Il2al.Animate.transform


(* Argument parsing *)

let banner () =
  print_endline (name ^ " " ^ version ^ " generator")

let usage = "Usage: " ^ name ^ " [option] [file ...] [-p file ...] [-o file ...]"

let add_arg source =
  let args =
    match !file_kind with
    | Spec -> srcs
    | Patch -> pdsts
    | Output -> odsts
  in args := !args @ [source]

let pass_argspec pass : Arg.key * Arg.spec * Arg.doc =
  "--" ^ pass_flag pass, Arg.Unit (fun () -> enable_pass pass), " " ^ pass_desc pass

let argspec = Arg.align
[
  "-v", Arg.Unit banner, " Show version";
  "-p", Arg.Unit (fun () -> file_kind := Patch), " Patch files";
  "-i", Arg.Set in_place, " Splice patch files in-place";
  "-d", Arg.Set dry, " Dry run (when -p) ";
  "-o", Arg.Unit (fun () -> file_kind := Output), " Output files";
  "-l", Arg.Set log, " Log execution steps";
  "-w", Arg.Unit (fun () -> warn_math := true; warn_prose := true),
    " Warn about unused or multiply used splices";
  "--warn-math", Arg.Set warn_math,
    " Warn about unused or multiply used math splices";
  "--warn-prose", Arg.Set warn_prose,
    " Warn about unused or multiply used prose splices";

  "--check", Arg.Unit (fun () -> target := Check), " Check only (default)";
  "--latex", Arg.Unit (fun () -> target := Latex), " Generate Latex";
  "--splice-latex", Arg.Unit (fun () -> target := Splice Backend_splice.Config.latex),
    " Splice Sphinx";
  "--splice-sphinx", Arg.Unit (fun () -> target := Splice Backend_splice.Config.sphinx),
    " Splice Sphinx";
  "--prose", Arg.Unit (fun () -> target := Prose), " Generate prose";
  "--interpreter", Arg.Rest_all (fun args -> target := Interpreter args),
    " Generate interpreter";

  "--print-el", Arg.Set print_el, " Print EL";
  "--print-il", Arg.Set print_elab_il, " Print IL (after elaboration)";
  "--print-final-il", Arg.Set print_final_il, " Print final IL";
  "--print-all-il", Arg.Set print_all_il, " Print IL after each step";
  "--print-al", Arg.Set print_al, " Print al";
  "--print-no-pos", Arg.Set print_no_pos, " Suppress position info in output";
] @ List.map pass_argspec all_passes @ [
  "--all-passes", Arg.Unit (fun () -> List.iter enable_pass all_passes)," Run all passes";

  "--test-version", Arg.Int (fun i -> Backend_interpreter.Construct.version := i), " The version of wasm, default to 3";

  "-help", Arg.Unit ignore, "";
  "--help", Arg.Unit ignore, "";
]


(* Main *)

let log s = if !log then Printf.printf "== %s\n%!" s

let () =
  Printexc.record_backtrace true;
  let last_pass = ref "" in
  try
    Arg.parse argspec add_arg usage;
    log "Parsing...";
    let el = List.concat_map Frontend.Parse.parse_file !srcs in
    if !print_el then
      Printf.printf "%s\n%!" (El.Print.string_of_script el);
    log "Elaboration...";
    let il, elab_env = Frontend.Elab.elab el in
    if !print_elab_il || !print_all_il then print_il il;
    log "IL Validation...";
    Il.Valid.valid il;

    (match !target with
    | Prose | Splice _ | Interpreter _ ->
      enable_pass Sideconditions; enable_pass Animate
    | _ -> ()
    );

    let il =
      List.fold_left (fun il pass ->
        if not (PS.mem pass !selected_passes) then il else
        (
          last_pass := pass_flag pass;
          log ("Running pass " ^ pass_flag pass ^ "...");
          let il = run_pass pass il in
          if !print_all_il then print_il il;
          log ("IL Validation after pass " ^ pass_flag pass ^ "...");
          Il.Valid.valid il;
          il
        )
      ) il all_passes
    in
    last_pass := "";

    if !print_final_il && not !print_all_il then print_il il;

    let al =
      if !target = Check || not (PS.mem Animate !selected_passes) then [] else (
        log "Translating to AL...";
        (Il2al.Translate.translate il @ Backend_interpreter.Manual.manual_algos)
      )
    in

    if !print_al then
      Printf.printf "%s\n%!"
        (List.map Al.Print.string_of_algorithm al |> String.concat "\n");

    (match !target with
    | Check -> ()

    | Latex ->
      log "Latex Generation...";
      (match !odsts with
      | [] -> print_endline (Backend_latex.Gen.gen_string el)
      | [odst] -> Backend_latex.Gen.gen_file odst el
      | _ ->
        prerr_endline "too many output file names";
        exit 2
      )

    | Prose ->
      log "Prose Generation...";
      let prose = Backend_prose.Gen.gen_prose il al in
      let oc =
        match !odsts with
        | [] -> stdout
        | [odst] -> open_out odst
        | _ ->
          prerr_endline "too many output file names";
          exit 2
      in
      output_string oc "=================\n";
      output_string oc " Generated prose \n";
      output_string oc "=================\n";
      output_string oc (Backend_prose.Print.string_of_prose prose);
      if oc != stdout then close_out oc

    | Splice config ->
      if !in_place then
        odsts := !pdsts
      else
      (
        match !odsts with
        | [] -> odsts := List.map (Fun.const "") !pdsts
        | [odst] when Sys.is_directory odst ->
          odsts := List.map (fun pdst -> Filename.concat odst pdst) !pdsts
        | _ when List.length !odsts = List.length !pdsts -> ()
        | _ ->
          prerr_endline "inconsistent number of input and output file names";
          exit 2
      );
      log "Prose Generation...";
      let prose = Backend_prose.Gen.gen_prose il al in
      log "Splicing...";
      let env = Backend_splice.Splice.(env config !pdsts !odsts elab_env el prose) in
      List.iter2 (Backend_splice.Splice.splice_file ~dry:!dry env) !pdsts !odsts;
      if !warn_math then Backend_splice.Splice.warn_math env;
      if !warn_prose then Backend_splice.Splice.warn_prose env;

    | Interpreter args ->
      log "Initializing interpreter...";
      Backend_interpreter.Ds.init al;
      log "Interpreting...";
      Backend_interpreter.Runner.run args
    );
    log "Complete."
  with
  | Source.Error (at, msg) ->
    let msg' =
      if !last_pass <> "" && String.starts_with ~prefix:"validation" msg then
        "(after pass " ^ !last_pass ^ ") " ^ msg
      else
        msg
    in
    Source.print_error at msg';
    exit 1
  | exn ->
    flush_all ();
    prerr_endline
      (Sys.argv.(0) ^ ": uncaught exception " ^ Printexc.to_string exn);
    Printexc.print_backtrace stderr;
    exit 2
