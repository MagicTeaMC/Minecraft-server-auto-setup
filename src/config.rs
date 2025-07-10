use crate::software::Software;
use serde::{Deserialize, Serialize};
use std::{fs, path::Path};

const CONFIG_FILE: &str = "mcsast.config.json";

#[derive(Serialize, Deserialize)]
pub struct Config {
    pub software: Software,
    pub minecraft_version: String,
    pub eula_accepted: bool,
}

impl Config {
    pub fn load() -> Result<Self, Box<dyn std::error::Error>> {
        if !Path::new(CONFIG_FILE).exists() {
            return Err("No config file found. Please run 'mcsast setup' first.".into());
        }

        let content = fs::read_to_string(CONFIG_FILE)?;
        let config: Config = serde_json::from_str(&content)?;
        Ok(config)
    }

    pub fn save(&self) -> Result<(), Box<dyn std::error::Error>> {
        let content = serde_json::to_string_pretty(self)?;
        fs::write(CONFIG_FILE, content)?;
        Ok(())
    }

    pub fn config_file() -> &'static str {
        CONFIG_FILE
    }
}
