internal static partial class Program
{
    private static Uri DefaultBaseUri = new Uri("http://localhost:8080", UriKind.Absolute);
    private static Uri DefaultPath = new Uri("/healthz", UriKind.Relative);

    private static async Task<int> Main(string[] args)
    {
        try
        {
            if (TryGetUri(args, out Uri uri) && TryConstructUri(uri, out uri))
                return await CreateHttpClient().GetAndValidate(uri);
            else
                Console.Error.WriteLine("A valid URI could not be constructed");
        }
        catch (Exception ex)
        {
            var message = ex.InnerException?.Message ?? ex.Message;
            Console.Error.WriteLine(message);
        }

        return 1;
    }

    private static bool TryGetUri(string[] args, out Uri uri)
    {
        uri = DefaultPath;
        if (args.Length == 0 || string.IsNullOrWhiteSpace(args[0]) || Uri.TryCreate(args[0], UriKind.RelativeOrAbsolute, out uri!))
            return true;

        return false;
    }

    private static bool TryConstructUri(Uri pathUri, out Uri uri)
    {
        if (pathUri.IsAbsoluteUri)
            uri = pathUri;
        else
        {
            var baseUri = Environment.GetEnvironmentVariable("ASPNETCORE_URLS")?
                .Split(';', StringSplitOptions.RemoveEmptyEntries)
                .Select(u => Uri.TryCreate(System.Text.RegularExpressions.Regex.Replace(u, @"[+%]+", "localhost"), UriKind.Absolute, out var uri) ? uri : null)
                .FirstOrDefault(u => u is not null && u.Scheme == "http");

            return Uri.TryCreate(baseUri ?? DefaultBaseUri, pathUri, out uri!);
        }

        return true;
    }

    private static HttpClient CreateHttpClient()
    {
        var httpClient = new HttpClient();
        httpClient.DefaultRequestHeaders.ConnectionClose = true;
        return httpClient;
    }

    static async Task<int> GetAndValidate(this HttpClient client, Uri uri)
        => await client.GetAsync(uri).ContinueWith(r => r.Result.IsSuccessStatusCode) ? 0 : 1;
}
