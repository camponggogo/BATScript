for %%v in (%dotnet_versions%) do (
    for /f "tokens=1,2 delims=:" %%a in ("%%v") do (
        :: Downloading .NET Framework installer
        echo Downloading .NET Framework %%a...
	:: Silently installing .NET Framework
        echo %%a
    )
)