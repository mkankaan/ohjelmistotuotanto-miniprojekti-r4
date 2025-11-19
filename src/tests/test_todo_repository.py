import pytest
import uuid
from app import app
from db_helper import reset_db
import repositories.todo_repository as todo_repo

@pytest.fixture(autouse=True)
def client():
    app.config["TESTING"] = True
    with app.app_context():
        reset_db()
        with app.test_client() as client:
            yield client

def test_create_and_get_citation():
    content = {
        "type": "book",
        "author": ["Author"],
        "title": "Test"
    }
    new_id = todo_repo.create_citation(content)
    citations = todo_repo.get_citations()
    assert any(c['info'][1] == content["title"] for c in citations)

