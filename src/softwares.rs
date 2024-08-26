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
        Err(format!("failed to download purpur").into())
    }
}

pub fn get_other(software: String, version: String) -> Result<(), Box<dyn std::error::Error>> {
    let client = reqwest::blocking::Client::new();
    let res = client
        .get(format!(
            "https://api.papermc.io/v2/projects/{}/versions/{}/builds",
            software, version
        ))
        .send();

    if let Ok(res) = res {
        let json: serde_json::Value = res.json()?;

        let latest_build = json["builds"]
            .as_array()
            .unwrap_or(&vec![])
            .iter()
            .filter_map(|build| build["build"].as_u64())
            .max();

        if let Some(latest_build) = latest_build {
            let jar_name = format!("{}-{}-{}.jar", software, version, latest_build);
            let res = client
                .get(format!(
                    "https://api.papermc.io/v2/projects/{}/versions/{}/builds/{}/downloads/{}",
                software, version, latest_build, jar_name
                ))
                .send();
            if let Ok(res) = res {
                download_jar(res)?;
                Ok(())
            } else {
                Err(format!("failed to download {}", software).into())
            }
        } else {
            Err(format!("failed to download {}", software).into())
        }
    } else {
        Err(format!("failed to download {}", software).into())
    }
}

pub fn get(name: String, version: String) -> Result<(), Box<dyn std::error::Error>> {
    match name.as_str() {
        "Purpur" => get_purpur(version),
        _ => get_other(name, version),
    }
}