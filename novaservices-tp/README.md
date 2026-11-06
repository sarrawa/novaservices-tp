# API tickets NovaServices (TP CI/CD, GitLab)

## Lancer en local
    python -m venv .venv
    source .venv/bin/activate        # Windows : .venv\Scripts\Activate.ps1
    python -m pip install -r requirements.txt
    python app.py                    # http://localhost:8000/health
    python -m pytest -q

## Réglages GitLab à faire (une fois)
- Settings > CI/CD > Variables, à ajouter :
  - DEPLOY_HOST, DEPLOY_USER, DEPLOY_PORT (valeurs de ta VM)
  - DEPLOY_SSH_KEY : type **File**, contenu = clé privée de déploiement, avec "Protect variable" et "Mask" si proposé
  - DEPLOY_KNOWN_HOSTS : empreinte SSH fournie par le formateur
- Settings > Repository > Protected branches : `main` protégée (pas de push direct)
- Settings > Merge requests : cocher "Pipelines must succeed" pour bloquer la fusion si le pipeline est rouge
- Container Registry : l'image est dans Deploy > Container Registry. La VM s'y connecte avec le jeton du job ;
  si le formateur préfère, passer le projet en public.
- Runner : les runners partagés de gitlab.com acceptent Docker-in-Docker. Sur GitLab de l'école, le runner doit être en mode privileged.
  Si la VM n'est joignable que depuis le réseau de l'école, utiliser le runner de labo.

## Scénario étape 8 (pipeline rouge)
Dans app.py, changer `"statut": "ouvert"` : le test échoue. Corriger, repousser, le pipeline repasse vert.

## Scénario étape 13 (échec + rollback)
V2 : dans une nouvelle branche, faire renvoyer 500 par /health, ouvrir la merge request puis fusionner.
Le déploiement échoue, deploy.sh affiche les journaux puis redéploie le digest précédent.
Vérifier ensuite /health et /version avec curl.

## Vocabulaire
GitHub "pull request" = GitLab "merge request" ; "workflow" = `.gitlab-ci.yml` ; GHCR = GitLab Container Registry.
