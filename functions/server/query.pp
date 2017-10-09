#
# Wrapper around the Serveradmin query function
#
# Copyright (c) 2017, InnoGames GmbH
#
function ig::server::query (
    String[1] $query,
    String[1] $attribute_id = 'fqdn',
) >> Array[String[1]] {
    $attribute_id ? {
        'fqdn'  => query($query, 'hostname').map |$hostname| {
            $hostname ? {
                /\.(ig\.local|innogames\.net)\Z/ => $hostname,
                default                          => "${hostname}.ig.local",
            }
        },
        default => query($query, $attribute_id),
    }
}
