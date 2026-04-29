# .NET 8.0 Upgrade Plan

## Execution Steps

Execute steps below sequentially one by one in the order they are listed.

1. Validate that a .NET 8.0 SDK required for this upgrade is installed on the machine and if not, help to get it installed.
2. Ensure that the SDK version specified in global.json files is compatible with the .NET 8.0 upgrade.
3. Upgrade TimeAttendance.WebForms.csproj

## Settings

This section contains settings and data used by execution steps.

### Excluded projects

| Project name                                   | Description                 |
|:-----------------------------------------------|:---------------------------:|
| (none)                                         |                             |

### Aggregate NuGet packages modifications across all projects

NuGet packages used across all selected projects or their dependencies that need version update in projects that reference them.

| Package Name                                          | Current Version | New Version | Description                                                          |
|:------------------------------------------------------|:---------------:|:-----------:|:---------------------------------------------------------------------|
| Antlr                                                 | 3.5.0.2         |             | Replace with Antlr4 4.6.6                                           |
| Antlr4                                                |                 | 4.6.6       | Replacement for Antlr                                                |
| AspNet.ScriptManager.bootstrap                        | 3.4.1           |             | Incompatible, no supported version found. Remove.                    |
| AspNet.ScriptManager.jQuery                           | 3.4.1           |             | Incompatible, no supported version found. Remove.                    |
| iTextSharp                                            | 5.5.13.5        | 5.5.13.3    | Recommended compatible version for .NET 8.0                          |
| itextsharp.xmlworker                                  | 5.5.13.4        | 5.5.13.3    | Recommended compatible version for .NET 8.0                          |
| jQuery                                                | 3.4.1           | 3.7.1       | Security vulnerability                                               |
| Microsoft.AspNet.FriendlyUrls                         | 1.0.2           |             | Incompatible, no supported version found. Remove.                    |
| Microsoft.AspNet.FriendlyUrls.Core                    | 1.0.2           |             | Incompatible, no supported version found. Remove.                    |
| Microsoft.AspNet.ScriptManager.MSAjax                 | 5.0.0           |             | Incompatible, no supported version found. Remove.                    |
| Microsoft.AspNet.ScriptManager.WebForms               | 5.0.0           |             | Incompatible, no supported version found. Remove.                    |
| Microsoft.AspNet.Web.Optimization                     | 1.1.3           |             | Deprecated. Replace with LigerShark.WebOptimizer.Core 3.0.477       |
| Microsoft.AspNet.Web.Optimization.WebForms            | 1.1.3           |             | Incompatible, no supported version found. Remove.                    |
| Microsoft.Bcl.HashCode                                | 1.1.1           | 6.0.0       | Recommended for .NET 8.0                                             |
| Microsoft.CodeDom.Providers.DotNetCompilerPlatform    | 2.0.1           |             | Functionality included with new framework reference. Remove.         |
| Microsoft.Web.Infrastructure                          | 1.0.0.0         |             | Functionality included with new framework reference. Remove.         |
| Newtonsoft.Json                                       | 12.0.2          | 13.0.4      | Security vulnerability and recommended for .NET 8.0                  |
| LigerShark.WebOptimizer.Core                          |                 | 3.0.477     | Replacement for Microsoft.AspNet.Web.Optimization                    |
| System.Buffers                                        | 4.5.1           |             | Functionality included with new framework reference. Remove.         |
| System.IO                                             | 4.3.0           |             | Functionality included with new framework reference. Remove.         |
| System.Memory                                         | 4.5.5           |             | Functionality included with new framework reference. Remove.         |
| System.Net.Http                                       | 4.3.4           |             | Functionality included with new framework reference. Remove.         |
| System.Numerics.Vectors                               | 4.5.0           |             | Functionality included with new framework reference. Remove.         |
| System.Runtime                                        | 4.3.0           |             | Functionality included with new framework reference. Remove.         |
| System.Runtime.CompilerServices.Unsafe                | 4.7.0           | 6.1.2       | Recommended for .NET 8.0                                             |
| System.Security.Cryptography.Algorithms               | 4.3.0           |             | Functionality included with new framework reference. Remove.         |
| System.Security.Cryptography.Encoding                 | 4.3.0           |             | Functionality included with new framework reference. Remove.         |
| System.Security.Cryptography.Primitives               | 4.3.0           |             | Functionality included with new framework reference. Remove.         |
| System.Security.Cryptography.X509Certificates         | 4.3.0           |             | Functionality included with new framework reference. Remove.         |

### Project upgrade details

This section contains details about each project upgrade and modifications that need to be done in the project.

#### TimeAttendance.WebForms.csproj modifications

Project properties changes:
  - Project file needs to be converted to SDK-style
  - Target framework should be changed from `net48` to `net8.0`

Feature upgrades:
  - Convert application initialization code from Global.asax.cs to .NET Core and clean up Global.asax.cs

NuGet packages changes:
  - `Antlr` should be removed and replaced with `Antlr4` version `4.6.6`
  - `AspNet.ScriptManager.bootstrap` should be removed (*incompatible, no supported version*)
  - `AspNet.ScriptManager.jQuery` should be removed (*incompatible, no supported version*)
  - `iTextSharp` should be updated from `5.5.13.5` to `5.5.13.3` (*compatible version for .NET 8.0*)
  - `itextsharp.xmlworker` should be updated from `5.5.13.4` to `5.5.13.3` (*compatible version for .NET 8.0*)
  - `jQuery` should be updated from `3.4.1` to `3.7.1` (*security vulnerability*)
  - `Microsoft.AspNet.FriendlyUrls` should be removed (*incompatible, no supported version*)
  - `Microsoft.AspNet.FriendlyUrls.Core` should be removed (*incompatible, no supported version*)
  - `Microsoft.AspNet.ScriptManager.MSAjax` should be removed (*incompatible, no supported version*)
  - `Microsoft.AspNet.ScriptManager.WebForms` should be removed (*incompatible, no supported version*)
  - `Microsoft.AspNet.Web.Optimization` should be removed and replaced with `LigerShark.WebOptimizer.Core` version `3.0.477` (*deprecated*)
  - `Microsoft.AspNet.Web.Optimization.WebForms` should be removed (*incompatible, no supported version*)
  - `Microsoft.Bcl.HashCode` should be updated from `1.1.1` to `6.0.0` (*recommended for .NET 8.0*)
  - `Microsoft.CodeDom.Providers.DotNetCompilerPlatform` should be removed (*functionality included with framework*)
  - `Microsoft.Web.Infrastructure` should be removed (*functionality included with framework*)
  - `Newtonsoft.Json` should be updated from `12.0.2` to `13.0.4` (*security vulnerability*)
  - `System.Buffers` should be removed (*functionality included with framework*)
  - `System.IO` should be removed (*functionality included with framework*)
  - `System.Memory` should be removed (*functionality included with framework*)
  - `System.Net.Http` should be removed (*functionality included with framework*)
  - `System.Numerics.Vectors` should be removed (*functionality included with framework*)
  - `System.Runtime` should be removed (*functionality included with framework*)
  - `System.Runtime.CompilerServices.Unsafe` should be updated from `4.7.0` to `6.1.2` (*recommended for .NET 8.0*)
  - `System.Security.Cryptography.Algorithms` should be removed (*functionality included with framework*)
  - `System.Security.Cryptography.Encoding` should be removed (*functionality included with framework*)
  - `System.Security.Cryptography.Primitives` should be removed (*functionality included with framework*)
  - `System.Security.Cryptography.X509Certificates` should be removed (*functionality included with framework*)
