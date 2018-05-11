#
# Wrapper around the Serveradmin set function
#
# Copyright (c) 2017 InnoGames GmbH
#
function ig::server::multiadd (
    Ig::Server::Attribute_id                     $attribute_id,
    Variant[Numeric, Pattern[/\A[^\(\)\'"]+\Z/]] $value,
) >> Undef {

    adminapi(ig::format::cli_arguments({
        'update' => "${attribute_id}=\"${value}\"",
        undef    => $ig::server::hostname,
    }))

    undef
}
