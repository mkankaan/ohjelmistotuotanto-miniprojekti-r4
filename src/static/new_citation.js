const form = document.forms[0];
const create_button = document.getElementById("create");
const citationKeyInput = form.elements["citation_key"];
const errorSpan = document.getElementById("ck-error");

create_button.disabled = true;

let lastCheckedKey = "";

citationKeyInput.addEventListener("input", async function() {
    const key = this.value;
    lastCheckedKey = key;

    if (!key) {
        this.setCustomValidity("");
        errorSpan.textContent = "";
        updateButtonState();
        return;
    }

    const response = await fetch('/check_citation_key?key=' + encodeURIComponent(key));
    const data = await response.json();

    if (this.value !== lastCheckedKey) {
        return;
    }

    if (data.exists) {
        this.setCustomValidity("Citation key already in use.");
        errorSpan.textContent = "Citation key already in use.";
    } else {
        this.setCustomValidity("");
        errorSpan.textContent = "";
    }
    updateButtonState();
});



for (const input of form.elements) {
    if (input !== citationKeyInput) {
        input.addEventListener("input", updateButtonState);
    }
}

function updateButtonState() {
    create_button.disabled = !form.checkValidity();
}


const doi_form = document.forms["doi-populate-form"]
const populate_button = document.getElementById("submit-doi")
populate_button.disabled = true;

for (const doi_input of doi_form.elements) {
    doi_input.addEventListener("input", () => {
        populate_button.disabled = !doi_form.checkValidity();
    });
}
