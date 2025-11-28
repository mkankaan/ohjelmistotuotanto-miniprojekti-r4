from flask import redirect, render_template, request, jsonify, flash
from db_helper import reset_db
from config import app, test_env, db
from util import request_crossref_data, split_names, get_bibtex, format_doi, type_options
from sqlalchemy import exc, text
from repositories.cit_repository import get_citations, create_citation, get_citation, update_citation
import markupsafe


@app.template_filter()
def show_lines(content): # pragma: no cover
    content = str(markupsafe.escape(content))
    content = content.replace("\n", "<br />")
    return markupsafe.Markup(content)


@app.route("/")
def index():
    citations = get_citations()
    return render_template("index.html", citations=citations)


@app.route("/new_citation")
def new():
    return render_template("new_citation.html")


@app.route("/create_citation", methods=["POST"])
def citation_creation():
    content = request.form.to_dict()
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
        return redirect("/")
    except Exception as error: # pragma: no cover
        flash(str(error))
        return redirect("/new_citation")

@app.route("/bibtex")
def bibtex():
    bibtex = get_bibtex(get_citations())
    return render_template("bibtex.html", bibtex=bibtex)


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

    })


# testausta varten oleva reitti
@app.route("/edit/<int:citation_id>", methods=["GET", "POST"])
def edit(citation_id):
    citation = get_citation(citation_id)
    print(citation)

    if request.method == "GET":
        return render_template("edit.html", citation=citation, type_options=type_options)

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
            "author_string": request.form.get("author"),
        }

        update_citation(citation_id, data)
        return redirect("/")

#testausta varten oleva reitti
if test_env: # pragma: no cover
    @app.route("/reset_db")
    def reset_database():
        reset_db()
        return jsonify({ 'message': "db reset" })
