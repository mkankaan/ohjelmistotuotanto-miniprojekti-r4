from sqlalchemy import text
from config import db
from util import format_authors


def get_citations():
    result = db.session.execute(text("SELECT id, citation_key, title, type, publisher, year, isbn, doi, url FROM citations"))
    citations = result.fetchall()
    citation_dicts = []

    for citation in citations:
        citation_id = citation[0]
        authors = get_citation_authors(citation_id)
        formatted_author_list = format_authors(get_authors_as_list(authors))
        citation_dict = {
            "citation_key": citation[1],
            "title": citation[2],
            "type": citation[3],
            "author": formatted_author_list,
            "publisher": citation[4],
            "year": citation[5],
            "isbn": citation[6],
            "doi": citation[7],
            "url": citation[8],
        }        
        citation_dicts.append(citation_dict)

    return citation_dicts


def get_authors_as_list(row_object):
    author_list = []

    for row in row_object:
        author_list.append(row[0])
    print(author_list)
    return author_list


def create_citation(content):
    # Insert citation
    citation_sql = text("""
        INSERT INTO citations (citation_key, type, title, year, publisher, isbn, doi, url)
        VALUES (:citation_key, :type, :title, :year, :publisher, :isbn, :doi, :url)
        RETURNING id;
    """)

    citation_result = db.session.execute(citation_sql, {
        "citation_key": content["citation_key"],
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

def get_citation_authors(citation_id):
    result = db.session.execute(text("""
                                     SELECT authors.name
                                     FROM citations_authors 
                                     LEFT JOIN authors ON authors.id = citations_authors.author_id
                                     WHERE citation_id = :citation_id
    """), {"citation_id": citation_id})
    authors = result.fetchall()
    return authors
