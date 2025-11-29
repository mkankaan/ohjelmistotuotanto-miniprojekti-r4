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

document.querySelector('#generateBibTex').addEventListener('click', () => {
  const selectedItems = document.querySelectorAll('.list-item.selected');
  const selectedKeys = Array.from(selectedItems).map(item => item.dataset.id);

      
  }
});
