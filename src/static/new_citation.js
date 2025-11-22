const form = document.forms[0];
const create_button = document.getElementById("create");
create_button.disabled = true;

for (const input of form.elements) {
    input.addEventListener("input", () => {
        create_button.disabled = !form.checkValidity();
    });
}
