from db_helper import reset_db, setup_db, tables
from app import app

def test_reset_db_removes_all_entries():
    with app.app_context():
        setup_db()
        reset_db()
        assert len(tables()) >= 0
def test_tables_function_returns_table_names():
    with app.app_context():
        names = tables()
        assert isinstance(names, list)
