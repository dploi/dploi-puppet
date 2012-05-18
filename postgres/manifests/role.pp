# Copyright (c) 2008, Luke Kanies, luke@madstop.com
# 
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
# 
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

define postgres::role($ensure, $password = false, $superuser = false) {
    $passtext = $password ? {
        false => "",
        default => "PASSWORD '$password'"
    }
    case $ensure {
        present: {
            # The createuser command always prompts for the password.
            exec { "Create $name postgres role":
                command => "/usr/bin/psql -c \"CREATE USER \\\"$name\\\" $passtext \" ",
                user => "postgres",
                unless => "/usr/bin/psql -c '\\du' | grep '^  *$name  *|'",
                require => Package["postgresql"],
            }
            if $superuser {
                exec { "Upgrade $name postgres role to superuser":
                    command => "/usr/bin/psql -c \"ALTER USER \"$name\" SUPERUSER;\" ",
                    user => "postgres",
                    unless => "/usr/bin/psql -c \"SELECT rolname FROM pg_catalog.pg_roles WHERE rolsuper;\" | grep \"^ $name\$\" ",
                    require => Exec["Create $name postgres role"],
                }
            } else {
                exec { "Downgrade $name postgres role to normal user":
                    command => "/usr/bin/psql -c \"ALTER USER \"$name\" NOSUPERUSER;\" ",
                    user => "postgres",
                    unless => "/usr/bin/psql -c 'SELECT rolname FROM pg_catalog.pg_roles WHERE NOT rolsuper;' | grep \"^ $name\$\" ",
                    require => Exec["Create $name postgres role"],
                }
            }
        }
        absent:  {
            exec { "Remove $name postgres role":
                command => "/usr/bin/dropuser \"$name\"",
                user => "postgres",
                onlyif => "/usr/bin/psql -c '\\du' | grep '$name  *|'",
                require => Package["postgresql"],
            }
        }
        default: {
            fail "Invalid 'ensure' value '$ensure' for postgres::role"
        }
    }
}
