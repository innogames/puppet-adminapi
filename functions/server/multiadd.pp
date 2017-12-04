#
# Wrapper around the Serveradmin set function
#
# Copyright (c) 2017, InnoGames GmbH
#
function ig::server::multiadd (
    Ig::Server::Attribute_id                     $attribute_id,
    Variant[Numeric, Pattern[/\A[^\(\)\'"]+\Z/]] $value,
) >> Undef {
    if ! defined(Class['ig::server']) {
        fail('This function can only be used with ig::server.')
    }

    $old_values = getvar("ig::server::${attribute_id}")
    assert_type(Array, $old_values)

    if ! ($value in $old_values) {
        igserver(ig::format::cli_arguments({
            'update' => "${attribute_id}=\"${value}\"",
            undef    => $ig::server::hostname,
        }))
    }

    undef
}
