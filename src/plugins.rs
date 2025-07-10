use crate::config::{Config, PluginConfig};
use crate::modrinth::ModrinthClient;
use crate::software::Software;
use colored::Colorize;
use std::fs;
use std::path::Path;

const PLUGINS_DIR: &str = "plugins";

pub async fn list_plugins() -> Result<(), Box<dyn std::error::Error>> {
    let config = Config::load()?;

    if config.plugins.is_empty() {
        println!("No plugins installed.");
        return Ok(());
    }

    println!("{}", "Installed Plugins".bold().underline());
    for plugin in &config.plugins {
        println!(
            "  {} {} {} {}{}{}",
            "•".green(),
            plugin.name.bold().yellow(),
            plugin.version.blue(),
            "(".dimmed(),
            plugin.loader.dimmed(),
            ")".dimmed()
        );
    }

    Ok(())
}

pub async fn get_plugin(name: &str, force: bool) -> Result<(), Box<dyn std::error::Error>> {
    let mut config = Config::load()?;
    ensure_plugins_dir()?;

    let client = ModrinthClient::new();

    // Get project info
    let project = client.get_project(name).await?;

    // Get compatible loaders for current software
    let compatible_loaders = get_compatible_loaders(&config.software);

    // Get versions
    let versions = client
        .get_project_versions(
            &project.project_id,
            &[config.minecraft_version.clone()],
            &compatible_loaders,
            if force { None } else { Some("release") },
        )
        .await?;

    if versions.is_empty() {
        return Err(format!(
            "No compatible versions found for {} on {} {}",
            project.title,
            config.software.name(),
            config.minecraft_version
        )
        .into());
    }

    let version = &versions[0];
    let file = version
        .files
        .iter()
        .find(|f| f.primary)
        .unwrap_or(&version.files[0]);

    // Check loader compatibility
    if !force
        && !version
            .loaders
            .iter()
            .any(|l| compatible_loaders.contains(l))
    {
        return Err(format!(
            "Plugin {} is not compatible with {}. Use --force to override.",
            project.title,
            config.software.name()
        )
        .into());
    }

    println!(
        "📦 Installing {} {} for {} {}...",
        project.title.bold().yellow(),
        version.version_number.bold().blue(),
        config.software.name().bold(),
        config.minecraft_version.bold()
    );

    // Download file
    let plugin_path = Path::new(PLUGINS_DIR).join(&file.filename);
    print!("Downloading... ");
    std::io::Write::flush(&mut std::io::stdout()).unwrap();

    client.download_file(&file.url, &plugin_path).await?;
    println!("{}", "✅ done!".bold().green());

    // Update config
    let plugin_config = PluginConfig {
        name: project.title.clone(),
        project_id: project.project_id.clone(),
        version: version.version_number.clone(),
        source: "modrinth".to_string(),
        filename: file.filename.clone(),
        loader: version.loaders[0].clone(),
    };

    config.add_plugin(plugin_config);
    config.save()?;

    println!(
        "✅ {} installed successfully!",
        project.title.bold().green()
    );
    Ok(())
}

pub async fn update_plugins(target: &str, force: bool) -> Result<(), Box<dyn std::error::Error>> {
    let mut config = Config::load()?;

    if target == "all" {
        if config.plugins.is_empty() {
            println!("No plugins to update.");
            return Ok(());
        }

        println!("🔄 Updating all plugins...");
        let plugins_to_update: Vec<_> = config.plugins.iter().map(|p| p.name.clone()).collect();

        for plugin_name in plugins_to_update {
            if let Err(e) = update_single_plugin(&mut config, &plugin_name, force).await {
                println!("❌ Failed to update {}: {}", plugin_name.bold().red(), e);
            }
        }
    } else {
        update_single_plugin(&mut config, target, force).await?;
    }

    config.save()?;
    Ok(())
}

async fn update_single_plugin(
    config: &mut Config,
    name: &str,
    force: bool,
) -> Result<(), Box<dyn std::error::Error>> {
    let plugin = config
        .get_plugin(name)
        .ok_or_else(|| format!("Plugin '{}' not found", name))?
        .clone();

    let client = ModrinthClient::new();
    let compatible_loaders = get_compatible_loaders(&config.software);

    let versions = client
        .get_project_versions(
            &plugin.project_id,
            &[config.minecraft_version.clone()],
            &compatible_loaders,
            if force { None } else { Some("release") },
        )
        .await?;

    if versions.is_empty() {
        return Err("No compatible versions found".into());
    }

    let latest_version = &versions[0];

    if latest_version.version_number == plugin.version {
        println!("✅ {} is already up to date", plugin.name.bold().green());
        return Ok(());
    }

    let file = latest_version
        .files
        .iter()
        .find(|f| f.primary)
        .unwrap_or(&latest_version.files[0]);

    // Remove old file
    let old_path = Path::new(PLUGINS_DIR).join(&plugin.filename);
    if old_path.exists() {
        fs::remove_file(&old_path)?;
    }

    // Download new file
    let new_path = Path::new(PLUGINS_DIR).join(&file.filename);
    print!(
        "Updating {} to {}... ",
        plugin.name.bold().yellow(),
        latest_version.version_number.bold().blue()
    );
    std::io::Write::flush(&mut std::io::stdout()).unwrap();

    client.download_file(&file.url, &new_path).await?;
    println!("{}", "✅ done!".bold().green());

    // Update config
    let updated_plugin = PluginConfig {
        name: plugin.name,
        project_id: plugin.project_id,
        version: latest_version.version_number.clone(),
        source: plugin.source,
        filename: file.filename.clone(),
        loader: latest_version.loaders[0].clone(),
    };

    config.add_plugin(updated_plugin);
    Ok(())
}

