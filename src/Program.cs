internal static partial class Program
{
    private static async Task<int> Main(string[] args)
    {
        Uri? uri = null;
        try
        {
            if (TryConstructUri(args, out uri))
                return await CreateHttpClient().GetAndValidate(uri);
            else
                Console.Error.WriteLine("A valid URI could not be constructed");
        }
        catch (Exception ex)
        {
            var message = ex.InnerException?.Message ?? ex.Message;
            Console.Error.WriteLine($"Failed unexpectedly: {message}");
        }

        if (uri is not null)
            Console.Error.WriteLine($"URI: {uri}");

        return 1;
    }

    private static bool TryConstructUri(string[] args, out Uri uri)
    {
        if (TryGetUri(args, out Uri pathUri) && pathUri.IsAbsoluteUri)
            uri = pathUri;
        else
        {
            var baseUri = Environment.GetEnvironmentVariable("ASPNETCORE_URLS")?
                .Split(';', StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries)
                .Select(u => Uri.TryCreate(System.Text.RegularExpressions.Regex.Replace(u, @"[+%]+", "localhost"), UriKind.Absolute, out var uri) ? uri : null)
                .FirstOrDefault(u => u is not null && u.Scheme == "http");

            if (baseUri is null)
            {
                var port = Environment.GetEnvironmentVariable("ASPNETCORE_HTTP_PORTS")?
                  .Split(';', StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries)
                  .FirstOrDefault();
                baseUri = DefaultBaseUri(port ?? DefaultPort);
            }

            return Uri.TryCreate(baseUri, pathUri, out uri!);
        }

        return true;
    }

    private static bool TryGetUri(string[] args, out Uri uri)
    {
        if (args.Length > 0 && !string.IsNullOrWhiteSpace(args[0]) && !Uri.TryCreate(args[0], UriKind.RelativeOrAbsolute, out uri!))
            return false;
        else
            uri = DefaultPath;

        return true;
    }

    private static string DefaultPort
        => Environment.Version.Major >= 8 ? "8080" : "5000";

    private static Uri DefaultBaseUri(string port)
        => new Uri($"http://localhost:{port}", UriKind.Absolute);

    private static Uri DefaultPath
        => new Uri("/healthz", UriKind.Relative);

    private static HttpClient CreateHttpClient()
    {
        var httpClient = new HttpClient();
        httpClient.DefaultRequestHeaders.ConnectionClose = true;
        return httpClient;
    }

    static async Task<int> GetAndValidate(this HttpClient client, Uri uri)
    {
        var result = await client.GetAsync(uri).ContinueWith(r => r.Result);
        if (result.IsSuccessStatusCode)
            return 0;

        Console.Error.WriteLine($"Failed GET {uri} : {result.StatusCode} {result.ReasonPhrase}");
        return 1;
    }

}
