from sqlalchemy import text
from config import db
from util import format_authors, citation_as_dict


def get_citations():
    result = db.session.execute(text("""
        SELECT
            id,          -- 0
            citation_key, -- 1
            title,        -- 2
            type,         -- 3
            publisher,    -- 4
            year,         -- 5
            isbn,         -- 6
            doi,          -- 7
            url,          -- 8
            urldate,      -- 9
            journal,      -- 10
            booktitle,    -- 11
            pages,        -- 12
            volume,       -- 13
            number,       -- 14
            chapter       -- 15
        FROM citations
    """))
    citations = result.fetchall()
    citation_dicts = []

    for citation in citations:
        citation_id = citation[0]
        authors = get_citation_authors(citation_id)
        formatted_author_list = format_authors([author[0] for author in authors])
        citation_dicts.append(citation_as_dict(citation, formatted_author_list))

    return citation_dicts



def create_citation(content):
    # Insert citation
    citation_sql = text("""
        INSERT INTO citations (
            citation_key,
            type,
            title,
            year,
            publisher,
            isbn,
            doi,
            url,
            urldate,
            journal,
            booktitle,
            pages,
            volume,
            number,
            chapter
        )
        VALUES (
            :citation_key,
            :type,
            :title,
            :year,
            :publisher,
            :isbn,
            :doi,
            :url,
            :urldate,
            :journal,
            :booktitle,
            :pages,
            :volume,
            :number,
            :chapter
        )
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
        "url": content.get("url"),
        "urldate": content.get("urldate"),
        "journal": content.get("journal"),
        "booktitle": content.get("booktitle"),
        "pages": content.get("pages"),
        "volume": content.get("volume"),
        "number": content.get("number"),
        "chapter": content.get("chapter"),
    })

    citation_id = citation_result.scalar()  # Get the inserted citation ID

    # Insert authors and link them
    for order, name in enumerate(content["author"], start=1):
        # Check if author exists
        author_check_sql = text("SELECT id FROM authors WHERE name = :name")
        author_id = db.session.execute(author_check_sql, {"name": name}).scalar()

        if not author_id:
            # Insert new author
            author_insert_sql = text(
                "INSERT INTO authors (name) VALUES (:name) RETURNING id"
            )
            author_id = db.session.execute(
                author_insert_sql, {"name": name}
            ).scalar()

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


def update_citation(citation_id, data):
    sql = text("""
        UPDATE citations
        SET citation_key = :citation_key,
            type = :type,
            title = :title,
            year = :year,
            publisher = :publisher,
            isbn = :isbn,
            doi = :doi,
            url = :url,
            urldate = :urldate,
            journal = :journal,
            booktitle = :booktitle,
            pages = :pages,
            volume = :volume,
            number = :number,
            chapter = :chapter
        WHERE id = :id
    """)

    citation_params = {
        "citation_key": data["citation_key"],
        "type": data["type"],
        "title": data["title"],
        "year": data.get("year"),
        "publisher": data.get("publisher"),
        "isbn": data.get("isbn"),
        "doi": data.get("doi"),
        "url": data.get("url"),
        "urldate": data.get("urldate"),
        "journal": data.get("journal"),
        "booktitle": data.get("booktitle"),
        "pages": data.get("pages"),
        "volume": data.get("volume"),
        "number": data.get("number"),
        "chapter": data.get("chapter"),
        "id": citation_id
    }

    db.session.execute(sql, citation_params)

    # delete old authors
    db.session.execute(
        text("DELETE FROM citations_authors WHERE citation_id = :id"),
        {"id": citation_id}
    )

    author_string = data["author_string"] or ""
    authors = [a.strip() for a in author_string.split(" and ") if a.strip()]

    for order, name in enumerate(authors, start=1):
        # add new author
        result = db.session.execute(
            text("INSERT INTO authors (name) VALUES (:name) RETURNING id"),
            {"name": name}
        )
        author_id = result.scalar()
        # connect citation and author
        db.session.execute(
            text("""
                INSERT INTO citations_authors (citation_id, author_id, author_order)
                VALUES (:citation_id, :author_id, :order)
            """),
            {"citation_id": citation_id, "author_id": author_id, "order": order}
        )

    db.session.commit()


def get_citation(citation_id):
    result = db.session.execute(
        text("""
            SELECT
                c.id,
                c.citation_key,
                c.title,
                c.type,
                c.publisher,
                c.year,
                c.isbn,
                c.doi,
                c.url,
                c.urldate,
                STRING_AGG(a.name, ' and ' ORDER BY ca.author_order) as author_string,
                c.journal,
                c.booktitle,
                c.pages,
                c.volume,
                c.number,
                c.chapter
            FROM citations c
            LEFT JOIN citations_authors ca ON ca.citation_id = c.id
            LEFT JOIN authors a ON a.id = ca.author_id
            WHERE c.id = :citation_id
            GROUP BY
                c.id,
                c.citation_key,
                c.title,
                c.type,
                c.publisher,
                c.year,
                c.isbn,
                c.doi,
                c.url,
                c.urldate,
                c.journal,
                c.booktitle,
                c.pages,
                c.volume,
                c.number,
                c.chapter
        """),
        {"citation_id": citation_id}
    ).fetchone()

    return result

def delete_citation(citation_id):
    db.session.execute(
        text("DELETE FROM citations_authors WHERE citation_id = :id"),
        {"id": citation_id}
    )

    result = db.session.execute(
        text("DELETE FROM citations WHERE id = :id"),
        {"id": citation_id}
    )
    
    db.session.commit()