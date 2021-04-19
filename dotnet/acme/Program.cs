using System;
using System.Data.SqlClient;
using System.Linq;
using System.Text;

namespace acme
{
    class Program
    {

        // static void Main(string[] args)
        // {
        //     Console.WriteLine("Hello World!");
        // }

        private static Random random = new Random();
        public static string RandomString(int length)
        {
            const string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
            return new string(Enumerable.Repeat(chars, length)
            .Select(s => s[random.Next(s.Length)]).ToArray());
        }

        // https://docs.microsoft.com/en-us/azure/azure-sql/database/connect-query-dotnet-core
        static void Main(string[] args)
        {
            try {
                SqlConnectionStringBuilder builder = new SqlConnectionStringBuilder();

                builder.DataSource = Environment.GetEnvironmentVariable("SQL_SERVER_NAME");
                builder.UserID = Environment.GetEnvironmentVariable("SQL_SERVER_USER_NAME");
                builder.Password = Environment.GetEnvironmentVariable("SQL_SERVER_USER_PASSWORD");
                builder.InitialCatalog = Environment.GetEnvironmentVariable("SQL_DATABASE_NAME");

                using (SqlConnection connection = new SqlConnection(builder.ConnectionString))
                {
                    string randomString = RandomString(8);
                    string currentDateTime = DateTime.UtcNow.ToString("yyyy-MM-ddTHH:mm:ss.ffZ");
                    string query = "INSERT INTO [AcmeSchema].[AcmeTable] (RandomString,RandomDateTime) VALUES (@randomString, @randomDateTime)";

                    using(SqlCommand command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@randomString", randomString);
                        command.Parameters.AddWithValue("@randomDateTime", currentDateTime);

                        connection.Open();
                        int result = command.ExecuteNonQuery();

                        // Check Error
                        if(result < 0)
                            Console.WriteLine("Error inserting data into database.");
                    }
                }
            }
            catch (SqlException e)
            {
                Console.WriteLine(e.ToString());
            }

            try
            {
                SqlConnectionStringBuilder builder = new SqlConnectionStringBuilder();

                builder.DataSource = Environment.GetEnvironmentVariable("SQL_SERVER_NAME");
                builder.UserID = Environment.GetEnvironmentVariable("SQL_SERVER_USER_NAME");
                builder.Password = Environment.GetEnvironmentVariable("SQL_SERVER_USER_PASSWORD");
                builder.InitialCatalog = Environment.GetEnvironmentVariable("SQL_DATABASE_NAME");

                using (SqlConnection connection = new SqlConnection(builder.ConnectionString))
                {
                    Console.WriteLine("\nQuery data example:");
                    Console.WriteLine("=========================================\n");

                    connection.Open();

                    // String sql = "SELECT name, collation_name FROM sys.databases";
                    String sql = "SELECT TOP (50) * FROM [AcmeSchema].[AcmeTable]";

                    using (SqlCommand command = new SqlCommand(sql, connection))
                    {
                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                Console.WriteLine("{0}, {1}, {2}", reader.GetInt32(0), reader.GetString(1), reader.GetString(2));
                            }
                        }
                    }
                }
            }
            catch (SqlException e)
            {
                Console.WriteLine(e.ToString());
            }

            // Console.WriteLine("\nDone. Press Enter.");
            // Console.ReadLine();
        }
    }
}
