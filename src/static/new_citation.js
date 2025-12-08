const create_form = document.forms["creation-form"];
const create_button = document.getElementById("create");
const create_citationKeyInput = create_form.elements["citation_key"];
const create_urldateInput = create_form.elements["urldate"];
const errorSpan = document.getElementById("ck-error");
const doi_form = document.forms["doi-populate-form"]
const populate_button = document.getElementById("submit-doi")
populate_button.disabled = true;
create_button.disabled = true;

const updateButtonState = () => {
    const ckValid = create_citationKeyInput.checkValidity();

    const formValid = create_form.checkValidity();

    create_button.disabled = !(ckValid && formValid);
    populate_button.disabled = !doi_form.checkValidity();
};

const generateCkCheckbox = document.getElementById('generate_ck');
const citationKeyField = document.getElementById('citation_key');

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

    create_citationKeyInput.addEventListener("input", citationKeyListener);
    create_urldateInput.addEventListener("input", urldateInputListener);

    typeSelect.addEventListener('change', updateFields);
    updateFields();
    updateButtonState();
});

document.addEventListener("change", updateButtonState)



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
    });
});

//create_form.addEventListener("submit", async function (e) {
//    const ck = create_citationKeyInput.value;
//    const unique = await isCitationKeyUnique(ck);
//
//    if (!unique) {
//        create_citationKeyInput.setCustomValidity("Citation key already in use.");
//        errorSpan.textContent = "Citation key already in use.";
//    } else {
//        create_citationKeyInput.setCustomValidity("");
//        if (errorSpan.textContent === "Citation key already in use.") {
//            errorSpan.textContent = "";
//        }
//    }
//
//    updateButtonState();
//
//    if (!create_form.checkValidity()) {
//        e.preventDefault();
//        create_form.reportValidity();
//        return;
//    }
//});

async function generateCitationKey() {
    const title = document.getElementById('title').value.trim();
    const yearInput = document.getElementById('year').value.trim();

    if (!title) return '';

    const cleanTitle = title.replace(/\s+/g, '').toLowerCase();
    let baseKey = cleanTitle.substring(0, yearInput ? 4 : 8);

    let key = yearInput ? `${baseKey}${yearInput}` : baseKey;

    let counter = 1;
    while (!(await isCitationKeyUnique(key))) {
        key = yearInput ? `${baseKey}${yearInput}${counter}` : `${baseKey}${counter}`;
        counter++;
        if (counter > 100) break;
    }

    return key;
}


generateCkCheckbox.addEventListener('change', async function () {
    if (this.checked) {
        citationKeyField.readOnly = true;
        citationKeyField.style.backgroundColor = '#f0f0f0';
        citationKeyField.style.opacity = '0.6';
        citationKeyField.style.cursor = 'not-allowed';


        const generatedKey = await generateCitationKey();
        if (generatedKey) {
            citationKeyField.value = generatedKey;
            citationKeyListener.call(citationKeyField);
        }
    } else {
        citationKeyField.readOnly = false;
        citationKeyField.style.backgroundColor = '';
        citationKeyField.style.opacity = '1';
        citationKeyField.style.cursor = '';
        citationKeyField.focus();
    }
    updateButtonState();
});

document.getElementById('title').addEventListener('input', async function () {
    if (generateCkCheckbox.checked) {
        const generatedKey = await generateCitationKey();
        if (generatedKey) {
            citationKeyField.value = generatedKey;
            citationKeyListener.call(citationKeyField);
        }
    }
});

document.getElementById('year').addEventListener('input', async function () {
    if (generateCkCheckbox.checked) {
        const generatedKey = await generateCitationKey();
        if (generatedKey) {
            citationKeyField.value = generatedKey;
            citationKeyListener.call(citationKeyField);
        }
    }
});