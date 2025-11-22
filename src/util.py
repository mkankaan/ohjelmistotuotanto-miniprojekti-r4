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
    return ",\n".join(cit_bibtex(c) for c in citations)

def cit_bibtex(citation):
    s = "@" + citation["type"] + "{"
    return s + "}"
