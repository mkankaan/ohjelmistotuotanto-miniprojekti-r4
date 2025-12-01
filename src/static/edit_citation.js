const edit_form = document.forms["edit-form"];
const save_button = document.getElementById("save");
const edit_citationKeyInput = edit_form.elements["citation_key"];
const edit_urldateInput = edit_form.elements["urldate"];
save_button.disabled = true;


const updateButtonState = () => {
    save_button.disabled = !edit_form.checkValidity();
}


document.addEventListener("DOMContentLoaded", () => {
    const selectElement = document.getElementById("edit_type");
    typeOptions.forEach(option => {
        const opt = document.createElement("option");
        opt.value = option.value;
        opt.textContent = option.label;
        selectElement.appendChild(opt);

    updateButtonState()
    });
});


document.addEventListener("change", updateButtonState)

edit_citationKeyInput.addEventListener("input", citationKeyListener);
edit_urldateInput.addEventListener("input", urldateInputListener);


for (const input of edit_form.elements) {
    if (input !== edit_citationKeyInput) {
        input.addEventListener("input", updateButtonState);
    }
}
