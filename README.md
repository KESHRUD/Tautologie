# Tautologie en OCaml
Ce projet implémente un algorithme de vérification de tautologie en OCaml. Il prend en entrée une formule propositionnelle et détermine si elle est une tautologie ou non.

# Étapes
	- Conversion de formules propositionnelles en formules conditionnelles.
	- Mise en forme normale des formules conditionnelles.
	- Évaluation des formules conditionnelles dans un environnement donné.
	- Vérification du caractère de tautologie des formules conditionnelles.

## Utilisation de OCaml en Terminal

Pour ouvrir OCaml dans votre terminal, il vous suffit de taper la commande suivante :

```bash
ocaml
```

Cela lancera l'interpréteur(Toplevel) OCaml où vous pourrez saisir et évaluer des expressions OCaml.

## Importation du Fichier `tautologie.ml`
```bash
# #use "tautologie.ml";;
```

## Exemple d'utilisation
```bash
# is_tautology (Et(Vrai, Ou(Non(V(1)), V(2))));;
```








