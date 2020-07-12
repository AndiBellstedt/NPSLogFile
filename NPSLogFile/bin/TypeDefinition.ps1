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
