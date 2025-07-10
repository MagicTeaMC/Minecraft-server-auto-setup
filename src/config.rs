use crate::software::Software;
use serde::{Deserialize, Serialize};
use std::{fs, path::Path};

const CONFIG_FILE: &str = "mcsast.config.json";

#[derive(Serialize, Deserialize, Clone)]
pub struct PluginConfig {
    pub name: String,
    pub project_id: String,
    pub version: String,
    pub source: String,
    pub filename: String,
    pub loader: String,
}

#[derive(Serialize, Deserialize)]
pub struct Config {
    pub software: Software,
    pub minecraft_version: String,
    pub eula_accepted: bool,
    #[serde(default)]
    pub plugins: Vec<PluginConfig>,
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

    pub fn add_plugin(&mut self, plugin: PluginConfig) {
        // Remove existing plugin with same name if exists
        self.plugins.retain(|p| p.name != plugin.name);
        self.plugins.push(plugin);
    }

    pub fn remove_plugin(&mut self, name: &str) -> bool {
        let initial_len = self.plugins.len();
        self.plugins.retain(|p| p.name != name);
        self.plugins.len() != initial_len
    }

    pub fn get_plugin(&self, name: &str) -> Option<&PluginConfig> {
        self.plugins.iter().find(|p| p.name == name)
    }
}
