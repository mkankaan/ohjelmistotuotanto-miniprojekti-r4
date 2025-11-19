from flask import redirect, render_template, request, jsonify, flash
from db_helper import reset_db
from repositories.cit_repository import get_citations, create_citation
from config import app, test_env
from util import split_names

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
    if content.get("year", "") == "":
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
    except Exception as error:
        flash(str(error))
        return  redirect("/new_citation")


# testausta varten oleva reitti
if test_env:
    @app.route("/reset_db")
    def reset_database():
        reset_db()
        return jsonify({ 'message': "db reset" })
