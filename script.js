// Трекер дней рождения: добавление человека и список

let people = [];
let nextId = 1;

const form = document.getElementById('personForm');
const nameInput = document.getElementById('nameInput');
const birthInput = document.getElementById('birthInput');
const message = document.getElementById('message');
const personList = document.getElementById('personList');

function showMessage(text) {
  message.textContent = text;
}

// Превращаем 2000-05-17 в 17.05.2000
function formatDate(iso) {
  const [year, month, day] = iso.split('-');
  return `${day}.${month}.${year}`;
}

function addPerson(event) {
  event.preventDefault();

  const name = nameInput.value.trim();
  const birth = birthInput.value; // формат ГГГГ-ММ-ДД

  // Валидация: проверяем, что поля заполнены
  if (name.length < 2) {
    showMessage('Введите ФИО (не меньше 2 символов).');
    return;
  }
  if (!birth) {
    showMessage('Укажите дату рождения.');
    return;
  }

  people.push({ id: nextId++, name: name, birth: birth });

  // Очищаем форму и возвращаем фокус
  nameInput.value = '';
  birthInput.value = '';
  showMessage('');
  renderList();
  nameInput.focus();
}

function renderList() {
  personList.innerHTML = '';

  if (people.length === 0) {
    const empty = document.createElement('li');
    empty.className = 'empty';
    empty.textContent = 'Список пуст. Добавьте первого человека.';
    personList.appendChild(empty);
    return;
  }

  people.forEach(function (person) {
    const li = document.createElement('li');

    const info = document.createElement('span');
    info.textContent = `${person.name} — ${formatDate(person.birth)}`;
    li.appendChild(info);

    personList.appendChild(li);
  });
}

form.addEventListener('submit', addPerson);
renderList();
