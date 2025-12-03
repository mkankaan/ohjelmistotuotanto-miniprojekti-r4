document.querySelectorAll('.list-item').forEach(item => {
    item.addEventListener('click', () => {
      if (event.target.tagName === 'BUTTON' || event.target.closest('button')) {
        return
      }
        item.classList.toggle('selected');

        const selectedAmount = document.querySelectorAll('.list-item.selected').length;
        document.getElementById('selected-amount').innerText = 'Citations selected: ' + selectedAmount;
        document.getElementById('generate-bibtex').disabled = (selectedAmount === 0);
    });
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
  });
});
