#!/bin/bash

# Définir le chemin spécifique au répertoire
REPO_SPECIFIC_PATH="catalogue/"

# Vérifier si le répertoire existe
if [ ! -d "$REPO_SPECIFIC_PATH" ]; then
    echo "$REPO_SPECIFIC_PATH n'existe pas."
    exit 1
fi

# Vérifier les changements
# Utiliser HEAD~1 seulement si le référentiel a plus d'un commit
if git rev-parse --verify HEAD~1 >/dev/null 2>&1; then
    changes=$(git diff --name-only HEAD~1 HEAD)
else
    echo "Pas assez d'historique pour vérifier les modifications."
    changes=""
fi

echo "Changements détectés : $changes"

# Si aucune modification n'est trouvée, quitter le script
if [[ -z "$changes" ]]; then
    echo "Aucune modification détectée. Quitter le build."
    exit 0 # Code 0 pour indiquer que tout va bien, mais on ne veut pas continuer.
fi

# Vérifier si les changements sont dans le répertoire spécifique
if [[ "$changes" == *"$REPO_SPECIFIC_PATH"* ]]; then
    echo "Modifications détectées dans '$REPO_SPECIFIC_PATH'"
    # Appeler le webhook ou d'autres étapes si nécessaire
    curl -X POST -H "Content-Type: application/json" -d '{"text":"Modifications détectées dans '"$REPO_SPECIFIC_PATH"'"}' https://codebuild.eu-west-1.amazonaws.com/webhooks?t=eyJlbmNyeXB0ZWREYXRhIjoiR0hXMmZTZWNhTDExalVFdmllRU8yN2RWNnBEN0NEWDFxOVlvM1NFUGF5a2YrQysvMHp2RytpalZScHNEWG12OHVZWnBZV09ZRk5MeWQwQkVKM3FxNFRvPSIsIml2UGFyYW1ldGVyU3BlYyI6InpSZkhTTURCWGorM0pHQUwiLCJtYXRlcmlhbFNldFNlcmlhbCI6MX0%3D&v=1
else
    echo "Aucune modification dans le répertoire spécifique '$REPO_SPECIFIC_PATH'"
fi
