const edit_form = document.forms["edit-form"];
const save_button = document.getElementById("save");
const edit_citationKeyInput = edit_form.elements["citation_key"];
const edit_urldateInput = edit_form.elements["urldate"];
save_button.disabled = true;

let lastCheckedKey = "";

const typeOptions = [
    { value: 'article', label: 'Article' },
    { value: 'book', label: 'Book' },
    { value: 'inproceedings', label: 'Conference' },
    { value: 'book-chapter', label: 'Book Chapter' },
    { value: 'misc', label: 'Other' }
];


const updateButtonState = () => {
    save_button.disabled = !edit_form.checkValidity();
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

create_citationKeyInput.addEventListener("input", citationKeyListener);
edit_citationKeyInput.addEventListener("input", async function () {
    console.log(this.value)
});

create_urldateInput.addEventListener("input", urldateInputListener);

async function urldateInputListener(e) {
    const urldate = this.value;

    if (!urldate) {
        this.setCustomValidity("");
        errorSpan.textContent = "";
        updateButtonState();
        return;
    }
   
    if (is_valid_date(urldate)) {
        this.setCustomValidity("");
        errorSpan.textContent = "";
    } else {
        this.setCustomValidity("Invalid date.");
        errorSpan.textContent = "Invalid date.";
    }
    updateButtonState();
}

const is_valid_date = date_str => {
    if(!/^\d{1,2}\.\d{1,2}\.\d{1,}$/.test(date_str))
        return false

    let parts = date_str.split(".");
    let d = parseInt(parts[0])
    let m = parseInt(parts[1])
    let y = parseInt(parts[2])
    date = new Date([y, m, d].join("-") + " 00:00:00")

    if(isNaN(date)) {
        return false
    }

    if ((m < 1) || (m > 12)) return false

    if (m == 2) {
        if (((y % 4 == 0) && (year % 100 != 0)) || (y % 400 == 0)) {
            if (d > 29) return false
        } else {
            if (d > 28) return false
        }
    } else if (m in [1, 3, 5, 7, 8, 10, 12]) {
        if (d > 31) return false
    } else {
        if (d > 30) return false
    }
    return !(date > new Date())
}

for (const input of create_form.elements) {
    if (input !== create_citationKeyInput) {
        input.addEventListener("input", updateButtonState);
    }
}

for (const input of edit_form.elements) {
    if (input !== edit_citationKeyInput) {
        input.addEventListener("input", updateButtonState);
    }
}