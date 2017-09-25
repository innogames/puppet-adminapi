#
# Wrapper around the Serveradmin query function
#
# Copyright (c) 2017, InnoGames GmbH
#
function ig::server::query (
    String[1] $query,
    String[1] $attribute_id = 'hostname',
) >> Array[String[1]] {
    igserver(ig::format::cli_arguments({
        'attr'  => $attribute_id,
        'order' => $attribute_id,
        undef   => $query,
    }))
}
