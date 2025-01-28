DROP TABLE IF EXISTS items;
DROP TABLE IF EXISTS categories;

CREATE TABLE categories (
    category_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(50) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE items (
    item_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(100) NOT NULL,
    category_id INTEGER,
    expiry_day INTEGER NOT NULL,
    expiry_month INTEGER NOT NULL,
    expiry_year INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    notes TEXT,
    is_active BOOLEAN DEFAULT 1,
    FOREIGN KEY (category_id) REFERENCES categories(category_id),
    CHECK (expiry_day BETWEEN 1 AND 31),
    CHECK (expiry_month BETWEEN 1 AND 12),
    CHECK (expiry_year >= 2024)
);

CREATE INDEX idx_items_expiry 
ON items(expiry_year, expiry_month, expiry_day);

CREATE INDEX idx_items_name 
ON items(name);

INSERT INTO categories (name, description)
VALUES 
    ('Zuivel', 'Melk, yoghurt, kaas etc.'),
    ('Groenten', 'Verse groenten'),
    ('Fruit', 'Vers fruit'),
    ('Vlees', 'Vlees en gevogelte'),
    ('Overig', 'Overige producten');

INSERT INTO items (name, category_id, expiry_day, expiry_month, expiry_year, notes)
VALUES 
    ('Halfvolle melk', 1, 15, 2, 2024, 'Geopend op 08-02'),
    ('Spinazie', 2, 10, 2, 2024, NULL),
    ('Kipfilet', 4, 12, 2, 2024, 'In vriezer');

CREATE VIEW near_expiry_items AS
SELECT 
    i.item_id,
    i.name,
    c.name as category,
    i.expiry_day,
    i.expiry_month,
    i.expiry_year
FROM items i
LEFT JOIN categories c ON i.category_id = c.category_id
WHERE date(i.expiry_year || '-' || 
           PRINTF('%02d', i.expiry_month) || '-' || 
           PRINTF('%02d', i.expiry_day)) <= date('now', '+7 days')
AND i.is_active = 1;

CREATE TRIGGER update_items_timestamp 
AFTER UPDATE ON items
BEGIN
    UPDATE items 
    SET updated_at = CURRENT_TIMESTAMP 
    WHERE item_id = NEW.item_id;
END;