#
# Hostname datatype
#
# Copyright (c) 2018, InnoGames GmbH
#
type Ig::Server::Hostname = Pattern[/\A[a-z][a-z0-9_\-\.]+\Z/]
