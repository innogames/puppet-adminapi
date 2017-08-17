#
# Wrapper around the Serveradmin query function to get a single server
#
# Copyright (c) 2017, InnoGames GmbH
#
function ig::server::query_one (
    String[1] $query,
    String[1] $attribute_id = 'fqdn',
) >> String[1] {
    $result = ig::server::query($query, $attribute_id)
    $length = length($result)

    if $length != 1 {
        fail("Query \"${query}\" returned ${length} servers.")
    }

    $result[0]
}
