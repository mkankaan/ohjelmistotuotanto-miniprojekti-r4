import pytest
from app import app, test_env
from db_helper import reset_db

@pytest.fixture
def client():
    app.config["TESTING"] = True
    with app.test_client() as client:
        with app.app_context():
            reset_db()
        yield client

def test_index_route(client):
    response = client.get("/")
    assert response.status_code == 200
    assert b"citation" in response.data or b"Sitaatti" in response.data

def test_new_citation_route(client):
    response = client.get("/new_citation")
    assert response.status_code == 200

def test_create_citation_valid(client):
    data = {
        "citation_key": "key1",
        "type": "book",
        "author": "Test Author",
        "title": "Test Title",
        "year": "2024"
    }
    response = client.post("/create_citation", data=data, follow_redirects=True)
    assert response.status_code == 200
    assert b"Test Title" in response.data

def test_create_citation_invalid_year(client):
    data = {
        "citation_key": "key2",
        "type": "article",
        "author": "Test Author",
        "title": "Test Title",
        "year": "not_a_year"
    }
    response = client.post("/create_citation", data=data)
    assert response.status_code == 302

def test_bibtex_route(client):
    response = client.get("/bibtex")
    assert response.status_code == 200
    assert b"bibtex" in response.data

def test_reset_db_route(client): # pragma: no cover
    if test_env:
        response = client.get("/reset_db")
        assert response.status_code == 200
        assert b"db reset" in response.data

def test_check_citation_key_exists(client):
    data = {
        "citation_key": "key1",
        "type": "book",
        "author": "Test Author",
        "title": "Test Title",
        "year": "2024"
    }
    client.post("/create_citation", data=data)
    response = client.get("/check_citation_key?key=key1")
    assert response.status_code == 200
    json_data = response.get_json()
    assert json_data["exists"] is True

def test_check_citation_key_not_exists(client):
    response = client.get("/check_citation_key?key=notpresent")
    assert response.status_code == 200
    json_data = response.get_json()
    assert json_data["exists"] is False
