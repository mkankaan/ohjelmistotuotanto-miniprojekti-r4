import pytest
from app import app, test_env
from db_helper import reset_db
import app as module_under_test

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

def test_bibtex_get_route(client):
    response = client.get("/bibtex")
    assert response.status_code == 404
    assert b"No bibtex data found" in response.data

def test_bibtex_post_route(client, monkeypatch):
    def fake_get_citation_dict(i):
        return {"id": i, "citation_key": "testi", "title": "testititteli", "type": "book"}

    def fake_get_bibtex(cits):
        return "BIB:" + ",".join(str(c["id"]) for c in cits)

    monkeypatch.setattr(module_under_test, "get_citation_dict", fake_get_citation_dict)
    monkeypatch.setattr(module_under_test, "get_bibtex", fake_get_bibtex)

    payload = {"data": [1, 2, 3]}

    response = client.post("/bibtex", json=payload)

    assert response.status_code == 200
    assert response.is_json
    assert response.get_json() == {"redirect_url": "/bibtex"}

    with client.session_transaction() as sess:
        assert sess["bibtex"] == "BIB:1,2,3"

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

def test_populate_form_valid_doi(monkeypatch, client):
    from util import request_crossref_data

    def fake_request_crossref_data(doi):
        return {
            "type": "article",
            "title": ["Example Title"],
            "author": "A U Thor",
            "publisher": "Example Publisher",
            "created": {"date-parts": [[2020, 1, 1]]},
            "ISBN": ["1234567890"],
            "DOI": doi,
            "link": [{"URL": "https://example.com"}],
            "container-title": ["Example Journal"],
            "page": "1-10",
            "article-number": "3",
            "volume": "10",
            "issue": "2",
        }

    monkeypatch.setattr("app.request_crossref_data", fake_request_crossref_data)

    response = client.post("/populate-form", json={"query": "10.1234/example"})
    assert response.status_code == 200
    data = response.get_json()
    assert data["type"] == "article"
    assert data["title"] == "Example Title"
    assert data["publisher"] == "Example Publisher"
    assert data["year"] == 2020
    assert data["isbn"] == "1234567890"
    assert data["doi"] == "10.1234/example"
    assert data["url"] == "https://example.com"
    assert data["journal"] == "Example Journal"
    assert data["booktitle"] == "Example Journal"
    assert data["pages"] == "1-10"
    assert data["chapter"] == "3"
    assert data["volume"] == "10"
    assert data["number"] == "2"






def test_edit_route_invalid_year(client):
    data = {
        "citation_key": "key_edit3",
        "type": "article",
        "author": "Test Author",
        "title": "Test Title",
        "year": "2020",
    }
    client.post("/create_citation", data=data)

    edit_data = {
        "citation_key": "key_edit3",
        "type": "article",
        "title": "Test Title",
        "author": "Test Author",
        "year": "not_a_year",
        "publisher": "",
        "isbn": "",
        "doi": "",
        "url": "",
        "urldate": "",
        "journal": "",
        "booktitle": "",
        "pages": "",
        "volume": "",
        "number": "",
        "chapter": "",
    }
    response = client.post("/edit/1", data=edit_data)
    assert response.status_code == 302
