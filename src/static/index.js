const filterForm = document.forms["filter-form"];
const filterMinYear = filterForm.elements["min_year"];
const filterMaxYear = filterForm.elements["max_year"];
const filterApplyButton = document.getElementById("filter-apply");
filterApplyButton.disabled = !(filterMinYear.value || filterMaxYear.value);

for (const input of filterForm.elements) {
    input.addEventListener("input", () => {
        const formValid = filterForm.checkValidity();
        const formNotEmpty = filterMinYear.value || filterMaxYear.value;
        const minYear = parseInt(filterMinYear.value)
        const maxYear = parseInt(filterMaxYear.value)
        const minYearNotGreaterThanMaxYear = !(filterMinYear.value && filterMaxYear.value) || minYear <= maxYear;

        filterApplyButton.disabled = !(formValid && formNotEmpty && minYearNotGreaterThanMaxYear);
    });
}
