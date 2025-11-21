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

def generate_bibtex(citations):
    return ",\n".join(generate_citation(c) for c in citations)

def generate_citation(citation):
    s = "@" + citation["type"]
    return s
