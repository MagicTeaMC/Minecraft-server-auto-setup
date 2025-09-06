use std::{io::Write, process::exit};
use colored::Colorize;
use anyhow::Result;

use crate::core::Config;
use crate::download;
use crate::utils::get_executable_extension;

pub async fn handle_sync() -> Result<()> {
    let config = Config::load()?;

    if !config.software.supports_minecraft_version() {
        println!(
            "🔄 Syncing {} to latest build...",
            config.software.name().bold().yellow()
        );
    } else {
        println!(
            "🔄 Syncing {}-{} to latest build...",
            config.software.name().bold().yellow(),
            config.minecraft_version.bold().blue()
        );
    }

    print!(
        "(1/1) Downloading latest {}... ",
        config.software.name().cyan().bold()
    );
    std::io::stdout().flush()?;

    match download::get(&config.software.name(), config.minecraft_version.clone()).await {
        Err(e) => {
            println!();
            println!("{}: {}", "error".bold().red(), e);
            exit(-1);
        }
        Ok(_) => println!("{}", "✅ done!".bold().green()),
    }

    let need_exe = get_executable_extension();

    println!("\n{}", "Summary".bold().underline());
    if config.software.name() != "gate" {
        println!(
            "  {} server.jar {}",
            "↻".green().bold(),
            "(synced to latest build)".dimmed()
        );
    } else {
        println!(
            "  {} gate{} {}",
            "↻".green().bold(),
            need_exe,
            "(synced to latest build)".dimmed()
        );
    }

    Ok(())
}
