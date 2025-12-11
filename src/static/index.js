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

const deleteCitation = async (item) => {
  item.parentNode.removeChild(item)
  const citAmount = document.querySelectorAll('.list-item').length;
  document.getElementById('cit-amount').innerText = 'Amount of citations: ' + citAmount
  const selectedAmount = document.querySelectorAll('.list-item.selected').length;
  document.getElementById('selected-amount').innerText = 'Citations selected: ' + selectedAmount;
  document.getElementById('generate-bibtex').disabled = (selectedAmount === 0);
  document.getElementById('delete-selected').disabled = (selectedAmount === 0);
  
  fetch('/delete/' + item.dataset.id, {
    method: 'DELETE'
  })
}


document.querySelectorAll('.list-item').forEach(item => {
  item.addEventListener('click', () => {
    if (event.target.id === 'delete') {
      if (confirm("You are about to delete a citation.") == true) {
        deleteCitation(item)
      } else {
        return
      }
    }
    
    if (event.target.tagName === 'BUTTON' || event.target.closest('button')) {
      return
    }
    item.classList.toggle('selected');

    const selectedAmount = document.querySelectorAll('.list-item.selected').length;
    document.getElementById('selected-amount').innerText = 'Citations selected: ' + selectedAmount;
    document.getElementById('generate-bibtex').disabled = (selectedAmount === 0);
    document.getElementById('delete-selected').disabled = (selectedAmount === 0);
  });
});

document.getElementById('select-all').addEventListener('click', () => {
  document.querySelectorAll('.list-item').forEach(item => {
    if (!item.classList.contains('selected')) {
      item.classList.toggle('selected')
      const selectedAmount = document.querySelectorAll('.list-item.selected').length;
      document.getElementById('selected-amount').innerText = 'Citations selected: ' + selectedAmount;
      document.getElementById('generate-bibtex').disabled = (selectedAmount === 0);
      document.getElementById('delete-selected').disabled = (selectedAmount === 0);
    }
  });
});

document.getElementById('deselect-all').addEventListener('click', () => {
  document.querySelectorAll('.list-item').forEach(item => {
    if (item.classList.contains('selected')) {
      item.classList.toggle('selected')
      const selectedAmount = document.querySelectorAll('.list-item.selected').length;
      document.getElementById('selected-amount').innerText = 'Citations selected: ' + selectedAmount;
      document.getElementById('generate-bibtex').disabled = (selectedAmount === 0);
      document.getElementById('delete-selected').disabled = (selectedAmount === 0);
    }
  });
});

document.getElementById('delete-selected').addEventListener('click', () => {
  const selectedAmount = document.querySelectorAll('.list-item.selected').length;
  if (confirm('You are about to delete ' + selectedAmount + ' citations.') == true) {
    document.querySelectorAll('.list-item.selected').forEach(item => {
      deleteCitation(item)
  })
  };
});

document.querySelector('#generate-bibtex').addEventListener('click', () => {
  const selectedItems = document.querySelectorAll('.list-item.selected');
  const selectedIds = Array.from(selectedItems).map(item => item.dataset.id);
  
  fetch('/bibtex', {
    method: 'POST',
    headers: {'Content-Type': 'application/json'},
    body: JSON.stringify({ data: selectedIds })
  })
  .then(response => response.json())
  .then(result => {
    window.location.href = result.redirect_url;
  })
  .catch(error => {
    alert('Failed to generate BibTeX. Please try again later.');
    console.error('Error generating BibTeX:', error);
  });
});
