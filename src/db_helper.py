import os
from sqlalchemy import text
from config import db, app
from repositories.cit_repository import create_citation # for creating test data

def reset_db():
    print("Clearing contents from tables citations, authors and citations_authors")
    sql = text("DELETE FROM citations_authors")
    db.session.execute(sql)
    db.session.commit()
    sql = text("DELETE FROM citations")
    db.session.execute(sql)
    db.session.commit()
    sql = text("DELETE FROM authors")
    db.session.execute(sql)
    db.session.commit()

def tables():
    """Returns all table names from the database except those ending with _id_seq"""
    sql = text(
      "SELECT table_name "
      "FROM information_schema.tables "
      "WHERE table_schema = 'public' "
      "AND table_name NOT LIKE '%_id_seq'"
    )
    result = db.session.execute(sql)
    return [row[0] for row in result.fetchall()]

def setup_db():
    """
      Creating the database
      If database tables already exist, those are dropped before the creation
    """
    tables_in_db = tables()
    if len(tables_in_db) > 0:
        print(f"Tables exist, dropping: {', '.join(tables_in_db)}")
        for table in tables_in_db:
            sql = text(f"DROP TABLE {table} CASCADE")
            db.session.execute(sql)
        db.session.commit()
    print("Creating database")
    # Read schema from schema.sql file
    schema_path = os.path.join(os.path.dirname(__file__), 'schema.sql')
    with open(schema_path, 'r') as f:
        schema_sql = f.read().strip()
    sql = text(schema_sql)
    db.session.execute(sql)
    db.session.commit()

# for creating test data
cits = [
     {
        'citation_key': 'mckinney',
        'type': 'article',
        'title': 'Data Structures for Statistical Computing in Python',
        'author': ['Wes McKinney'],
        'year': 2010,
        'publisher': '',
        'journal': 'Proceedings of the 9th Python in Science Conference',
        'pages': '56-61',
        'volume': 9,
        'isbn': '',
        'doi': '10.25080/Majora-92bf1922-00a',
        'url': '',
        'urldate': '19.10.2023'
    },
    {
        'citation_key': 'compesato1',
        'type': 'book-chapter',
        'title': 'Chapter 3: Data Structures in Python',
        'author': ['Oswald Campesato'],
        'year': 2022,
        'publisher': 'Mercury Learning and Information',
        'booktitle': 'Python for Programmers',
        'pages': '65-106',
        'chapter': 3,
        'isbn': '9781683928164',
        'doi': '10.1515/9781683928164-004',
        'url': '',
        'urldate': '04.12.2023'
    },
    {
        'citation_key': 'fletcher-gardner2012',
        'type': 'book-chapter',
        'title': 'Extending Python from C++',
        'author': ['S. Fletcher', 'C. Gardner'],
        'year': 2012,
        'publisher': 'John Wiley & Sons, Ltd',
        'booktitle': 'Financial Modelling in Python',
        'pages': '11-26',
        'chapter': 3,
        'isbn': '',
        'doi': '10.1002/9780470685006.ch3',
        'url': 'https://onlinelibrary.wiley.com/doi/abs/10.1002/9780470685006.ch3',
        'urldate': '20.10.2023'
    },
    {
        'citation_key': 'berryd2016',
        'type': 'book',
        'title': 'The philosophy of software : code and mediation in the digital age',
        'author': ['Berry, David M.'],
        'year': 2016,
        'publisher': 'Palgrave Macmillan',
        'isbn': '978-0-230-24418-4',
        'doi': '',
        'url': '',
        'urldate': ''
    },
    {
        'citation_key': 'krebber-barthels-bientinesi',
        'type': 'inproceedings',
        'title': 'Efficient Pattern Matching in Python',
        'author': ['Krebber, Manuel', 'Barthels, Henrik', 'Bientinesi, Paolo'],
        'year': 2017,
        'publisher': 'Association for Computing Machinery',
        'booktitle': 'Proceedings of the 7th Workshop on Python for High-Performance and Scientific Computing',
        'isbn': '9781450351249',
        'doi': '10.1145/3149869.3149871',
        'url': '',
        'urldate': '5.10.2024'
    },
    {
        'citation_key': '',
        'type': '',
        'title': '',
        'author': [''],
        'year': 0,
        'publisher': '',
        'isbn': '',
        'doi': '',
        'url': '',
        'urldate': ''
    }
]

# for creating test data
def create_test_data():
    reset_db()
    for c in cits:
        create_citation(c)

if __name__ == "__main__":
    with app.app_context():
        setup_db()
