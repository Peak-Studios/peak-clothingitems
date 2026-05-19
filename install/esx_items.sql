-- ============================================================
-- ESX ITEMS TABLE SQL
-- ============================================================
-- Run this SQL in your database to add Peak Clothing Items
-- to the ESX `items` table.
-- ============================================================

--[[

INSERT INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES
    ('clothing_mask',       'Mask',        100, 0, 1),
    ('clothing_torso',      'Torso',       150, 0, 1),
    ('clothing_pants',      'Pants',       150, 0, 1),
    ('clothing_bag',        'Bag',         200, 0, 1),
    ('clothing_shoes',      'Shoes',       150, 0, 1),
    ('clothing_accessory',  'Accessory',    50, 0, 1),
    ('clothing_undershirt', 'Undershirt',  100, 0, 1),
    ('clothing_vest',       'Vest',        200, 0, 1),
    ('clothing_decal',      'Decal',        25, 0, 1),
    ('clothing_top',        'Top',         150, 0, 1),
    ('clothing_hat',        'Hat',          75, 0, 1),
    ('clothing_glasses',    'Glasses',      25, 0, 1),
    ('clothing_earring',    'Earring',      15, 0, 1),
    ('clothing_watch',      'Watch',        50, 0, 1),
    ('clothing_bracelet',   'Bracelet',     25, 0, 1)
ON DUPLICATE KEY UPDATE `label` = VALUES(`label`);

]]
