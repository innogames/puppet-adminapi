#
# Format igserver query filter
#
# Copyright (c) 2017, InnoGames GmbH
#
function ig::format::igserver_query_filter (
    Variant[Boolean, Numeric, String[1], Ig::Igserver_query_filter] $input,
) >> String[1] {
    $input ? {
        Ig::Igserver_query_filter => join($input.map |$key, $value| { # lint:ignore:unquoted_string_in_selector
            with($value ? {
                undef   => '',
                Array   => join($value.map |$value| {
                    ig::format::igserver_query_filter($value)
                }, ' '),
                default => ig::format::igserver_query_filter($value),
            }) |$value| {
                "${key}(${value})"
            }
        }),
        default                   => String($input),
    }
}
