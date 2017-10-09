#
# Wrapper around the Serveradmin set function
#
# Copyright (c) 2017, InnoGames GmbH
#
function ig::server::multiadd (
    String[1] $attribute_id,
    String[1] $value,
) >> Undef {
    if ! defined(Class['ig::server']) {
        fail('This function can only be used with ig::server.')
    }

    $old_values = getvar("ig::server::${attribute_id}")
    assert_type(Array, $old_values)

    if ! ($value in $old_values) {
        serveradmin_set($ig::server::hostname, $attribute_id, $value)
    }

    undef
}
