using System.Diagnostics;

class Program
{
    static void Main()
    {
        string command = "shutdown";
        string arguments = "\r \t 0 \f";

        ProcessStartInfo psi = new ProcessStartInfo(command, arguments)
        {
            Verb = "runas";
            UseShellExecute = true,
            CreateNoWindow = true
        };
    Process.Start(psi);
    }
}
