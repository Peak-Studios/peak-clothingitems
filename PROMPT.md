# Peak Clothing Items — AI Setup Prompt

You are a senior FiveM systems engineer. Your task is to integrate the `peak-clothingitems` resource into the target server.

## 1. Discovery

Identify the server's stack by checking which resources are running:

**Framework** (one of):
- `qb-core` → QBCore
- `qbx_core` → QBox
- `es_extended` → ESX

**Inventory** (one of):
- `ox_inventory` → Overextended Inventory
- `qb-inventory` → QBCore Inventory
- `qs-inventory` → Quasar Inventory
- `codem-inventory` → Codem Inventory
- `ps-inventory` → Project Sloth Inventory

**Appearance** (one of):
- `illenium-appearance` → Illenium Appearance
- `rcore_clothing` → RCore Clothing
- `fivem-appearance` → FiveM Appearance
- `skinchanger` → ESX Skinchanger

## 2. Configuration

Open `shared/config.lua`. All values default to `'auto'` which auto-detects systems. Override only if auto-detection fails:

```lua
Config.Framework = 'auto'
Config.Inventory = 'auto'
Config.Appearance = 'auto'
```

## 3. Item Registration

Based on the discovered inventory system, add the 15 clothing items:

- **ox_inventory**: Copy `install/ox_inventory_items.lua` contents into `ox_inventory/data/items.lua`
- **qb-inventory**: Copy `install/qb_shared_items.lua` contents into `qb-core/shared/items.lua`
- **ESX**: Run `install/esx_items.sql` against the database

## 4. Server Configuration

Add to `server.cfg`:
```
ensure peak-clothingitems
```

Ensure it starts AFTER the framework, inventory, and appearance resources.

## 5. Validation

1. Start the server and check console for:
   - `[peak-clothingitems] Server initialized. Framework: <name> | Inventory: <name>`
   - `[peak-clothingitems] Registered 15 usable clothing items`
2. In-game, use `/clothing list` to verify command registration
3. Wear a hat, then `/clothing remove hat` — verify item appears in inventory
4. Use the hat item from inventory — verify it goes back on

## 6. Optional: Radial Menu

If the server uses `ox_lib` or `qb-radialmenu`, the script auto-registers a "Clothing" entry. Set `Config.EnableRadialMenu = false` to disable.

## 7. Optional: Admin Command

Add ACE permission for admin command:
```
add_ace group.admin command.clothingadmin allow
```
