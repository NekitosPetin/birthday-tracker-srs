-- НОРМАЛИЗОВАННАЯ СХЕМА (3NF) ДЛЯ SQLITE
-- Приложение «Трекер дней рождения»
PRAGMA foreign_keys = ON;

-- Люди, чьи дни рождения мы отслеживаем
CREATE TABLE Contacts (
    contact_id INTEGER PRIMARY KEY AUTOINCREMENT,
    full_name  TEXT NOT NULL CHECK (length(full_name) BETWEEN 2 AND 100),
    birth_date TEXT NOT NULL
               CHECK (date(birth_date) IS NOT NULL
                      AND date(birth_date) = birth_date
                      AND birth_date >= '1900-01-01'),
    created_at TEXT NOT NULL DEFAULT (datetime('now'))
);

-- Категории контактов: «Семья», «Друзья», «Коллеги»
CREATE TABLE Categories (
    category_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name        TEXT NOT NULL UNIQUE,
    description TEXT
);

-- Связь «многие-ко-многим»: человек может входить в несколько категорий
CREATE TABLE Contact_Categories (
    contact_id  INTEGER NOT NULL,
    category_id INTEGER NOT NULL,
    PRIMARY KEY (contact_id, category_id),
    FOREIGN KEY (contact_id)  REFERENCES Contacts(contact_id)     ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)  ON DELETE CASCADE
);

-- Справочник статусов подарка
CREATE TABLE Gift_Statuses (
    status_id INTEGER PRIMARY KEY,
    name      TEXT NOT NULL UNIQUE
);

-- Идеи подарков: каждая идея принадлежит одному человеку
CREATE TABLE Gift_Ideas (
    idea_id    INTEGER PRIMARY KEY AUTOINCREMENT,
    contact_id INTEGER NOT NULL,
    title      TEXT NOT NULL CHECK (length(title) > 0),
    note       TEXT,
    status_id  INTEGER NOT NULL DEFAULT 1,
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    FOREIGN KEY (contact_id) REFERENCES Contacts(contact_id)       ON DELETE CASCADE,
    FOREIGN KEY (status_id)  REFERENCES Gift_Statuses(status_id)   ON DELETE RESTRICT
);

-- Справочные данные: три статуса из ТЗ (п. 2.2)
INSERT INTO Gift_Statuses (status_id, name) VALUES
    (1, 'запланирован'),
    (2, 'куплен'),
    (3, 'подарен');

-- Индексы для оптимизации запросов
CREATE INDEX idx_contacts_full_name      ON Contacts(full_name);                      -- поиск по имени
CREATE INDEX idx_contacts_birth_month_day ON Contacts(strftime('%m-%d', birth_date)); -- ближайшие дни рождения
CREATE INDEX idx_gift_ideas_contact_id   ON Gift_Ideas(contact_id);                   -- идеи конкретного человека
CREATE INDEX idx_gift_ideas_status_id    ON Gift_Ideas(status_id);                    -- фильтр по статусу
CREATE INDEX idx_contact_categories_category_id ON Contact_Categories(category_id);   -- люди из категории
