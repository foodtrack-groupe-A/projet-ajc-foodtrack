# projet-ajc-foodtrack
Dépôt du projet final de la formation AJC Ingénieur Cloud OPS


# Kustomize

Nous avons choisi de partir sur Kustomize pour la séparation par environnement pour sa facilité d'exécution et ses capacités adaptées à notre projet de petite envergure. De plus, Kustomize est présent directement dans Cloud Shell.

Créer une copie de fichier par environnement pose un véritable problème d'optimisation, tandis qu'envsubst ne propose pas les avantages de confort de Kustomize.
Nous avons également consideré Helm pour réaliser ce projet, mais après de plus amples recherches et discussions au sein du groupe, nous en avons conclu qu'il était trop fourni pour un projet de cette taille.