internal static partial class Program
{
    private static async Task<int> Main(string[] args)
    {
        Uri? uri = null;
        try
        {
            uri = ConstructUri(args);
            return await CreateHttpClient().GetAndValidate(uri);
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

    private static Uri ConstructUri(string[] args)
    {
        var pathUri = GetPathUri(args);

        if (pathUri.IsAbsoluteUri)
            return pathUri;

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

        return new Uri(baseUri, pathUri);
    }

    private static Uri GetPathUri(string[] args)
    {
        if (args.Length == 0 || string.IsNullOrWhiteSpace(args[0]))
            return DefaultPath;

        return new Uri(args[0], UriKind.RelativeOrAbsolute);
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

        Console.Error.WriteLine($"Failed GET {uri} : {(int)result.StatusCode} {result.ReasonPhrase}");
        return 1;
    }

}
