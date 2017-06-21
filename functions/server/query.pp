#
# Wrapper around the Serveradmin query function
#
# Copyright (c) 2017, InnoGames GmbH
#
function ig::server::query (
    String[1] $query,
    String[1] $attribute_id,
) >> Array[String[1]] {
    query($query, $attribute_id)
}
