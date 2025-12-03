const edit_form = document.forms["edit-form"];
const save_button = document.getElementById("save");
const edit_citationKeyInput = edit_form.elements["citation_key"];
const edit_urldateInput = edit_form.elements["urldate"];
const errorSpan = document.getElementById("ck-error") || document.createElement("span");

save_button.disabled = true;

const updateButtonState = () => {
    save_button.disabled = !edit_form.checkValidity();
};

document.addEventListener("DOMContentLoaded", () => {
    const typeSelect = document.getElementById("edit_type");
    const fields = document.querySelectorAll(".bibtex-field");
    const selectedTypeInput = document.getElementById("selected_type");

    if (typeSelect.options.length === 0) {
        typeOptions.forEach(option => {
            const opt = document.createElement("option");
            opt.value = option.value;
            opt.textContent = option.label;
            typeSelect.appendChild(opt);
        });
    }

    if (selectedTypeInput && selectedTypeInput.value) {
        typeSelect.value = selectedTypeInput.value;
    }

    function updateFields() {
        const selected = typeSelect.value;
        const allowed = new Set(fieldsByType[selected] || []);

        fields.forEach(f => {
            const name = f.dataset.name;
            if (allowed.has(name)) {
                f.style.display = "";
            } else {
                f.style.display = "none";
            }
        });
    }

    typeSelect.addEventListener("change", () => {
        updateFields();
        updateButtonState();
    });

    updateFields();
    updateButtonState();
});

document.addEventListener("change", updateButtonState);

edit_citationKeyInput.addEventListener("input", citationKeyListener);
edit_urldateInput.addEventListener("input", urldateInputListener);

for (const input of edit_form.elements) {
    if (input !== edit_citationKeyInput) {
        input.addEventListener("input", updateButtonState);
    }
}
