use std::{io::Write, process::exit};
use colored::Colorize;
use inquire::Text;
use anyhow::Result;

use crate::core::Config;
use crate::download;
use crate::utils::{inquired, print_error_and_exit};

pub async fn handle_upgrade(target_version: Option<String>) -> Result<()> {
    let mut config = Config::load()?;

    let target_version = {
        if target_version.is_none() {
            if !config.software.supports_upgrade() {
                let not_supported_message = format!(
                    "❌ {} upgrades are currently unsupported.",
                    config.software.name()
                );
                return Err(anyhow::anyhow!("{}", not_supported_message));
            } else {
                let binding =
                    Text::new("🚀 What version of Minecraft would you like to upgrade to?")
                        .with_placeholder("e.g., 1.21.1")
                        .prompt();

                inquired::<String>(binding)
            }
        } else {
            target_version.unwrap()
        }
    };

    println!(
        "⬆️  Upgrading {} from version {} to {}...",
        config.software.name().bold().yellow(),
        config.minecraft_version.bold().blue(),
        target_version.bold().green()
    );

    print!(
        "(1/2) Downloading {}... ",
        config.software.name().cyan().bold()
    );
    std::io::stdout().flush()?;

    match download::get(&config.software.name(), target_version.clone()).await {
        Err(e) => {
            println!();
            println!("{}: {}", "error".bold().red(), e);
            exit(-1);
        }
        Ok(_) => println!("{}", "✅ done!".bold().green()),
    }

    config.minecraft_version = target_version.clone();

    print!("(2/2) Updating configuration... ");
    match config.save() {
        Err(e) => print_error_and_exit("failed to update config", e),
        Ok(_) => println!("{}", "✅ done!".bold().green()),
    }

    println!("\n{}", "Summary".bold().underline());
    println!(
        "  {} server.jar {} {}{}",
        "↗".green().bold(),
        "(upgraded to".dimmed(),
        target_version.dimmed(),
        ")".dimmed()
    );
    println!(
        "  {} {} {}",
        "↻".green().bold(),
        Config::config_file(),
        "(updated)".dimmed()
    );

    Ok(())
}
