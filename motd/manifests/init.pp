# class to setup basic motd, include on all nodes
class motd {
   include concat::setup
   $motd = "/etc/motd"

   concat{$motd:
      owner => root,
      group => root,
      mode  => 644
   }

   concat::fragment{"motd_header":
      target => $motd,
      content => "\nPuppet modules on this server:\n\n",
      order   => 01,
   }
   
   concat::fragment{"motd_cust_header":
     target => $motd,
     content => "\nCustomers on this server:\n\n",
     order   => 15,
   }

   # local users on the machine can append to motd by just creating
   # /etc/motd.local
   concat::fragment{"motd_local":
      target => $motd,
      ensure  => "/etc/motd.local",
      order   => 30
   }
   

}

# used by other modules to register themselves in the motd
define motd::register($content="", $order=10) {
   if $content == "" {
      $body = $name
   } else {
      $body = $content
   }

   concat::fragment{"motd_fragment_$name":
      target  => "/etc/motd",
      content => "    -- $body\n"
   }
}

define motd::customer_register($content="", $order=20) {
   if $content == "" {
      $body = $name
   } else {
      $body = $content
   }

   concat::fragment{"motd_fragment_$name":
      target  => "/etc/motd",
      content => "    -- $body\n",
      order => $order,
   }
}