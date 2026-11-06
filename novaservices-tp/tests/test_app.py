import pytest

from app import app


@pytest.fixture
def client():
    return app.test_client()


def test_health_repond_200(client):
    r = client.get("/health")
    assert r.status_code == 200
    assert r.get_json()["status"] == "ok"


def test_tickets_renvoie_une_liste_de_tickets(client):
    r = client.get("/tickets")
    assert r.status_code == 200
    data = r.get_json()
    assert isinstance(data, list) and len(data) > 0
    assert {"id", "titre", "statut"} <= set(data[0].keys())


def test_route_inexistante_repond_404(client):
    assert client.get("/nimportequoi").status_code == 404
