internal static partial class Program
{
    private static async Task<int> Main(string[] args)
    {
        try
        {
            if (TryGetAbsoluteUri(args, out Uri? uri) || TryMergeUris(uri, out uri))
                return await CreateHttpClient().GetAndValidate(uri!);

            Console.Error.WriteLine("A valid URI must be provided");
        }
        catch (Exception ex)
        {
            var message = ex.InnerException?.Message ?? ex.Message;
            Console.Error.WriteLine(message);
        }

        return 1;
    }

    private static bool TryGetAbsoluteUri(string[] args, out Uri? uri)
    {
        if (args.Length > 1)
            return Uri.TryCreate(args[1], UriKind.RelativeOrAbsolute, out uri) && uri.IsAbsoluteUri;

        uri = null;
        return false;
    }

    private static bool TryMergeUris(Uri? relativeUri, out Uri? uri)
    {
        var baseUri = Environment.GetEnvironmentVariable("ASPNETCORE_URLS")?
            .Split(';', StringSplitOptions.RemoveEmptyEntries)
            .Select(u => Uri.TryCreate(System.Text.RegularExpressions.Regex.Replace(u, @"[+%]+", "localhost"), UriKind.Absolute, out var uri) ? uri : null)
            .FirstOrDefault(u => u is not null && u.Scheme == "http");

        if (baseUri is null)
            uri = relativeUri;
        else
            return Uri.TryCreate(baseUri, relativeUri, out uri);

        return uri is not null;
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
