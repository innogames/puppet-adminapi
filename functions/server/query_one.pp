#
# Wrapper around the Serveradmin query function to get a single server
#
# Copyright (c) 2017, InnoGames GmbH
#
function ig::server::query_one (
    String[1] $query,
    String[1] $attribute_id = 'fqdn',
) >> String[1] {
    igserver(ig::format::cli_arguments({
        'one'   => undef,
        'attr'  => $attribute_id,
        'order' => $attribute_id,
        undef   => $query,
    }))[0]
}
