# Installation

## 1. Install The Resource

Place the folder in your FiveM server resources directory:

```text
resources/[peak]/peak-clothingitems
```

Start it after your framework, inventory, and appearance resources:

```cfg
ensure ox_lib
ensure qb-core
ensure ox_inventory
ensure illenium-appearance
ensure peak-clothingitems
```

Adjust the example for your actual stack.

## 2. Register Inventory Items

Every clothing item must be unique or non-stacking because metadata stores the exact drawable, texture, model, and sex.

### ox_inventory

Copy the entries from `install/ox_inventory_items.lua` into:

```text
ox_inventory/data/items.lua
```

### QBCore / qb-inventory / ps-inventory

Copy the entries from `install/qb_shared_items.lua` into:

```text
qb-core/shared/items.lua
```

### ESX

Run the SQL from `install/esx_items.sql` against your database.

## 3. Configure The Resource

Open `shared/config.lua`. The defaults use `auto` detection:

```lua
Config.Framework = 'auto'
Config.Inventory = 'auto'
Config.Appearance = 'auto'
Config.Notify = 'auto'
Config.RadialMenu = 'auto'
```

If auto-detection chooses the wrong resource, set the exact value documented in [CONFIGURATION.md](CONFIGURATION.md).

## 4. Permissions

The admin command is ACE-restricted and also checks framework admin groups:

```cfg
add_ace group.admin command.clothingadmin allow
```

## 5. Validation Checklist

After restart, confirm the server logs show:

```text
[peak-clothingitems] Server initialized. Framework: <name> | Inventory: <name>
[peak-clothingitems] Registered 15 usable clothing items
```

Then test in game:

1. Wear a supported item, such as a hat.
2. Run `/clothing list`.
3. Run `/clothing remove hat`.
4. Confirm the item appears in inventory with metadata.
5. Use the item.
6. Confirm it returns to the same clothing slot.
