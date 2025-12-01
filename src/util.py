import requests
import re

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
    fields = [bibtex_field(key, value) for key, value in citation.items()
              if value
              and key != "citation_key"
              and key != "type"
              and key != "id"]
    s += ",\n".join(fields)
    return s + "\n}"

def bibtex_field(key, value):
    return f"\xa0{key} = {{{value}}}"

def citation_as_dict(citation, authors):
    return {
            "id": citation[0],
            "citation_key": citation[1],
            "title": citation[2],
            "type": citation[3],
            "author": authors,
            "publisher": citation[4],
            "year": citation[5],
            "isbn": citation[6],
            "doi": citation[7],
            "url": citation[8],
            "urldate": citation[9]
    }

def format_doi(doi):
    pattern = r'10\.(?:[1-9]\d{3,}(?:[.\d]*)?)/[A-Za-z0-9._-]+'

    match = re.search(pattern, doi)
    match = match.group()
    match.replace("/", "%2F")
    return match

def authors_to_list(auths):
    auth_list = []
    for auth in auths:
        name = f"{auth.get("given")} {auth.get("family")}"
        auth_list.append(name)
    return auth_list

def request_crossref_data(doi):
    url = "https://api.crossref.org/works/"
    url += doi

    response = requests.get(url)
    response.raise_for_status()
    message = response.json().get("message")

    auth_list = authors_to_list(message.get("author"))
    message["author"] = format_authors(auth_list)

    return message

