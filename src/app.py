from flask import redirect, render_template, request, jsonify, flash
from db_helper import reset_db
from repositories.cit_repository import get_citations, create_citation
from config import app, test_env
from util import split_names, get_bibtex
from sqlalchemy import exc
import markupsafe


@app.template_filter()
def show_lines(content):
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
    except exc.IntegrityError: # pragma: no cover
        flash(f"Key {content["citation_key"]} already in use")
        return redirect("/new_citation")
    except Exception as error: # pragma: no cover
        flash(str(error))
        return  redirect("/new_citation")


@app.route("/bibtex")
def bibtex():
    bibtex = get_bibtex(get_citations())
    return render_template("bibtex.html", bibtex=bibtex)


# testausta varten oleva reitti
if test_env: # pragma: no cover
    @app.route("/reset_db")
    def reset_database():
        reset_db()
        return jsonify({ 'message': "db reset" })
