const create_form = document.forms["creation-form"];
const create_button = document.getElementById("create");
const create_citationKeyInput = create_form.elements["citation_key"];
const create_urldateInput = create_form.elements["urldate"];
const errorSpan = document.getElementById("ck-error");
const doi_form = document.forms["doi-populate-form"]
const populate_button = document.getElementById("submit-doi")
const create_clear_button = document.getElementById("create-clear")
populate_button.disabled = true;
create_button.disabled = true;
create_clear_button.disabled = true;

const updateButtonState = () => {
    const ckValid = create_citationKeyInput.checkValidity();

    const formValid = create_form.checkValidity();

    create_button.disabled = !(ckValid && formValid);
    populate_button.disabled = !doi_form.checkValidity();
};

document.addEventListener('DOMContentLoaded', () => {
    const typeSelect = document.getElementById('type');
    const fields = document.querySelectorAll('.bibtex-field');

    if (typeSelect.options.length === 0) {
        typeOptions.forEach(opt => {
            const o = document.createElement('option');
            o.value = opt.value;
            o.textContent = opt.label;
            typeSelect.appendChild(o);
        });
    }

    function updateFields() {
        const selected = typeSelect.value;
        const allowed = new Set(fieldsByType[selected] || []);

        fields.forEach(f => {
            const name = f.dataset.name;
            if (allowed.has(name)) {
                f.style.display = '';
            } else {
                f.style.display = 'none';
            }
        });
    }

    typeSelect.addEventListener('change', updateFields);
    updateFields();
    updateButtonState();
});

document.addEventListener("change", updateButtonState)

create_citationKeyInput.addEventListener("input", citationKeyListener);
create_urldateInput.addEventListener("input", urldateInputListener);


for (const input of create_form.elements) {
    if (input !== create_citationKeyInput) {
        input.addEventListener("input", updateButtonState);
    }
}


for (const doi_input of doi_form.elements) {
    doi_input.addEventListener("input", () => {
        doi_input.addEventListener("input", updateButtonState);
    });
}

document.getElementById('doi-populate-form').addEventListener('submit', function(e) {
    e.preventDefault();
    const doi = document.getElementById('doi-populate').value;

    fetch('/populate-form', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({query: doi})
    })
    .then(response => response.json())
    .then(data => {
        if (typeOptions.some(option => option.value === data.type)) {
            document.getElementById('type').value = data.type;        
        } else {
            document.getElementById('type').value = 'misc'
        }
        document.getElementById('title').value = data.title;
        document.getElementById('author').value = data.author;
        document.getElementById('publisher').value = data.publisher;
        document.getElementById('year').value = data.year;
        document.getElementById('isbn').value = data.isbn;
        document.getElementById('doi').value = data.doi;
        document.getElementById('url').value = data.url;
        document.getElementById('booktitle').value = data.booktitle || '';
        document.getElementById('pages').value = data.pages || '';
        document.getElementById('chapter').value = data.chapter || '';
        document.getElementById('journal').value = data.journal || '';
        document.getElementById('volume').value = data.volume || '';
        document.getElementById('number').value = data.number || '';
    })
    .then(() => {
        const typeSelect = document.getElementById('type');
        typeSelect.dispatchEvent(new Event('change', { bubbles: true }));
        document.dispatchEvent(new Event('change', { bubbles: true }));
    }).then(() => {
        updateClearButtonState();
    });
});

create_form.addEventListener("submit", async function (e) {
    const ck = create_citationKeyInput.value;
    const unique = await isCitationKeyUnique(ck);

    if (!unique) {
        create_citationKeyInput.setCustomValidity("Citation key already in use.");
        errorSpan.textContent = "Citation key already in use.";
    } else {
        create_citationKeyInput.setCustomValidity("");
        if (errorSpan.textContent === "Citation key already in use.") {
            errorSpan.textContent = "";
        }
    }

    updateButtonState();

    if (!create_form.checkValidity()) {
        e.preventDefault();
        create_form.reportValidity();
        return;
    }
});

for (const input of create_form.elements) {
    input.addEventListener("input", updateClearButtonState);
};

function updateClearButtonState() {
    const fields = Array.from(create_form.elements).filter(e => e.getAttribute('type') === 'text')
    const filled = fields.map(field => field.value.length).reduce((sum, l) => sum += l)
    create_clear_button.disabled = filled === 0;
};

create_clear_button.addEventListener("click", () => {
    create_form.reset();
    doi_form.reset();
});

updateClearButtonState();