<#
This file loads the strings documents from the respective language folders.
This allows localizing messages and errors.
Load psd1 language files for each language you wish to support.
Partial translations are acceptable - when missing a current language message,
it will fallback to English or another available language.
#>
Import-PSFLocalizedString -Path "$($script:ModuleRoot)\en-us\*.psd1" -Module 'NPSLogFile' -Language 'en-US'

Add-Type -TypeDefinition @"
namespace NPS {
    namespace LogFile {
        public static class Cache {
            public static System.Collections.Hashtable Data = new System.Collections.Hashtable();
        }

        public static class Lookup {
            public static System.Collections.Hashtable AuthenticationSource = new System.Collections.Hashtable();
            public static System.Collections.Hashtable AuthenticationTypes = new System.Collections.Hashtable();
            public static System.Collections.Hashtable FilterPacketTypes = new System.Collections.Hashtable();
            public static System.Collections.Hashtable NasPortTypes = new System.Collections.Hashtable();
            public static System.Collections.Hashtable PacketTypes = new System.Collections.Hashtable();
            public static System.Collections.Hashtable ReasonCodes = new System.Collections.Hashtable();
            public static System.Collections.Hashtable IasAttributeTypes = new System.Collections.Hashtable();
        }
    }
}
"@
