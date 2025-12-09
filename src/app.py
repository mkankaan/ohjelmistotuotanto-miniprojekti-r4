from flask import redirect, render_template, request, jsonify, flash, session
from db_helper import reset_db, create_test_data
from config import app, test_env, db
from util import request_crossref_data, split_names, get_bibtex, format_doi
from sqlalchemy import text
from repositories.cit_repository import get_citation_dict, get_citations, create_citation, get_citation, update_citation, delete_citation
import markupsafe


@app.template_filter()
def show_lines(content): # pragma: no cover
    content = str(markupsafe.escape(content))
    content = content.replace("\n", "<br />")
    return markupsafe.Markup(content)


@app.route("/")
def index():
    filter_dict = request.args.to_dict()
    citations = get_citations(filter_dict)
    return render_template("index.html", citations=citations, filter_dict=filter_dict)


@app.route("/new_citation")
def new():
    return render_template("new_citation.html")


@app.route("/create_citation", methods=["POST"])
def citation_creation():
    content = request.form.to_dict()
    content = {k: v.strip() for k, v in content.items()}

    if content.get("year", "") == "": # pragma: no cover
        content["year"] = None
    else:
        try:
            content["year"] = int(content["year"])
        except ValueError:
            flash("Year must be a number or left empty.")
            return redirect("/new_citation")

    try:
        split_names(content)
        create_citation(content)
        print("created:", content)
        return redirect("/")
    except Exception as error: # pragma: no cover
        flash(str(error))
        return redirect("/new_citation")


@app.route("/bibtex", methods=["GET"])
def bibtex():
    bibtex_data = session.get("bibtex")
    if not bibtex_data:
        return "No bibtex data found", 404
    return render_template("bibtex.html", bibtex=bibtex_data)


@app.route("/bibtex", methods=["POST"])
def ids_to_bibtex():
    json_ids = request.get_json()
    ids = json_ids.get("data")

    cits = []
    for id in ids:
        cits.append(get_citation_dict(id))
    bibtex = get_bibtex(cits)
    
    session["bibtex"] = bibtex

    return jsonify({"redirect_url": "/bibtex"})


@app.route("/check_citation_key")
def check_citation_key():
    key = request.args.get("key", "").lower()
    sql = text("SELECT 1 FROM citations WHERE lower(citation_key) = :key LIMIT 1")
    result = db.session.execute(sql, {"key": key}).first()
    exists = result is not None
    return jsonify({"exists": exists})

@app.route("/populate-form", methods=["POST"])
def doi_population():
    try:
        data = request.get_json()
        doi = data.get("query")
        doi = format_doi(doi)
        data = request_crossref_data(doi)
        print(data)
    except Exception as error:
        flash(str(error))
        return redirect("/new_citation")

    return jsonify({
        "type": data.get("type"),
        "title": data.get("title")[0] if data.get("title") is not None else "",
        "author": data.get("author"),
        "publisher": data.get("publisher"),
        "year": data.get("created").get("date-parts")[0][0],
        "isbn": data.get("ISBN")[0] if data.get("ISBN") is not None else "",
        "doi": data.get("DOI"),
        "url": data.get("link")[0].get("URL") if data.get("link") is not None else "",
        "booktitle": data.get("container-title")[0] if data.get("container-title") else "",
        "pages": data.get("page") or "",
        "chapter": data.get("article-number") or data.get("chapter") or "",
        "journal": data.get("container-title")[0] if data.get("container-title") else "",
        "volume": data.get("volume") or "",
        "number": data.get("issue") or data.get("number") or "",
    })

@app.route("/edit/<int:citation_id>", methods=["GET", "POST"])
def edit(citation_id):
    citation = get_citation(citation_id)
    print(citation)

    if request.method == "GET":
        return render_template("edit.html", citation=citation)

    if request.method == "POST":
        data = {
            "citation_key": request.form.get("citation_key"),
            "type": request.form.get("type"),
            "title": request.form.get("title"),
            "author": request.form.get("author"),
            "year": request.form.get("year"),
            "publisher": request.form.get("publisher"),
            "isbn": request.form.get("isbn"),
            "doi": request.form.get("doi"),
            "url": request.form.get("url"),
            "urldate": request.form.get("urldate"),
            "author_string": request.form.get("author"),
            "journal": request.form.get("journal"),
            "booktitle": request.form.get("booktitle"),
            "pages": request.form.get("pages"),
            "volume": request.form.get("volume"),
            "number": request.form.get("number"),
            "chapter": request.form.get("chapter"),
        }
        data = {k: (v.strip() if isinstance(v, str) else v) for k, v in data.items()}


        if data.get("year", "") == "": # pragma: no cover
            data["year"] = None
        else:
            try:
                data["year"] = int(data["year"])
            except ValueError:
                flash("Year must be a number or left empty.")
                return redirect("/edit/" + str(citation_id))

        try:
            update_citation(citation_id, data)
            return redirect("/")
        except Exception as error: # pragma: no cover
            flash(str(error))
            return redirect("/edit/" + str(citation_id))

@app.route("/delete/<int:citation_id>", methods=["POST"])
def delete(citation_id):
    print(f"Deleting citation {citation_id}")
    try:
        delete_citation(citation_id)
        return redirect("/")
    except Exception as error: # pragma: no cover
        flash(f"Error deleting citation: {str(error)}")
        return redirect("/")
    
#testausta varten oleva reitti
if test_env: # pragma: no cover
    @app.route("/reset_db")
    def reset_database():
        reset_db()
        return jsonify({ 'message': "db reset" })
    
#testausta varten oleva reitti
if test_env: # pragma: no cover
    @app.route("/test_data")
    def test_data():
        create_test_data()
        return redirect("/")
