
CREATE TABLE citations (
  id SERIAL PRIMARY KEY,
  type TEXT NOT NULL,            -- esim. 'book', 'article', 'webpage'
  title TEXT NOT NULL,
  year INTEGER,
  publisher TEXT,
  isbn TEXT,
  doi TEXT,
  url TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE authors (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL
);

CREATE TABLE citations_authors (
  citation_id INTEGER REFERENCES citations(id) ON DELETE CASCADE,
  author_id INTEGER REFERENCES authors(id) ON DELETE CASCADE,
  author_order INTEGER, 
  PRIMARY KEY (citation_id, author_id)
);