pub async fn remove_plugin(name: &str) -> Result<(), Box<dyn std::error::Error>> {
    let mut config = Config::load()?;

    let plugin = config
        .get_plugin(name)
        .ok_or_else(|| format!("Plugin '{}' not found", name))?
        .clone();

    // Remove file
    let plugin_path = Path::new(PLUGINS_DIR).join(&plugin.filename);
    if plugin_path.exists() {
        fs::remove_file(&plugin_path)?;
    }

    // Update config
    if config.remove_plugin(name) {
        config.save()?;
        println!("✅ {} removed successfully!", name.bold().green());
    } else {
        return Err(format!("Failed to remove plugin '{}'", name).into());
    }

    Ok(())
}

pub async fn search_plugins(query: &str, limit: u32) -> Result<(), Box<dyn std::error::Error>> {
    let config = Config::load()?;
    let client = ModrinthClient::new();
    let compatible_loaders = get_compatible_loaders(&config.software);

    let results = client
        .search_projects(
            query,
            limit,
            &compatible_loaders,
            &[config.minecraft_version.clone()],
        )
        .await?;

    if results.hits.is_empty() {
        println!("No plugins found matching '{}'", query);
        return Ok(());
    }

    println!(
        "{} {}",
        "Search Results".bold().underline(),
        format!("({} found)", results.total_hits).dimmed()
    );

    for project in &results.hits {
        println!(
            "  {} {} {}",
            "•".green(),
            project.title.bold().yellow(),
            project.description.dimmed()
        );
        println!(
            "    {} {} downloads | {} {}",
            "↓".blue(),
            project.downloads,
            "ID:".dimmed(),
            project.slug.dimmed()
        );
    }

    Ok(())
}

pub async fn show_plugin_info(name: &str) -> Result<(), Box<dyn std::error::Error>> {
    let config = Config::load()?;
    let client = ModrinthClient::new();

    let project = client.get_project(name).await?;
    let compatible_loaders = get_compatible_loaders(&config.software);

    let versions = client
        .get_project_versions(
            &project.project_id,
            &[config.minecraft_version.clone()],
            &compatible_loaders,
            Some("release"),
        )
        .await?;

    println!("{}", project.title.bold().underline());
    println!("  {}: {}", "Description".bold(), project.description);
    println!("  {}: {}", "Downloads".bold(), project.downloads);
    println!("  {}: {}", "Follows".bold(), project.follows);
    println!("  {}: {}", "Project ID".bold(), project.project_id);
    println!(
        "  {}: {}",
        "Categories".bold(),
        project.categories.join(", ")
    );

    if !project.loaders.is_empty() {
        println!(
            "  {}: {}",
            "Supported Loaders".bold(),
            project.loaders.join(", ")
        );
    }

    if !versions.is_empty() {
        println!(
            "  {}: {}",
            "Latest Compatible Version".bold(),
            versions[0].version_number.green()
        );
    } else {
        println!("  {}: {}", "Compatible Versions".bold().red(), "None found");
    }

    Ok(())
}

pub async fn load_plugins_from_config(config_path: &str) -> Result<(), Box<dyn std::error::Error>> {
    let content = fs::read_to_string(config_path)?;
    let plugin_configs: Vec<PluginConfig> = serde_json::from_str(&content)?;

    ensure_plugins_dir()?;

    for plugin_config in plugin_configs {
        println!(
            "Installing {} from config...",
            plugin_config.name.bold().yellow()
        );
        if let Err(e) = get_plugin(&plugin_config.project_id, false).await {
            println!(
                "❌ Failed to install {}: {}",
                plugin_config.name.bold().red(),
                e
            );
        }
    }

    Ok(())
}

fn get_compatible_loaders(software: &Software) -> Vec<String> {
    match software.name().as_str() {
        "folia" => vec!["folia".to_string()],
        "paper" => vec![
            "bukkit".to_string(),
            "spigot".to_string(),
            "paper".to_string(),
        ],
        "purpur" => vec![
            "bukkit".to_string(),
            "spigot".to_string(),
            "paper".to_string(),
            "purpur".to_string(),
        ],
        "velocity" => vec!["velocity".to_string()],
        _ => vec!["bukkit".to_string()], // Default fallback
    }
}

pub async fn export_plugins_config(output_path: &str) -> Result<(), Box<dyn std::error::Error>> {
    let config = Config::load()?;

    if config.plugins.is_empty() {
        println!("No plugins to export.");
        return Ok(());
    }

    let content = serde_json::to_string_pretty(&config.plugins)?;
    fs::write(output_path, content)?;

    println!(
        "✅ Exported {} plugins to {}",
        config.plugins.len().to_string().bold().green(),
        output_path.bold().yellow()
    );

    Ok(())
}

fn ensure_plugins_dir() -> Result<(), Box<dyn std::error::Error>> {
    if !Path::new(PLUGINS_DIR).exists() {
        fs::create_dir(PLUGINS_DIR)?;
    }
    Ok(())
}
