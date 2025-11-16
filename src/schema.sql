CREATE TABLE todos (
  id SERIAL PRIMARY KEY, 
  content TEXT NOT NULL,
  done BOOLEAN DEFAULT FALSE
);
CREATE TABLE citations (
  id SERIAL PRIMARY KEY,
  type TEXT NOT NULL,            -- esim. 'book', 'article', 'webpage'
  title TEXT NOT NULL,
  author TEXT,
  year INTEGER,
  publisher TEXT,
  isbn TEXT,
  doi TEXT,
  url TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
