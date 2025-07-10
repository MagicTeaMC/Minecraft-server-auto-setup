use std::{io::Write, process::exit};

use clap::Parser;
use colored::Colorize;
use inquire::{Confirm, Select, Text};

mod cli;
mod config;
mod eula;
mod get_files;
mod modrinth;
mod plugins;
mod software;
mod utils;

use cli::{CLI, Commands, PluginActions};
use config::Config;
use software::Software;
use utils::{get_current_directory_name, get_executable_extension, inquired, print_error_and_exit};

fn handle_setup(
    software: Option<Software>,
    mc_version: Option<String>,
    eula: Option<bool>,
    yes: bool,
) -> Result<(), Box<dyn std::error::Error>> {
    let software = {
        if software.is_none() {
            let binding = Select::new(
                "💽 Which server software are you using?",
                Software::display_names(),
            )
            .prompt();

            Software::from_name(inquired(binding).to_lowercase().to_string())
        } else {
            software.unwrap()
        }
    };

    let version = {
        if !software.supports_minecraft_version() {
            software.default_version()
        } else if software.name() == "velocity" {
            "3.4.0-SNAPSHOT".to_string()
        } else if mc_version.is_none() {
            let binding = Text::new("🪨  What version of Minecraft are you using?")
                .with_default(&software.default_version())
                .prompt();

            inquired::<String>(binding)
        } else {
            mc_version.unwrap()
        }
    };

    let eula = {
        if !software.requires_eula() {
            false
        } else if eula.is_none() {
            let binding = Confirm::new(
                format!(
                    "📄 Do you agree to the {}?",
                    "\x1B]8;;https://www.minecraft.net/en-us/eula\x1B\\Mojang EULA\x1B]8;;\x1B\\"
                        .purple()
                )
                .as_str(),
            )
            .with_placeholder("Y/n")
            .prompt();

            inquired::<bool>(binding)
        } else {
            eula.unwrap()
        }
    };

    if software.requires_eula() {
        println!(
            "\n✨ I will setup {}, with Minecraft server version {}, {} Mojang's EULA in this directory {}{}{}.",
            software.name().bold().yellow(),
            version.bold().blue(),
            {
                if eula {
                    "accepting".bold().green()
                } else {
                    "denying".bold().red()
                }
            },
            "(".dimmed(),
            get_current_directory_name().dimmed(),
            ")".dimmed()
        );
    } else {
        println!(
            "\n✨ I will setup {} in this directory {}{}{}.",
            software.name().bold().yellow(),
            "(".dimmed(),
            get_current_directory_name().dimmed(),
            ")".dimmed()
        );
    }

    if !yes {
        match Confirm::new("Proceed?").with_default(true).prompt() {
            Ok(result) => {
                if !result {
                    println!(
                        "\n🎏 You can pass `setup --software={} --mc-version={} --eula={}` to get everything up and running!\n",
                        software.name().bold().yellow(),
                        version.bold().blue(),
                        {
                            if eula {
                                "true".bold().green()
                            } else {
                                "false".bold().red()
                            }
                        }
                    );
                    println!("{}: aborted", "warning".yellow().bold());
                    exit(-1);
                }
            }
            Err(e) => print_error_and_exit("failed to inquire", e),
        }
    }

    println!();

    if eula && software.requires_eula() {
        print!("(1/3) Adding EULA... ");
        match eula::add_eula() {
            Err(e) => print_error_and_exit("failed to add EULA", e),
            Ok(_) => println!("{}", "✅ done!".bold().green()),
        }
    }

    print!(
        "{}Downloading {}... ",
        {
            if eula && software.requires_eula() {
                "(2/3) "
            } else {
                "(1/2) "
            }
        },
        software.name().cyan().bold()
    );
    std::io::stdout().flush()?;

    match get_files::get(software.name(), version.clone()) {
        Err(e) => {
            println!();
            println!("{}: {}", "error".bold().red(), e);
            exit(-1);
        }
        Ok(_) => println!("{}", "✅ done!".bold().green()),
    }

    print!("{}Saving configuration... ", {
        if eula && software.requires_eula() {
            "(3/3) "
        } else {
            "(2/2) "
        }
    });

    let config = Config {
        software: software.clone(),
        minecraft_version: version.clone(),
        eula_accepted: eula,
        plugins: Vec::new(),
    };

    match config.save() {
        Err(e) => print_error_and_exit("failed to save config", e),
        Ok(_) => println!("{}", "✅ done!".bold().green()),
    }

    println!("\n{}", "Summary".bold().underline());
    if eula && software.requires_eula() {
        println!("  {} eula.txt", "+".green().bold());
    }

    let need_exe = get_executable_extension();

    if software.name() == "gate" {
        println!(
            "  {} gate{} {}{}{}",
            "+".green().bold(),
            need_exe,
            "(".dimmed(),
            software.name().dimmed(),
            ")".dimmed()
        );
    } else {
        println!(
            "  {} server.jar {}{}{}",
            "+".green().bold(),
            "(".dimmed(),
            software.name().dimmed(),
            ")".dimmed()
        );
    }

    println!("  {} {}", "+".green().bold(), Config::config_file());

    Ok(())
}

fn handle_update() -> Result<(), Box<dyn std::error::Error>> {
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

    match get_files::get(config.software.name(), config.minecraft_version.clone()) {
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

fn handle_upgrade(target_version: Option<String>) -> Result<(), Box<dyn std::error::Error>> {
    let mut config = Config::load()?;

    let target_version = {
        if target_version.is_none() {
            if !config.software.supports_upgrade() {
                let not_supported_message = format!(
                    "❌ {} upgrades are currently unsupported.",
                    config.software.name()
                );
                return Err(not_supported_message.into());
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

    match get_files::get(config.software.name(), target_version.clone()) {
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

async fn handle_plugins(action: PluginActions) -> Result<(), Box<dyn std::error::Error>> {
    match action {
        PluginActions::List => plugins::list_plugins().await,
        PluginActions::Add { name, force } => plugins::get_plugin(&name, force).await,
        PluginActions::Load { config } => plugins::load_plugins_from_config(&config).await,
        PluginActions::Update { target, force } => plugins::update_plugins(&target, force).await,
        PluginActions::Remove { name } => plugins::remove_plugin(&name).await,
        PluginActions::Search { query, limit } => plugins::search_plugins(&query, limit).await,
        PluginActions::Info { name } => plugins::show_plugin_info(&name).await,
        PluginActions::Export { output } => plugins::export_plugins_config(&output).await,
    }
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let cli = CLI::parse();

    match cli.command {
        Commands::Setup {
            software,
            mc_version,
            eula,
            yes,
        } => handle_setup(software, mc_version, eula, yes),
        Commands::Update => handle_update(),
        Commands::Upgrade { version } => handle_upgrade(version),
        Commands::Plugins { action } => {
            let rt = tokio::runtime::Runtime::new()?;
            rt.block_on(handle_plugins(action))
        }
    }
}
