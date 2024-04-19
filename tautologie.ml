(* Définition des types pour les formules propositionnelles et conditionnelles *)
type prop =
  | V of int              (* Variable propositionnelle avec un identifiant *)
  | Vrai                  (* Constante "Vrai" *)
  | Faux                  (* Constante "Faux" *)
  | Et of prop * prop     (* Opérateur "Et" *)
  | Ou of prop * prop     (* Opérateur "Ou" *)
  | Imp of prop * prop    (* Opérateur "Implication" *)
  | Equiv of prop * prop  (* Opérateur "Équivalence" *)
  | Non of prop           (* Opérateur "Non" *)

type cond =
  | W of int              (* Variable conditionnelle avec un identifiant *)
  | Vrai_bis              (* Constante "Vrai_bis" *)
  | Faux_bis              (* Constante "Faux_bis" *)
  | Si of cond * cond * cond (* Opérateur conditionnel "Si" *)

(* 1/Fonction de transformation *) 
(* Convertit une formule propositionnelle en une formule conditionnelle *)
let rec trad_prop_to_cond = function
  (* Convertit une variable prop en variable cond *)
  | V(i) -> W(i) 
  (* Convertit la constante vrai prop en constante vrai cond *)               
  | Vrai -> Vrai_bis 
  (* Convertit la constante faux prop en constante faux cond *)   
  | Faux -> Faux_bis 
  (* Convertit la négation d'une proposition prop en conditionnelle *)  
  | Non(p) -> Si(trad_prop_to_cond p, Faux_bis, Vrai_bis) 
  (* Convertit la conjonction de deux propositions prop en conditionnelle *)              
  | Et(p1, p2) -> Si(trad_prop_to_cond p1, trad_prop_to_cond p2, Faux_bis) 
  (* Convertit la disjonction de deux propositions prop en conditionnelle *)                  
  | Ou(p1, p2) -> Si(trad_prop_to_cond p1, Vrai_bis, trad_prop_to_cond p2)
  (* Convertit l'implication entre deux propositions prop en conditionnelle *)                  
  | Imp(p1, p2) -> Si(trad_prop_to_cond (Non p1), trad_prop_to_cond p2, Vrai_bis)
  (* Convertit l'équivalence entre deux propositions prop en conditionnelle *)                   
  | Equiv(p1, p2) -> Si(Si(trad_prop_to_cond p1, trad_prop_to_cond p2, Vrai_bis), Si(trad_prop_to_cond p2, trad_prop_to_cond p1, Vrai_bis), Vrai_bis)

(* 2/Met une formule conditionnelle en forme normale *)
let rec form_norm_cond = function
  (* Si la formule est de la forme Si(Si(...), ...), on la décompose *)
  | Si(Si(a, b, c), d, e) -> 
      (* Forme normale des parties conditionnelles *)
      let nb = form_norm_cond (Si(b, d, e)) in  
      let nc = form_norm_cond (Si(c, d, e)) in
      (* Forme normale de la formule principale *)
      form_norm_cond (Si(form_norm_cond a, nb, nc))  
  (* Si la formule est de la forme Si(...), forme normale de ses parties *)      
  | Si(a, b, c) -> Si(a, form_norm_cond b, form_norm_cond c) 
  (* Pour les autres cas, la formule est déjà en forme normale *)                   
  | other -> other  

(* 3/Évalue une formule conditionnelle dans un environnement donné *)
let rec eval_cond f env =
  match f with
  (* Si la formule est vraie, retourne vrai *)
  | Vrai_bis -> true        
  (* Si la formule est fausse, retourne faux *)  
  | Faux_bis -> false 
  (* Si la formule est une variable, recherche sa valeur dans l'environnement *)  
  | W(i) -> List.assoc_opt i env |> Option.value ~default:false  
  (* Si la formule est de la forme Si(...), évalue les parties conditionnelles *)            
  | Si(g, h, k) ->          
      (* Si la première partie est vraie, évalue la deuxième partie *)
      if eval_cond g env then eval_cond h env  
      (* Sinon, évalue la troisième partie *)
      else eval_cond k env   
                             
(* 4/Fonctions de vérification du caractère de tautologie *) 
(* Vérifie si une formule conditionnelle est une tautologie *)
let rec is_tautology_cond f =
  let rec try_all_assignments vars env =
    match vars with
    | [] -> eval_cond f env
    (* Sinon, pour chaque variable, essaie les deux valeurs possibles (vrai et faux) *)          
    | v::vs ->                  
        try_all_assignments vs ((v, true)::env) && try_all_assignments vs ((v, false)::env)
  in
  let rec collect_vars f acc =
    match f with
    (* Si la formule est une variable, ajoute son identifiant à la liste des variables *)
    | W(i) -> if List.mem i acc then acc else i::acc    
    (* Si la formule est de la forme Si(...), collecte les variables de ses parties *)                                          
    | Si(g, h, k) -> collect_vars g (collect_vars h (collect_vars k acc)) 
    (* Pour les autres cas, aucune variable à collecter *)                   
    | _ -> acc    
  in
  (* Collecte toutes les variables de la formule *)
  let vars = collect_vars f [] in    
  (* Essaie toutes les affectations possibles *)
  try_all_assignments vars []        

(* Fonction principale qui Vérifie si une formule propositionnelle est une tautologie *)
let is_tautology f =
  (* Convertit la formule propositionnelle en formule conditionnelle *)
  let g = trad_prop_to_cond f in  
  (* Met la formule conditionnelle en forme normale *)
  let h = form_norm_cond g in        
  (* Vérifie si la formule conditionnelle est une tautologie *)
  let is_tautology = is_tautology_cond h in  
  let message = if is_tautology then "La formule est une tautologie." else "La formule n'est pas une tautologie." in
  (* Affiche le message indiquant si la formule est une tautologie *)
  print_endline message; 
  (* Retourne la valeur booléenne (caractère de tautologie) indiquant si la formule est une tautologie *)
  is_tautology    
