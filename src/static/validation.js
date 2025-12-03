let lastCkChecked = "";

async function citationKeyListener(e) {
    const key = this.value;
    lastCkChecked = key;

    if (!key) {
        this.setCustomValidity("");
        errorSpan.textContent = "";
        updateButtonState();
        return;
    }

    if (key.match(/.*[,@~#%{}]+.*/)) {
        this.setCustomValidity("Character not allowed.");
        errorSpan.textContent = "Character not allowed.";
        updateButtonState();
        return;
    }

    const response = await fetch('/check_citation_key?key=' + encodeURIComponent(key));
    const data = await response.json();

    if (this.value !== lastCkChecked) {
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
}

async function isCitationKeyUnique(key) {
    if (!key) {
        return true;
    }
    if (key.match(/.*[,@~#%{}]+.*/)) {
        return false;
    }
    const response = await fetch('/check_citation_key?key=' + encodeURIComponent(key));
    const data = await response.json();
    return !data.exists;
}



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

