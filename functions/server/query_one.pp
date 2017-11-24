#
# Wrapper around the Serveradmin query function to get a single server
#
# Copyright (c) 2017, InnoGames GmbH
#
function ig::server::query_one (
    Ig::Igserver_query $query,
    Ig::Attribute_id   $attribute_id = 'hostname',
) >> String[1] {
    igserver(ig::format::cli_arguments({
        'one'   => undef,
        'attr'  => $attribute_id,
        'order' => $attribute_id,
        undef   => $query.map |$key, $value| {
            with(ig::format::igserver_query_filter($value)) |$value| {
                "${key}=${value}"
            }
        },
    }))[0]
}
