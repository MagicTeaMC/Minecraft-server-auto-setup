use std::{fs, io::Write};

fn download_jar(res: reqwest::blocking::Response) -> Result<(), Box<dyn std::error::Error>> {
    let mut file = fs::File::create("server.jar")?;
    file.write_all(&res.bytes().unwrap())?;
    Ok(())
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
            "https://fill.papermc.io/v3/projects/{}/versions/{}/builds",
            software, version
        ))
        .send();

    if let Ok(res) = res {
        let builds: serde_json::Value = res.json()?;

        let builds_array = builds
            .as_array()
            .ok_or("Invalid response format: expected array of builds")?;

        if builds_array.is_empty() {
            return Err(format!("No builds available for {} version {}", software, version).into());
        }

        let latest_build = &builds_array[0];

        // Extract the download URL from the build object
        let download_url = latest_build["downloads"]["server:default"]["url"]
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
        Err(format!("failed to fetch builds for {}", software).into())
    }
}

pub fn get(name: String, version: String) -> Result<(), Box<dyn std::error::Error>> {
    match name.as_str() {
        "purpur" => get_purpur(version),
        _ => get_other(name, version),
    }
}
