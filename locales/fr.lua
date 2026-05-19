if Config.Locale ~= 'fr' then return end

Locales = {
    -- Retrait
    ['removed_clothing']     = 'Vous avez retiré votre %s',
    ['removed_all_clothing'] = 'Vous avez retiré tous vos vêtements',
    ['partial_remove']       = '%d vêtement(s) retiré(s). Votre inventaire était plein avant de retirer le reste',
    ['already_default']      = 'Vous ne portez rien dans cet emplacement',
    ['nothing_to_remove']    = 'Vous n\'avez rien à retirer',

    -- Port
    ['wearing_clothing']     = 'Vous avez mis un(e) %s',
    ['wrong_model']          = 'Ce vêtement n\'est pas compatible avec votre personnage',
    ['slot_occupied']        = 'Vous portez déjà quelque chose dans cet emplacement. Retirez-le d\'abord',

    -- Erreurs
    ['cooldown']             = 'Veuillez patienter avant d\'effectuer une autre action vestimentaire',
    ['no_item']              = 'Vous n\'avez pas cet objet',
    ['inventory_full']       = 'Votre inventaire est plein',
    ['invalid_metadata']     = 'Ce vêtement est endommagé et ne peut pas être porté',
    ['invalid_slot']         = 'Emplacement de vêtement inconnu: %s',
    ['action_failed']        = 'Quelque chose s\'est mal passé. Veuillez réessayer',

    -- Commandes
    ['cmd_help']             = 'Utilisation: /%s remove <emplacement|all> — Emplacements: %s',
    ['cmd_list_header']      = 'Vêtements actuels:',
    ['cmd_list_empty']       = 'Vous ne portez aucun vêtement amovible',
    ['cmd_list_item']        = '  %s: Drawable %d, Texture %d',

    -- Menu Radial
    ['radial_clothing']      = 'Vêtements',
    ['radial_remove']        = 'Retirer un vêtement',
    ['radial_remove_all']    = 'Tout retirer',

    -- Admin
    ['admin_give_usage']     = 'Utilisation: /%s give <id_joueur> <emplacement> <drawable> <texture>',
    ['admin_give_success']   = '%s (drawable: %d, texture: %d) donné au joueur %d',
    ['admin_no_permission']  = 'Vous n\'avez pas la permission d\'utiliser cette commande',
}
