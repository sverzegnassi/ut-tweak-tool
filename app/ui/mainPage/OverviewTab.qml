/*
  This file is part of ut-tweak-tool
  Copyright (C) 2015 Mutse Young

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License 3 as published by
  the Free Software Foundation.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program. If not, see http://www.gnu.org/licenses/.
*/

import QtQuick 2.0
import TweakTool 1.0
import Ubuntu.Components.ListItems 1.0 as ListItems

import "../../components/ListItems" as ListItem

Column {
    anchors.fill: parent

     readonly property string catCmd: "cat /etc/machine-info"
     readonly property string kerCmd: "uname -pro"
     readonly property string osCmd: "cat /etc/os-release | grep \"VERSION=\""
     readonly property string platformCmd: "uname -p"
     readonly property string cpuCmd: "cat /proc/cpuinfo | grep Processor"
     readonly property string memCmd: "cat /proc/meminfo | grep MemTotal"

     function parse_lines(response, splitstr) {
         var line;
         var lines = response.split('\n');
         for(var i in lines) {
             line = lines[i];
             if (line.indexOf(splitstr ) != -1) {
                 if (splitstr.length != 0) {
                     line = line.replace(splitstr,  "");
                     line = line.replace(/"([^"]*)"/g, "$1");
                 }
                 return line;
             }
         }
     }

     function parse_cmd(cmd, s) {
         var s1  = Process.launch(cmd);
         return parse_lines(s1, s);
     }

     function str_trim(s)
     {
         return s.replace(/^\s+|\s+$/g,"");
     }

     function calc_meminfo(cmd)
     {
         var s = str_trim(parse_cmd(cmd, "MemTotal:").replace("kB", ""))
         var total = parseInt(s)/1024;
         return Math.floor(total.toString())
     }

    //Overview section
    ListItem.SectionDivider { text: i18n.tr("Ubuntu Touch Information") }

    ListItems.Standard {
        text: i18n.tr("Kernel: ") + parse_cmd(kerCmd, "")
    }

    ListItems.Standard {
        text: i18n.tr("System Platform: ") + parse_cmd(platformCmd, "")
    }

    ListItems.Standard {
        text: i18n.tr("Distro: ") + parse_cmd(osCmd, "PRETTY_NAME=")
    }
    ListItems.Standard {
        text: i18n.tr("Desktop: Unity 8")
    }

     ListItem.SectionDivider { text: i18n.tr("Hardware Information") }

     ListItems.Standard {
          text: i18n.tr("Device: ") + parse_cmd(catCmd, "PRETTY_HOSTNAME=").replace(/"([^"]*)"/g, "$1")
      }

     ListItems.Standard {
         text: i18n.tr("CPU: ") + str_trim(parse_cmd(cpuCmd, "Processor").replace(":", ""))
     }

     ListItems.Standard {
         text:i18n.tr("Memory: ") +calc_meminfo(memCmd) + (" MB")
     }
}
