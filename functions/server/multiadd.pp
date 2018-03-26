#
# Wrapper around the Serveradmin set function
#
# Copyright (c) 2017, InnoGames GmbH
#
function ig::server::multiadd (
    Ig::Server::Attribute_id                     $attribute_id,
    Variant[Numeric, Pattern[/\A[^\(\)\'"]+\Z/]] $value,
    Boolean                                      $monitoring_check_call = false,
) >> Undef {
    if ! defined(Class['ig::server']) {
        fail('This function can only be used with ig::server.')
    }

    if $attribute_id == 'monitoring_checks' and ! $monitoring_check_call {
        notify { "multiadd_${attribute_id}_${value}_command":
            message  => '"multiadd" is deprecated for attribute monitoring_checks. Use "ig::helper::monitoring_check" instead.',
            loglevel => 'warning',
        }
    }

    $old_values = getvar("ig::server::${attribute_id}")
    assert_type(Array, $old_values)

    if ! ($value in $old_values) {
        adminapi(ig::format::cli_arguments({
            'update' => "${attribute_id}=\"${value}\"",
            undef    => $ig::server::hostname,
        }))
    }

    undef
}
