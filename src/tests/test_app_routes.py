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


def test_reset_db_route(client): # pragma: no cover
    if test_env:
        response = client.get("/reset_db")
        assert response.status_code == 200
        assert b"db reset" in response.data
