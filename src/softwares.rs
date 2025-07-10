use std::{fs, io::Write};

fn download_jar(res: reqwest::blocking::Response) -> Result<(), Box<dyn std::error::Error>> {
    let mut file = fs::File::create("server.jar")?;
    let bytes = res.bytes()?;
    file.write_all(&bytes)?;
    Ok(())
}

fn download_binary(
    res: reqwest::blocking::Response,
    filename: &str,
) -> Result<(), Box<dyn std::error::Error>> {
    let mut file = fs::File::create(filename)?;
    file.write_all(&res.bytes().unwrap())?;

    // Make it executable
    #[cfg(unix)]
    {
        use std::os::unix::fs::PermissionsExt;
        let mut perms = file.metadata()?.permissions();
        perms.set_mode(0o755);
        fs::set_permissions(filename, perms)?;
    }

    Ok(())
}

fn get_platform_info() -> (String, String, String) {
    let os = match std::env::consts::OS {
        "linux" => "linux",
        "macos" => "darwin",
        "windows" => "windows",
        _ => "linux", // fallback
    };

    let arch = match std::env::consts::ARCH {
        "x86_64" => "amd64",
        "aarch64" => "arm64",
        "x86" => "386",
        _ => "amd64", // fallback
    };

    let ext = if os == "windows" { ".exe" } else { "" };

    (os.to_string(), arch.to_string(), ext.to_string())
}

pub fn get_nukkit(_version: String) -> Result<(), Box<dyn std::error::Error>> {
    let client = reqwest::blocking::Client::builder()
        .timeout(std::time::Duration::from_secs(120))
        .build()?;
    
    let url = "https://repo.opencollab.dev/api/maven/latest/file/maven-snapshots/cn/nukkit/nukkit/1.0-SNAPSHOT?extension=jar";
    
    let res = client.get(url).send()?;

    if res.status().is_success() {
        download_jar(res)?;
        Ok(())
    } else {
        Err(format!("Failed to download Nukkit: HTTP {}", res.status()).into())
    }
}

pub fn get_gate(_version: String) -> Result<(), Box<dyn std::error::Error>> {
    let (os, arch, ext) = get_platform_info();
    let filename = format!("gate{}", ext);

    let client = reqwest::blocking::Client::new();

    // Get latest version
    let api_res = client
        .get("https://api.github.com/repos/minekube/gate/releases/latest")
        .header("User-Agent", "Mozilla/5.0")
        .send()?;

    let release: serde_json::Value = api_res.json()?;
    let tag_name = release["tag_name"]
        .as_str()
        .ok_or("Tag name not found in release response")?;

    let version = tag_name.strip_prefix('v').unwrap_or(tag_name);

    let url = format!(
        "https://github.com/minekube/gate/releases/download/{}/gate_{}_{}_{}{}",
        tag_name, version, os, arch, ext
    );

    let res = client.get(&url).send()?;

    if res.status().is_success() {
        download_binary(res, &filename)?;
        Ok(())
    } else {
        Err(format!("Failed to download Gate: HTTP {}", res.status()).into())
    }
}

pub fn get_purpur(version: String) -> Result<(), Box<dyn std::error::Error>> {
    let client = reqwest::blocking::Client::new();
    let res = client
        .get(format!(
            "https://api.purpurmc.org/v2/purpur/{}/latest/download",
            version
        ))
        .send();
    if let Ok(res) = res {
        download_jar(res)?;
        Ok(())
    } else {
        Err(format!("failed to download Purpur").into())
    }
}

pub fn get_other(software: String, version: String) -> Result<(), Box<dyn std::error::Error>> {
    let client = reqwest::blocking::Client::new();
    let res = client
        .get(format!(
            "https://fill.papermc.io/v3/projects/{}/versions/{}/builds/latest",
            software, version
        ))
        .send();

    if let Ok(res) = res {
        let build: serde_json::Value = res.json()?;

        // Extract the download URL from the build object
        let download_url = build["downloads"]["server:default"]["url"]
            .as_str()
            .ok_or("Download URL not found in build response")?;

        // Download the jar file directly using the provided URL
        let res = client.get(download_url).send();

        if let Ok(res) = res {
            download_jar(res)?;
            Ok(())
        } else {
            Err(format!("failed to download {} jar file", software).into())
        }
    } else {
        Err(format!("failed to fetch latest build for {}", software).into())
    }
}

pub fn get(name: String, version: String) -> Result<(), Box<dyn std::error::Error>> {
    match name.as_str() {
        "gate" => get_gate(version),
        "purpur" => get_purpur(version),
        "nukkit" => get_nukkit(version),
        _ => get_other(name, version),
    }
}
