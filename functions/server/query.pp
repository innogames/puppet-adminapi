#
# Wrapper around the Serveradmin query function
#
# Copyright (c) 2017, InnoGames GmbH
#
function ig::server::query (
    Variant[String[1], Ig::Igserver_query] $query,
    Ig::Attribute_id                       $attribute_id = 'hostname',
) >> Array[String[1]] {
    igserver(ig::format::cli_arguments({
        'attr'  => $attribute_id,
        'order' => $attribute_id,
        undef   => $query ? {
            String  => $query,
            default => $query.map |$key, $value| {
                with(ig::format::igserver_query_filter($value)) |$value| {
                    "${key}=${value}"
                }
            },
        },
    }))
}
