-- Create member_settings table
CREATE TABLE IF NOT EXISTS member_settings (
    member_id INT PRIMARY KEY,
    allow_shared_view BOOLEAN DEFAULT TRUE,
    show_allergy_warning BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (member_id) REFERENCES members(id) ON DELETE CASCADE
);
