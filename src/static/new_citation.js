const form = document.forms[0];
const create_button = document.getElementById("create");
create_button.disabled = true;

const possibly_invalid_input_ids = ["title", "year"];

for (const id of possibly_invalid_input_ids) {
    document.getElementById(id).addEventListener("input", () => {
        create_button.disabled = !form.checkValidity();
    });
}
