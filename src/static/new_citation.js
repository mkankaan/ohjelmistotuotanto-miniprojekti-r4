const form = document.forms["creation-form"];
const create_button = document.getElementById("create");
const citationKeyInput = form.elements["citation_key"];
const urldateInput = form.elements["urldate"];
const errorSpan = document.getElementById("ck-error");
const doi_form = document.forms["doi-populate-form"]
const populate_button = document.getElementById("submit-doi")
populate_button.disabled = true;
create_button.disabled = true;

let lastCheckedKey = "";


const typeOptions = [
    { value: 'article', label: 'Article' },
    { value: 'book', label: 'Book' },
    { value: 'inproceedings', label: 'Conference' },
    { value: 'book-chapter', label: 'Book Chapter' },
    { value: 'misc', label: 'Other' }
];


const updateButtonState = () => {
    create_button.disabled = !form.checkValidity();
    populate_button.disabled = !doi_form.checkValidity();
}


document.addEventListener('DOMContentLoaded', () => {
    const selectElement = document.getElementById('type');
    typeOptions.forEach(option => {
        const opt = document.createElement('option');
        opt.value = option.value;
        opt.textContent = option.label;
        selectElement.appendChild(opt);

    updateButtonState()
    });
});


document.addEventListener("change", updateButtonState)


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

urldateInput.addEventListener("input", async function() {
    const urldate = this.value;
    console.log(urldate)

    if (!urldate) {
        this.setCustomValidity("");
        errorSpan.textContent = "";
        updateButtonState();
        console.log("no urldate")
        return;
    }

    if(!/^\d{1,2}\.\d{1,2}\.\d{1,}$/.test(urldate)) {
        this.setCustomValidity("Not a valid date");
        errorSpan.textContent = "Not a valid date";
        console.log("not valid date")
    } else {
        this.setCustomValidity("");
        errorSpan.textContent = "";
        console.log("date ok")
    }
    updateButtonState();


    // let parts = urldate.split(".");

    // if(!isNaN(new Date([parseInt(parts[1]), parts[0], parts[2]].join("/"))))




    /*
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
    */
});


for (const input of form.elements) {
    if (input !== citationKeyInput) {
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
    })
    .then(() => {
        document.dispatchEvent(new Event('change', { bubbles: true }))
    });
});
