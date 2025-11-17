from config import db
from sqlalchemy import text

from entities.todo import Todo # Useless import, delete or change later

# Currently only returns amount of citations for testing.
def get_citations():
    result = db.session.execute(text("SELECT title, type, publisher FROM citations"))
    citations = result.fetchall()
    return citations

def set_done(todo_id):
    sql = text("UPDATE todos SET done = TRUE WHERE id = :id")
    db.session.execute(sql, { "id": todo_id })
    db.session.commit()


def create_citation(content):
    # Insert citation
    citation_sql = text("""
        INSERT INTO citations (type, title, year, publisher, isbn, doi, url)
        VALUES (:type, :title, :year, :publisher, :isbn, :doi, :url)
        RETURNING id;
    """)

    citation_result = db.session.execute(citation_sql, {
        "type": content["type"],
        "title": content["title"],
        "year": content.get("year"),
        "publisher": content.get("publisher"),
        "isbn": content.get("isbn"),
        "doi": content.get("doi"),
        "url": content.get("url")
    })

    citation_id = citation_result.scalar()  # Get the inserted citation ID

    # Insert authors and link them
    for order, name in enumerate(content["author"], start=1):
        # Check if author exists
        author_check_sql = text("SELECT id FROM authors WHERE name = :name")
        author_id = db.session.execute(author_check_sql, {"name": name}).scalar()

        if not author_id:
            # Insert new author
            author_insert_sql = text("INSERT INTO authors (name) VALUES (:name) RETURNING id")
            author_id = db.session.execute(author_insert_sql, {"name": name}).scalar()

        # Link citation and author
        link_sql = text("""
            INSERT INTO citations_authors (citation_id, author_id, author_order)
            VALUES (:citation_id, :author_id, :author_order)
        """)
        db.session.execute(link_sql, {
            "citation_id": citation_id,
            "author_id": author_id,
            "author_order": order
        })

    # Commit transaction
    db.session.commit()
