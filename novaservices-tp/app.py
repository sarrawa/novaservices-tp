import os

from flask import Flask, jsonify

app = Flask(__name__)

# La version est injectée au build (commit Git) via la variable APP_VERSION
VERSION = os.getenv("APP_VERSION", "dev")

# Données fictives
TICKETS = [
    {"id": 1, "titre": "Imprimante en panne", "statut": "ouvert"},
    {"id": 2, "titre": "Accès VPN refusé", "statut": "en cours"},
    {"id": 3, "titre": "Mot de passe oublié", "statut": "fermé"},
]


@app.get("/health")
def health():
    return jsonify(status="ok"), 200


@app.get("/version")
def version():
    return jsonify(version=VERSION), 200


@app.get("/tickets")
def tickets():
    return jsonify(TICKETS), 200


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)
