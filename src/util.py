class UserInputError(Exception):
    pass

def split_names(content):
    if content["author"].find(" and ") == -1:
        content["author"] = [content["author"]]
        return
    name_list = content["author"].split(" and ")
    content["author"] = name_list

def format_authors(author_list):
    return " and ".join(author_list)

def get_bibtex(citations):
    return "\n\n".join(citation_bibtex(c) for c in citations)

def citation_bibtex(citation):
    s = f"@{citation["type"]}{{{citation["citation_key"]},\n"
    fields = [bibtex_field(key, value) for key, value in citation.items() if value and key is not "citation_key" and key is not "type"]
    s += ",\n".join(fields)
    return s + "\n}"

def bibtex_field(key, value):
    return f"\xa0{key} = {{{value}}}"

def citation_as_dict(citation, authors):
    return {
            "citation_key": citation[1],
            "title": citation[2],
            "type": citation[3],
            "author": authors,
            "publisher": citation[4],
            "year": citation[5],
            "isbn": citation[6],
            "doi": citation[7],
            "url": citation[8],
    }
