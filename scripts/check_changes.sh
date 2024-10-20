#!/bin/bash

REPO_SPECIFIC_PATH=$1

# Vérifie les fichiers modifiés dans la branche
changes=$(git diff --name-only HEAD~1 HEAD)
echo $changes

# Si les changements incluent des fichiers du répertoire spécifique, déclencher le webhook
if [[ "$changes" == *"$REPO_SPECIFIC_PATH"* ]]; then
  curl -X POST -H "Content-Type: application/json" -d '{"text":"Modifications détectées dans '"$REPO_SPECIFIC_PATH"'"}' https://codebuild.eu-west-1.amazonaws.com/webhooks?t=eyJlbmNyeXB0ZWREYXRhIjoiR0hXMmZTZWNhTDExalVFdmllRU8yN2RWNnBEN0NEWDFxOVlvM1NFUGF5a2YrQysvMHp2RytpalZScHNEWG12OHVZWnBZV09ZRk5MeWQwQkVKM3FxNFRvPSIsIml2UGFyYW1ldGVyU3BlYyI6InpSZkhTTURCWGorM0pHQUwiLCJtYXRlcmlhbFNldFNlcmlhbCI6MX0%3D&v=1
else
  echo "Aucune modification dans le répertoire spécifique $REPO_SPECIFIC_PATH"
fi
