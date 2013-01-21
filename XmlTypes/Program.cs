using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SqlClient;
using System.Data;
using System.Xml.Serialization;
using System.IO;

namespace XmlTypes
{
    class Program
    {
        static void Main(string[] args)
        {
            using (SqlConnection connection = new SqlConnection(@"Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=friends;Data Source=.\sqlexpress2005"))
            {
                using (SqlCommand command = new SqlCommand("addFriends", connection) { CommandType = CommandType.StoredProcedure })
                {
                    friends f = new friends();
                    f.Items = new friendsFriend[] 
                    { 
                        new friendsFriend 
                        { 
                            firstname = "Julie", 
                            lastname = "Truter" 
                        },
                        new friendsFriend 
                        { 
                            firstname = "Roland", 
                            lastname = "Cooper" 
                        } 
                    };

                    StringWriter sw = new StringWriter();
                    XmlSerializer xml = new XmlSerializer(typeof(friends));
                    xml.Serialize(sw, f);

                    connection.Open();
                    command.Parameters.Add("@friends", SqlDbType.Xml).Value = sw.ToString();
                    command.ExecuteNonQuery();
                }
            }
        }
    }
}
