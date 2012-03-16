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

define postgres::database($ensure, $owner = false, $template=false) {
    $ownerstring = $owner ? {
        false => "",
        default => "-O '$owner'"
    }
	
    $templatestring = $template ? {
        false => "",
        default => "-T '$template'"
    }
	

    case $ensure {
        present: {
            exec { "Create $name postgres db":
                command => "/usr/bin/createdb $ownerstring $templatestring '$name'",
                user => "postgres",
                unless => "/usr/bin/psql -l | grep '$name  *|'",
				require => [Package["postgresql"], Service['postgresql']],
            }
        }
        absent:  {
            exec { "Remove $name postgres db":
                command => "/usr/bin/dropdb '$name'",
                onlyif => "/usr/bin/psql -l | grep '$name  *|'",
                user => "postgres",
				require => [Package["postgresql"], Service['postgresql']],
            }
        }
        default: {
            fail "Invalid 'ensure' value '$ensure' for postgres::database"
        }
    }
}
