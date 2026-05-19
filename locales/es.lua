if Config.Locale ~= 'es' then return end

Locales = {
    -- Retirar
    ['removed_clothing']     = 'Te has quitado tu %s',
    ['removed_all_clothing'] = 'Te has quitado toda la ropa',
    ['partial_remove']       = 'Se quitaron %d prenda(s). Tu inventario se llenó antes de quitar el resto',
    ['already_default']      = 'No llevas nada en esa ranura',
    ['nothing_to_remove']    = 'No tienes nada que quitar',

    -- Poner
    ['wearing_clothing']     = 'Te has puesto un/una %s',
    ['wrong_model']          = 'Esta prenda no es compatible con tu personaje',
    ['slot_occupied']        = 'Ya llevas algo en esa ranura. Quítatelo primero',

    -- Errores
    ['cooldown']             = 'Espera antes de realizar otra acción de ropa',
    ['no_item']              = 'No tienes este objeto',
    ['inventory_full']       = 'Tu inventario está lleno',
    ['invalid_metadata']     = 'Esta prenda está dañada y no se puede usar',
    ['invalid_slot']         = 'Ranura de ropa desconocida: %s',
    ['action_failed']        = 'Algo salió mal. Inténtalo de nuevo',

    -- Comandos
    ['cmd_help']             = 'Uso: /%s remove <ranura|all> — Ranuras: %s',
    ['cmd_list_header']      = 'Ropa actual:',
    ['cmd_list_empty']       = 'No llevas ninguna prenda que se pueda quitar',
    ['cmd_list_item']        = '  %s: Drawable %d, Textura %d',

    -- Menú Radial
    ['radial_clothing']      = 'Ropa',
    ['radial_remove']        = 'Quitar ropa',
    ['radial_remove_all']    = 'Quitar todo',

    -- Admin
    ['admin_give_usage']     = 'Uso: /%s give <id_jugador> <ranura> <drawable> <textura>',
    ['admin_give_success']   = '%s (drawable: %d, textura: %d) dado al jugador %d',
    ['admin_no_permission']  = 'No tienes permiso para usar este comando',
}
