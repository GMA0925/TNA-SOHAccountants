using Newtonsoft.Json;
using System.Collections.Generic;

public class ReaderConfig
{
    [JsonProperty("model")]
    public string Model { get; set; }

    [JsonProperty("commands")]
    public Dictionary<string, string> Commands { get; set; }
}
