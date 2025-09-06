use std::{io::Write, process::exit};
use colored::Colorize;

use crate::core::Config;
use crate::download;
use crate::utils::get_executable_extension;

pub fn handle_update() -> Result<(), Box<dyn std::error::Error>> {
    let config = Config::load()?;

    if !config.software.supports_minecraft_version() {
        println!(
            "🔄 Updating {} to latest build...",
            config.software.name().bold().yellow()
        );
    } else {
        println!(
            "🔄 Updating {}-{} to latest build...",
            config.software.name().bold().yellow(),
            config.minecraft_version.bold().blue()
        );
    }

    print!(
        "(1/1) Downloading latest {}... ",
        config.software.name().cyan().bold()
    );
    std::io::stdout().flush()?;

    match download::get(config.software.name(), config.minecraft_version.clone()) {
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
            "(updated to latest build)".dimmed()
        );
    } else {
        println!(
            "  {} gate{} {}",
            "↻".green().bold(),
            need_exe,
            "(updated to latest build)".dimmed()
        );
    }

    Ok(())
}
