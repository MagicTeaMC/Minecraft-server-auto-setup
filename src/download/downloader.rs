use tokio::fs;
use anyhow::Result;

async fn download_jar(res: reqwest::Response) -> Result<()> {
    let bytes = res.bytes().await?;
    fs::write("server.jar", &bytes).await?;
    Ok(())
}

async fn download_binary(
    res: reqwest::Response,
    filename: &str,
) -> Result<()> {
    let bytes = res.bytes().await?;
    fs::write(filename, &bytes).await?;

    // Make it executable
    #[cfg(unix)]
    {
        use std::os::unix::fs::PermissionsExt;
        let metadata = fs::metadata(filename).await?;
        let mut perms = metadata.permissions();
        perms.set_mode(0o755);
        fs::set_permissions(filename, perms).await?;
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

pub async fn get_geyser(_version: String) -> Result<()> {
    let client = reqwest::Client::builder()
        .timeout(std::time::Duration::from_secs(120))
        .build()?;

    let url = "https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest/downloads/standalone";
    let res = client.get(url).send().await?;

    if res.status().is_success() {
        download_jar(res).await?;
        Ok(())
    } else {
        Err(anyhow::anyhow!("Failed to download Geyser: HTTP {}", res.status()))
    }
}

pub async fn get_nukkit(_version: String) -> Result<()> {
    let client = reqwest::Client::builder()
        .timeout(std::time::Duration::from_secs(120))
        .build()?;

    let url = "https://repo.opencollab.dev/api/maven/latest/file/maven-snapshots/cn/nukkit/nukkit/1.0-SNAPSHOT?extension=jar";
    let res = client.get(url).send().await?;

    if res.status().is_success() {
        download_jar(res).await?;
        Ok(())
    } else {
        Err(anyhow::anyhow!("Failed to download Nukkit: HTTP {}", res.status()))
    }
}

pub async fn get_gate(_version: String) -> Result<()> {
    let (os, arch, ext) = get_platform_info();
    let filename = format!("gate{}", ext);
    let client = reqwest::Client::new();

    // Get latest version
    let api_res = client
        .get("https://api.github.com/repos/minekube/gate/releases/latest")
        .header("User-Agent", "Mozilla/5.0")
        .send()
        .await?;

    let release: serde_json::Value = api_res.json().await?;
    let tag_name = release["tag_name"]
        .as_str()
        .ok_or_else(|| anyhow::anyhow!("Tag name not found in release response"))?;
    let version = tag_name.strip_prefix('v').unwrap_or(tag_name);

    let url = format!(
        "https://github.com/minekube/gate/releases/download/{}/gate_{}_{}_{}{}",
        tag_name, version, os, arch, ext
    );

    let res = client.get(&url).send().await?;
    if res.status().is_success() {
        download_binary(res, &filename).await?;
        Ok(())
    } else {
        Err(anyhow::anyhow!("Failed to download Gate: HTTP {}", res.status()))
    }
}

pub async fn get_purpur(version: String) -> Result<()> {
    let client = reqwest::Client::new();
    let url = format!(
        "https://api.purpurmc.org/v2/purpur/{}/latest/download",
        version
    );

    let res = client.get(&url).send().await;
    match res {
        Ok(response) => {
            if response.status().is_success() {
                download_jar(response).await?;
                Ok(())
            } else {
                Err(anyhow::anyhow!(
                    "Failed to download Purpur for version {} (HTTP {}). This version might not exist.",
                    version,
                    response.status()
                ))
            }
        }
        Err(e) => Err(anyhow::anyhow!("Failed to connect to Purpur API: {}", e)),
    }
}

pub async fn get_other(software: String, version: String) -> Result<()> {
    let client = reqwest::Client::new();
    let res = client
        .get(format!(
            "https://fill.papermc.io/v3/projects/{}/versions/{}/builds/latest",
            software, version
        ))
        .send()
        .await?;

    if !res.status().is_success() {
        if res.status() == 404 {
            return Err(anyhow::anyhow!(
                "Version {} not found for {}. Please check if this version exists.",
                version, software
            ));
        } else {
            return Err(anyhow::anyhow!(
                "API returned HTTP {} when fetching build info.",
                res.status()
            ));
        }
    }

    let build: serde_json::Value = res.json().await?;

    // Extract the download URL from the build object
    let download_url = build["downloads"]["server:default"]["url"]
        .as_str()
        .ok_or_else(|| anyhow::anyhow!("Download URL not found in build response"))?;

    // Download the jar file directly using the provided URL
    let download_res = client.get(download_url).send().await?;

    if download_res.status().is_success() {
        download_jar(download_res).await?;
        Ok(())
    } else {
        Err(anyhow::anyhow!(
            "Failed to download {}: HTTP {}",
            software,
            download_res.status()
        ))
    }
}

pub async fn get(software: &str, version: String) -> Result<()> {
    match software {
        "paper" | "folia" | "velocity" => get_other(software.to_string(), version).await,
        "purpur" => get_purpur(version).await,
        "gate" => get_gate(version).await,
        "nukkit" => get_nukkit(version).await,
        "geyser" => get_geyser(version).await,
        _ => Err(anyhow::anyhow!("Unsupported software: {}", software)),
    }
}
