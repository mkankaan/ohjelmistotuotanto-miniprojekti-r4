import pytest
from app import app
from db_helper import reset_db
import repositories.cit_repository as cit_repo

@pytest.fixture(autouse=True)
def client():
    app.config["TESTING"] = True
    with app.app_context():
        reset_db()
        with app.test_client() as client:
            yield client

def test_create_and_get_citation():
    content = {
        "citation_key": "key3",
        "type": "book",
        "author": ["Author"],
        "title": "Test"
    }
    cit_repo.create_citation(content)
    citations = cit_repo.get_citations()
    assert any(c["title"] == content["title"] for c in citations)

def test_create_citation_for_existing_author():
    content = {
        "citation_key": "key4",
        "type": "book",
        "author": ["Luukkainen"],
        "title": "Uusi Testamentti"
    }
    cit_repo.create_citation(content)

    content = {
        "citation_key": "key5",
        "type": "book",
        "author": ["Luukkainen"],
        "title": "Uudempi Testamentti"
    }
    cit_repo.create_citation(content)
    cits = cit_repo.get_citations()
    
    assert cits[0]["author"] == cits[1]["author"]

def test_get_citation_dict():
    content = {
        "citation_key": "key6",
        "type": "book",
        "author": ["Luukkainen"],
        "title": "Uusin Testamentti"
    }
    cit_id = cit_repo.create_citation(content)
    cit_dict = cit_repo.get_citation_dict(cit_id)

    content["author"] = "Luukkainen"

    assert cit_dict["citation_key"] == content["citation_key"]
    assert cit_dict["type"] == content["type"]
    assert cit_dict["author"] == content["author"]
    assert cit_dict["title"] == content["title"]
    
def test_delete_citation():
    content = {
        "citation_key": "key7",
        "type": "book",
        "author": ["Luukkainen"],
        "title": "Uusin Testamentti (2.0)"
    }
    cit_repo.create_citation(content)
    
    content = {
        "citation_key": "key8",
        "type": "book",
        "author": ["Luukkainen"],
        "title": "Uusin Testamentti (3.0)"
    }
    cit_id = cit_repo.create_citation(content)

    cit_repo.delete_citation(cit_id)

    cits = cit_repo.get_citations()

    assert len(cits) == 1
