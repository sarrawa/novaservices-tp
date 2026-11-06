# Fiche de choix du binôme

| Rubrique | Valeur |
|---|---|
| Application et besoin métier | API de tickets NovaServices : consulter les tickets informatiques. Fonctionnalité à modifier : (à compléter) |
| Source du projet | Dépôt du binôme créé à partir du modèle (URL à compléter) |
| Exécution | `python app.py` (local) / `gunicorn -b 0.0.0.0:8000 app:app` (conteneur) ; port interne 8000 |
| Validation | 1) GET /health = 200  2) GET /tickets = liste de tickets  3) URL inconnue = 404 |
| Identification | Variable APP_VERSION = SHA du commit, visible sur /version |
